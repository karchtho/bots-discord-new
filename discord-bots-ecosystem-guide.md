# Discord Bots Ecosystem - Architecture & Setup Guide

## 📋 Contexte du Projet

**Objectif :** Créer un écosystème de bots Discord évolutif, démarrant par un bot RSS TLDR Newsletter.

**Technologies :** Python, Discord.py, feedparser, architecture modulaire

**Étudiant :** Thomas - Formation web dev (PHP/JS), transition vers Python pour bots Discord

---

## 🏗️ Architecture du Projet

```
discord-bots-ecosystem/
├── 📁 shared/                          # Code partagé entre tous les bots
│   ├── __init__.py
│   ├── database/
│   │   ├── __init__.py
│   │   ├── models.py                   # Modèles de données
│   │   └── connection.py               # Connexion DB
│   ├── utils/
│   │   ├── __init__.py
│   │   ├── logger.py                   # Logging centralisé
│   │   ├── config.py                   # Configuration partagée
│   │   └── helpers.py                  # Fonctions utilitaires
│   ├── discord_utils/
│   │   ├── __init__.py
│   │   ├── embeds.py                   # Templates d'embeds
│   │   ├── permissions.py              # Gestion des permissions
│   │   └── decorators.py               # Décorateurs Discord
│   └── external_apis/
│       ├── __init__.py
│       ├── rss_client.py               # Client RSS réutilisable
│       └── web_scraper.py              # Web scraping utils
│
├── 📁 bots/                            # Dossier de tous les bots
│   ├── tldr_rss_bot/                   # Bot TLDR RSS (premier bot)
│   │   ├── __init__.py
│   │   ├── bot.py                      # Point d'entrée du bot
│   │   ├── config.py                   # Config spécifique
│   │   ├── cogs/                       # Modules Discord.py
│   │   │   ├── __init__.py
│   │   │   ├── rss_commands.py
│   │   │   └── admin_commands.py
│   │   ├── handlers/
│   │   │   ├── __init__.py
│   │   │   ├── rss_handler.py
│   │   │   └── feed_parser.py
│   │   ├── data/
│   │   │   ├── last_entries.json
│   │   │   └── feeds_config.json
│   │   └── requirements.txt            # Dépendances spécifiques
│   │
│   ├── moderation_bot/                 # Bot de modération (futur)
│   │   └── ... (structure similaire)
│   │
│   └── music_bot/                      # Bot musique (futur)
│       └── ... (structure similaire)
│
├── 📁 scripts/                         # Scripts d'administration
│   ├── deploy.py                       # Script de déploiement
│   ├── setup_bot.py                    # Setup automatique
│   └── backup.py                       # Sauvegarde
│
├── 📁 docs/                           # Documentation
│   ├── README.md
│   ├── architecture.md
│   └── bots/
│       ├── tldr_rss_bot.md
│       └── setup_guide.md
│
├── 📁 docker/                         # Conteneurisation
│   ├── Dockerfile.base                 # Image de base
│   ├── docker-compose.yml
│   └── bots/
│       └── tldr_rss_bot.dockerfile
│
├── 📁 tests/                          # Tests unitaires
│   ├── __init__.py
│   ├── test_shared/
│   ├── test_tldr_rss_bot/
│   └── conftest.py
│
├── 📁 configs/                        # Configurations globales
│   ├── logging.yaml
│   ├── database.yaml
│   └── environments/
│       ├── development.env
│       ├── staging.env
│       └── production.env
│
├── .env.example                       # Template des variables
├── .gitignore
├── requirements.txt                   # Dépendances globales
├── setup.py                          # Installation du package
└── manage.py                         # CLI de gestion
```

---

## 🚀 Étapes de Setup Détaillées

### 1. Setup Environnement Python

```bash
# Vérifier Python
python --version  # Besoin de Python 3.8+

# Créer le projet
mkdir discord-bots-ecosystem
cd discord-bots-ecosystem

# Environnement virtuel
python -m venv venv

# Activation
# Windows:
venv\Scripts\activate
# Mac/Linux:
source venv/bin/activate
```

### 2. VS Code Configuration

```bash
# Ouvrir dans VS Code
code .
```

**Extensions nécessaires :**
- Python (Microsoft)
- Python Docstring Generator
- autoDocstring

