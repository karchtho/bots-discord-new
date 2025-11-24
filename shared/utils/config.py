import os
from pathlib import Path
from typing import Any

import yaml
from dotenv import load_dotenv


class BaseConfig:
    """Configuration de base pour tous les bots"""
    def __init__(self, bot_name: str | None = None):
        self.bot_name = bot_name
        self.project_root = Path(__file__).parent.parent.parent
        self.load_environment()

    def load_environment(self):
        """Charge les variables d'environnement"""
        env_file = self.project_root / ".env"
        if env_file.exists():
            load_dotenv(env_file)

    def load_yaml_config(self, config_name: str) -> dict[str, Any]:
        """Charge un fichier YAML de configuration"""
        config_path = self.project_root / "configs" / f"{config_name}.yaml"
        if config_path.exists():
            with open(config_path, encoding='utf-8') as f:
                return yaml.safe_load(f)
        return {}

    @property
    def discord_token(self) -> str | None:
        token_key = f"{self.bot_name.upper()}_TOKEN" if self.bot_name else "DISCORD_TOKEN"
        return os.getenv(token_key)

    @property
    def environment(self) -> str:
        return os.getenv("ENVIRONMENT", "development") or "development"
