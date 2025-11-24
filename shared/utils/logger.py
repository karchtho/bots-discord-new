import logging
import logging.config
from pathlib import Path

import yaml


def setup_logger(bot_name: str) -> logging.Logger:
    """
    Configurer le logger pour un bot spécifique
    """

    config_path = Path(__file__).parent.parent.parent / "configs" / "logging.yaml"

    if config_path.exists():
        with open(config_path) as f:
            config = yaml.safe_load(f)
            logging.config.dictConfig(config)
    else:
            #Configuration pas défaut
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s %(levelname)s - %(message)s'
    )
    return logging.getLogger(f"bot.{bot_name}")