**Configuration VS Code :**
- `Ctrl+Shift+P` → "Python: Select Interpreter"
- Choisir `./venv/bin/python`

### 3. Discord Developer Setup

1. **Discord Developer Portal :** https://discord.com/developers/applications
2. **Nouvelle Application :** "TLDR Bot"
3. **Bot Tab :** Add Bot → Copy Token
4. **OAuth2 → URL Generator :**
   - Scopes: `bot`
   - Permissions: Send Messages, Embed Links, Read Message History
5. **Inviter le bot** sur le serveur Discord

### 4. Configuration des Variables

**Fichier .env :**
```env
# Discord Bot Configuration
DISCORD_TOKEN=TON_TOKEN_BOT_ICI
GUILD_ID=ID_DE_TON_SERVEUR_DISCORD
CHANNEL_ID=ID_DU_CANAL_VEILLE

# RSS Configuration
RSS_CHECK_INTERVAL=3600  # 1 heure en secondes

# Environment
ENVIRONMENT=development
```

**Pour récupérer les IDs :**
- Mode développeur Discord (Paramètres > Avancé > Mode développeur)
- Clic droit serveur/canal → "Copier l'ID"

---

## 📦 Dépendances & Requirements

### requirements.txt (racine)
```txt
# Discord
discord.py==2.3.2

# RSS
feedparser==6.0.10

# Configuration
python-dotenv==1.0.0
pyyaml>=6.0

# HTTP
aiohttp==3.8.6

# Base de données (futur)
sqlalchemy>=2.0.0
aiosqlite>=0.19.0

# Tests
pytest>=7.0.0
pytest-asyncio>=0.21.0

# Outils de dev
black>=23.0.0
flake8>=6.0.0
```

### bots/tldr_rss_bot/requirements.txt
```txt
# Dépendances spécifiques au bot RSS
feedparser==6.0.10
beautifulsoup4>=4.11.0  # Parsing HTML si nécessaire
dateparser>=1.1.0       # Parsing de dates
```

---

## 🔧 Code de Base - Fichiers Fondamentaux

### shared/utils/config.py
```python
import os
from pathlib import Path
from typing import Dict, Any
import yaml
from dotenv import load_dotenv

class BaseConfig:
    """Configuration de base pour tous les bots"""
    
    def __init__(self, bot_name: str = None):
        self.bot_name = bot_name
        self.project_root = Path(__file__).parent.parent.parent
        self.load_environment()
    
    def load_environment(self):
        """Charge les variables d'environnement"""
        env_file = self.project_root / ".env"
        if env_file.exists():
            load_dotenv(env_file)
    
    def load_yaml_config(self, config_name: str) -> Dict[str, Any]:
        """Charge un fichier YAML de configuration"""
        config_path = self.project_root / "configs" / f"{config_name}.yaml"
        if config_path.exists():
            with open(config_path, 'r', encoding='utf-8') as f:
                return yaml.safe_load(f)
        return {}
    
    @property
    def discord_token(self) -> str:
        token_key = f"{self.bot_name.upper()}_TOKEN" if self.bot_name else "DISCORD_TOKEN"
        return os.getenv(token_key)
    
    @property
    def environment(self) -> str:
        return os.getenv("ENVIRONMENT", "development")
```

### shared/utils/logger.py
```python
import logging
import logging.config
import yaml
from pathlib import Path

def setup_logger(bot_name: str) -> logging.Logger:
    """Configure le logger pour un bot spécifique"""
    
    config_path = Path(__file__).parent.parent.parent / "configs" / "logging.yaml"
    
    if config_path.exists():
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
        logging.config.dictConfig(config)
    else:
        # Configuration par défaut
        logging.basicConfig(
            level=logging.INFO,
            format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
        )
    
    return logging.getLogger(f"bot.{bot_name}")
```

### shared/discord_utils/embeds.py
```python
import discord
from datetime import datetime
from typing import Optional, Dict, Any

class EmbedTemplates:
    """Templates d'embeds réutilisables"""
    
    @staticmethod
    def info_embed(title: str, description: str, color: int = 0x3498db) -> discord.Embed:
        """Embed d'information standard"""
        embed = discord.Embed(
            title=title,
            description=description,
            color=color,
            timestamp=datetime.utcnow()
        )
        return embed
    
    @staticmethod
    def error_embed(title: str, description: str) -> discord.Embed:
        """Embed d'erreur"""
        return EmbedTemplates.info_embed(title, description, 0xe74c3c)
    
    @staticmethod
    def success_embed(title: str, description: str) -> discord.Embed:
        """Embed de succès"""
        return EmbedTemplates.info_embed(title, description, 0x2ecc71)
    
    @staticmethod
    def rss_article_embed(article: Dict[str, Any], feed_name: str) -> discord.Embed:
        """Embed pour un article RSS"""
        colors = {
            'tech': 0x00ff00,
            'webdev': 0x3498db,
            'ai': 0x9b59b6,
            'crypto': 0xf39c12
        }
        
        embed = discord.Embed(
            title=article.get('title', 'Sans titre'),
            url=article.get('link'),
            description=article.get('summary', 'Pas de description')[:250] + "...",
            color=colors.get(feed_name.lower(), 0x95a5a6),
            timestamp=datetime.utcnow()
        )
        
        embed.add_field(name="📂 Source", value=feed_name.upper(), inline=True)
        if 'published' in article:
            embed.add_field(name="📅 Publié", value=article['published'], inline=True)
        
        embed.set_footer(text="Bot RSS • Powered by Discord Bots Ecosystem")
        return embed
```

---

## 🤖 Bot TLDR RSS - Code Principal

### bots/tldr_rss_bot/config.py
```python
import os
from shared.utils.config import BaseConfig

class TLDRBotConfig(BaseConfig):
    def __init__(self):
        super().__init__("tldr_rss")
        
    # Discord Configuration
    @property
    def guild_id(self) -> int:
        return int(os.getenv('GUILD_ID'))
    
    @property
    def channel_id(self) -> int:
        return int(os.getenv('CHANNEL_ID'))
    
    # RSS Configuration
    @property
    def rss_feeds(self) -> dict:
        return {
            'tech': 'https://bullrich.dev/tldr-rss/tech.xml',
            'webdev': 'https://bullrich.dev/tldr-rss/webdev.xml',
            'ai': 'https://bullrich.dev/tldr-rss/ai.xml',
            'crypto': 'https://bullrich.dev/tldr-rss/crypto.xml'
        }
    
    @property
    def check_interval(self) -> int:
        return int(os.getenv('RSS_CHECK_INTERVAL', 3600))
```

### bots/tldr_rss_bot/handlers/rss_handler.py
```python
import feedparser
import asyncio
import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import List, Dict, Any
from shared.utils.logger import setup_logger

class RSSHandler:
    def __init__(self, data_dir: str = "data"):
        self.logger = setup_logger("tldr_rss.rss_handler")
        self.data_dir = Path(data_dir)
        self.data_dir.mkdir(exist_ok=True)
        
        self.last_entries_file = self.data_dir / 'last_entries.json'
        self.last_entries = self.load_last_entries()
    
    def load_last_entries(self) -> Dict[str, str]:
        """Charge les dernières entrées vues"""
        if self.last_entries_file.exists():
            try:
                with open(self.last_entries_file, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except Exception as e:
                self.logger.error(f"Erreur lors du chargement des dernières entrées: {e}")
        return {}
    
    def save_last_entries(self):
        """Sauvegarde les dernières entrées vues"""
        try:
            with open(self.last_entries_file, 'w', encoding='utf-8') as f:
                json.dump(self.last_entries, f, indent=2, ensure_ascii=False)
        except Exception as e:
            self.logger.error(f"Erreur lors de la sauvegarde: {e}")
    
    async def check_feed(self, feed_name: str, feed_url: str) -> List[Dict[str, Any]]:
        """Vérifie un flux RSS pour de nouveaux articles"""
        try:
            self.logger.info(f"Vérification du feed {feed_name}: {feed_url}")
            
            # Parse du feed RSS
            feed = feedparser.parse(feed_url)
            
            if feed.bozo:
                self.logger.warning(f"Feed {feed_name} mal formé: {feed.bozo_exception}")
            
            new_entries = []
            last_seen = self.last_entries.get(feed_name, "")
            
            for entry in feed.entries:
                # Si c'est la première fois qu'on voit cette entrée
                if entry.link != last_seen:
                    new_entries.append({
                        'title': entry.title,
                        'link': entry.link,
                        'summary': getattr(entry, 'summary', ''),
                        'published': getattr(entry, 'published', str(datetime.now())),
                        'feed_name': feed_name
                    })
                else:
                    break  # On s'arrête dès qu'on trouve une entrée déjà vue
            
            # Met à jour la dernière entrée vue
            if feed.entries:
                self.last_entries[feed_name] = feed.entries[0].link
                self.save_last_entries()
                
                self.logger.info(f"Feed {feed_name}: {len(new_entries)} nouveaux articles")
            
            return new_entries
            
        except Exception as e:
            self.logger.error(f"Erreur lors de la vérification du feed {feed_name}: {e}")
            return []
```

### bots/tldr_rss_bot/bot.py
```python
import discord
from discord.ext import commands, tasks
import asyncio
import sys
from pathlib import Path

# Ajouter le projet root au Python path
project_root = Path(__file__).parent.parent.parent
sys.path.insert(0, str(project_root))

from shared.utils.logger import setup_logger
from shared.discord_utils.embeds import EmbedTemplates
from bots.tldr_rss_bot.config import TLDRBotConfig
from bots.tldr_rss_bot.handlers.rss_handler import RSSHandler

# Configuration
config = TLDRBotConfig()
logger = setup_logger("tldr_rss_bot")

# Configuration du bot
intents = discord.Intents.default()
intents.message_content = True
bot = commands.Bot(command_prefix='!', intents=intents)

# Handler RSS
rss_handler = RSSHandler(data_dir=str(Path(__file__).parent / "data"))

@bot.event
async def on_ready():
    logger.info(f'{bot.user} est connecté à Discord!')
    guild = bot.get_guild(config.guild_id)
    if guild:
        logger.info(f'Serveur: {guild.name}')
    
    # Démarre la vérification RSS
    if not check_rss.is_running():
        check_rss.start()

@tasks.loop(seconds=config.check_interval)
async def check_rss():
    """Vérifie tous les flux RSS pour de nouveaux articles"""
    channel = bot.get_channel(config.channel_id)
    
    if not channel:
        logger.error(f"Canal {config.channel_id} introuvable!")
        return
    
    logger.info("🔍 Vérification des flux RSS...")
    
    for feed_name, feed_url in config.rss_feeds.items():
        new_entries = await rss_handler.check_feed(feed_name, feed_url)
        
        # Envoie les nouveaux articles (ordre chronologique)
        for entry in reversed(new_entries):
            try:
                embed = EmbedTemplates.rss_article_embed(entry, feed_name)
                await channel.send(embed=embed)
                await asyncio.sleep(1)  # Évite le spam
            except Exception as e:
                logger.error(f"Erreur lors de l'envoi de l'article: {e}")

@check_rss.before_loop
async def before_check_rss():
    await bot.wait_until_ready()

# Commandes de debug et administration
@bot.command(name='test_rss')
@commands.has_permissions(administrator=True)
async def test_rss(ctx):
    """Commande pour tester manuellement les flux RSS"""
    await ctx.send("🔄 Test des flux RSS en cours...")
    await check_rss()
    await ctx.send("✅ Test terminé!")

@bot.command(name='ping')
async def ping(ctx):
    """Vérifie si le bot répond"""
    latency = round(bot.latency * 1000)
    await ctx.send(f'🏓 Pong! Latence: {latency}ms')

@bot.command(name='status')
async def status(ctx):
    """Affiche le statut du bot"""
    embed = EmbedTemplates.info_embed(
        "📊 Statut du Bot RSS",
        f"**Feeds surveillés:** {len(config.rss_feeds)}\n"
        f"**Interval de vérification:** {config.check_interval}s\n"
        f"**Dernière vérification:** {check_rss.current_loop or 'Jamais'}"
    )
    await ctx.send(embed=embed)

def main():
    """Point d'entrée principal du bot"""
    if not config.discord_token:
        logger.error("Token Discord manquant! Vérifiez votre fichier .env")
        return
    
    try:
        bot.run(config.discord_token)
    except Exception as e:
        logger.error(f"Erreur lors du démarrage du bot: {e}")

if __name__ == "__main__":
    main()
```

---

## 🎯 URLs RSS TLDR

**Sources confirmées :**
- **TLDR Tech :** `https://bullrich.dev/tldr-rss/tech.xml`
- **TLDR Web Dev :** `https://bullrich.dev/tldr-rss/webdev.xml`
- **TLDR AI :** `https://bullrich.dev/tldr-rss/ai.xml`
- **TLDR Crypto :** `https://bullrich.dev/tldr-rss/crypto.xml`

---

## 📋 CLI de Gestion (manage.py)

```python
#!/usr/bin/env python3
"""
CLI de gestion pour l'écosystème de bots Discord
"""

import argparse
import sys
from pathlib import Path

project_root = Path(__file__).parent
sys.path.insert(0, str(project_root))

def start_bot(bot_name: str):
    """Démarre un bot spécifique"""
    bot_path = project_root / "bots" / bot_name
    if not bot_path.exists():
        print(f"❌ Bot '{bot_name}' introuvable!")
        return
    
    sys.path.insert(0, str(bot_path))
    try:
        from bot import main
        print(f"🚀 Démarrage du bot '{bot_name}'...")
        main()
    except ImportError:
        print(f"❌ Impossible d'importer le bot '{bot_name}'")

def list_bots():
    """Liste tous les bots disponibles"""
    bots_dir = project_root / "bots"
    if not bots_dir.exists():
        print("❌ Aucun bot trouvé")
        return
    
    print("🤖 Bots disponibles:")
    for bot_dir in bots_dir.iterdir():
        if bot_dir.is_dir() and (bot_dir / "bot.py").exists():
            print(f"  - {bot_dir.name}")

def main():
    parser = argparse.ArgumentParser(description="Gestionnaire de bots Discord")
    subparsers = parser.add_subparsers(dest='command', help='Commandes disponibles')
    
    # Commande start
    start_parser = subparsers.add_parser('start', help='Démarre un bot')
    start_parser.add_argument('bot_name', help='Nom du bot à démarrer')
    
    # Commande list
    subparsers.add_parser('list', help='Liste les bots disponibles')
    
    args = parser.parse_args()
    
    if args.command == 'start':
        start_bot(args.bot_name)
    elif args.command == 'list':
        list_bots()
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
```

---

## 🚀 Instructions de Démarrage

### 1. Création du projet complet
```bash
# Cloner/créer la structure
python manage.py setup  # (à implémenter)

# Installer les dépendances
pip install -r requirements.txt
```

### 2. Configuration
```bash
# Copier le template d'environnement
cp .env.example .env
# Éditer .env avec tes tokens et IDs
```

### 3. Premier démarrage
```bash
# Lister les bots disponibles
python manage.py list

# Démarrer le bot TLDR RSS
python manage.py start tldr_rss_bot
```

### 4. Commandes Discord de test
```
!ping          # Test de base
!test_rss      # Test manuel des flux RSS (admin seulement)
!status        # Affichage du statut
```

---

## 🔮 Évolutions Futures

### Bots à ajouter :
- **Bot de modération** (kick/ban/mute automatique)
- **Bot musique** (lecture YouTube/Spotify)
- **Bot dashboard** (statistiques serveur)
- **Bot game** (mini-jeux)

### Améliorations techniques :
- **Base de données** (SQLite → PostgreSQL)
- **Interface web** (Flask/FastAPI)
- **Monitoring** (Prometheus/Grafana)
- **CI/CD** (GitHub Actions)
- **Containerisation** (Docker)

---

## 💡 Notes pour Claude Code

**Points d'attention :**
- Architecture modulaire et évolutive
- Séparation claire des responsabilités
- Logging centralisé
- Configuration flexible
- Tests unitaires
- Documentation claire

**Technologies maîtrisées par Thomas :**
- HTML/CSS/JavaScript
- PHP MVC
- MySQL/MariaDB
- Git avancé
- VS Code

**Apprentissage en cours :**
- Python (transition depuis PHP/JS)
- Discord.py
- Architecture de bots
- Programmation asynchrone

Cette architecture permettra à Thomas d'apprendre progressivement Python tout en construisant un projet évolutif et professionnel.
