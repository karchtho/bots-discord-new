#!/bin/bash

# Script de création de l'arborescence du projet Discord Bots Ecosystem
# Auteur: Thomas
# Date: 2025-11-24

echo "🚀 Création de l'arborescence du projet Discord Bots Ecosystem"
echo "=============================================================="

# Couleurs pour le terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour créer un dossier
create_dir() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo -e "${BLUE}📁 Créé:${NC} $1"
    else
        echo -e "⏭️  Existe déjà: $1"
    fi
}

# Fonction pour créer un fichier vide
create_file() {
    if [ ! -f "$1" ]; then
        touch "$1"
        echo -e "${GREEN}📄 Créé:${NC} $1"
    else
        echo -e "⏭️  Existe déjà: $1"
    fi
}

# Fonction pour créer un __init__.py
create_init() {
    if [ ! -f "$1/__init__.py" ]; then
        echo '"""' > "$1/__init__.py"
        echo "$(basename $1) package" >> "$1/__init__.py"
        echo '"""' >> "$1/__init__.py"
        echo -e "${GREEN}📄 Créé:${NC} $1/__init__.py"
    fi
}

echo ""
echo "📦 Création de la structure de base..."
echo ""

# ============ SHARED ============
echo "🔧 Création du module shared..."
create_dir "shared"
create_init "shared"

# shared/database
create_dir "shared/database"
create_init "shared/database"
create_file "shared/database/models.py"
create_file "shared/database/connection.py"

# shared/utils
create_dir "shared/utils"
create_init "shared/utils"
create_file "shared/utils/logger.py"
create_file "shared/utils/config.py"
create_file "shared/utils/helpers.py"

# shared/discord_utils
create_dir "shared/discord_utils"
create_init "shared/discord_utils"
create_file "shared/discord_utils/embeds.py"
create_file "shared/discord_utils/permissions.py"
create_file "shared/discord_utils/decorators.py"

# shared/external_apis
create_dir "shared/external_apis"
create_init "shared/external_apis"
create_file "shared/external_apis/rss_client.py"
create_file "shared/external_apis/web_scraper.py"

# ============ BOTS ============
echo ""
echo "🤖 Création du dossier bots..."
create_dir "bots"

# bots/tldr_rss_bot
echo "📰 Création du bot TLDR RSS..."
create_dir "bots/tldr_rss_bot"
create_init "bots/tldr_rss_bot"
create_file "bots/tldr_rss_bot/bot.py"
create_file "bots/tldr_rss_bot/config.py"
create_file "bots/tldr_rss_bot/requirements.txt"

# bots/tldr_rss_bot/cogs
create_dir "bots/tldr_rss_bot/cogs"
create_init "bots/tldr_rss_bot/cogs"
create_file "bots/tldr_rss_bot/cogs/rss_commands.py"
create_file "bots/tldr_rss_bot/cogs/admin_commands.py"

# bots/tldr_rss_bot/handlers
create_dir "bots/tldr_rss_bot/handlers"
create_init "bots/tldr_rss_bot/handlers"
create_file "bots/tldr_rss_bot/handlers/rss_handler.py"
create_file "bots/tldr_rss_bot/handlers/feed_parser.py"

# bots/tldr_rss_bot/data
create_dir "bots/tldr_rss_bot/data"
create_file "bots/tldr_rss_bot/data/last_entries.json"
create_file "bots/tldr_rss_bot/data/feeds_config.json"

# Bots futurs (structure de base)
create_dir "bots/moderation_bot"
create_dir "bots/music_bot"

# ============ SCRIPTS ============
echo ""
echo "🛠️  Création du dossier scripts..."
create_dir "scripts"
create_file "scripts/deploy.py"
create_file "scripts/setup_bot.py"
create_file "scripts/backup.py"

# ============ DOCS ============
echo ""
echo "📚 Création du dossier documentation..."
create_dir "docs"
create_file "docs/README.md"
create_file "docs/architecture.md"
create_dir "docs/bots"
create_file "docs/bots/tldr_rss_bot.md"
create_file "docs/bots/setup_guide.md"

# ============ DOCKER ============
echo ""
echo "🐳 Création du dossier Docker..."
create_dir "docker"
create_file "docker/Dockerfile.base"
create_file "docker/docker-compose.yml"
create_dir "docker/bots"
create_file "docker/bots/tldr_rss_bot.dockerfile"

# ============ TESTS ============
echo ""
echo "🧪 Création du dossier tests..."
create_dir "tests"
create_init "tests"
create_dir "tests/test_shared"
create_init "tests/test_shared"
create_dir "tests/test_tldr_rss_bot"
create_init "tests/test_tldr_rss_bot"
create_file "tests/conftest.py"

# ============ CONFIGS ============
echo ""
echo "⚙️  Création du dossier configs..."
create_dir "configs"
create_file "configs/logging.yaml"
create_file "configs/database.yaml"
create_dir "configs/environments"
create_file "configs/environments/development.env"
create_file "configs/environments/staging.env"
create_file "configs/environments/production.env"

# ============ FICHIERS RACINE ============
echo ""
echo "📄 Création des fichiers racine..."
create_file ".env.example"
create_file ".gitignore"
create_file "requirements.txt"
create_file "setup.py"
create_file "manage.py"
create_file "README.md"

# ============ INITIALISATION FICHIERS JSON ============
echo ""
echo "🔧 Initialisation des fichiers JSON..."

# Initialiser last_entries.json
if [ ! -s "bots/tldr_rss_bot/data/last_entries.json" ]; then
    echo '{}' > "bots/tldr_rss_bot/data/last_entries.json"
    echo -e "${GREEN}✅ Initialisé:${NC} bots/tldr_rss_bot/data/last_entries.json"
fi

# Initialiser feeds_config.json
if [ ! -s "bots/tldr_rss_bot/data/feeds_config.json" ]; then
    cat > "bots/tldr_rss_bot/data/feeds_config.json" << 'EOF'
{
  "feeds": {
    "tech": "https://bullrich.dev/tldr-rss/tech.xml",
    "webdev": "https://bullrich.dev/tldr-rss/webdev.xml",
    "ai": "https://bullrich.dev/tldr-rss/ai.xml",
    "crypto": "https://bullrich.dev/tldr-rss/crypto.xml"
  }
}
EOF
    echo -e "${GREEN}✅ Initialisé:${NC} bots/tldr_rss_bot/data/feeds_config.json"
fi

# ============ GITIGNORE ============
echo ""
echo "📝 Création du .gitignore..."
cat > ".gitignore" << 'EOF'
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg

# Virtual Environment
venv/
ENV/
env/

# Environment variables
.env
*.env
!.env.example
!configs/environments/*.env

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# Logs
*.log
logs/

# Database
*.db
*.sqlite
*.sqlite3

# Bot data
bots/*/data/*.json
!bots/*/data/.gitkeep

# OS
.DS_Store
Thumbs.db

# Testing
.pytest_cache/
.coverage
htmlcov/

# Docker
docker-compose.override.yml
EOF
echo -e "${GREEN}✅ .gitignore créé${NC}"

# ============ README ============
echo ""
echo "📖 Création du README principal..."
cat > "README.md" << 'EOF'
# Discord Bots Ecosystem

Écosystème modulaire de bots Discord en Python.

## 🚀 Démarrage rapide

1. **Créer l'environnement virtuel**
   ```bash
   python -m venv venv
   source venv/bin/activate  # Linux/Mac
   # ou
   venv\Scripts\activate  # Windows
   ```

2. **Installer les dépendances**
   ```bash
   pip install -r requirements.txt
   ```

3. **Configuration**
   ```bash
   cp .env.example .env
   # Éditer .env avec vos tokens Discord
   ```

4. **Lancer un bot**
   ```bash
   python manage.py start tldr_rss_bot
   ```

## 📁 Structure du projet

Voir [docs/architecture.md](docs/architecture.md) pour la documentation complète.

## 🤖 Bots disponibles

- **tldr_rss_bot** : Bot RSS pour TLDR Newsletter
- **moderation_bot** : (À venir)
- **music_bot** : (À venir)

## 📚 Documentation

- [Guide de setup](docs/bots/setup_guide.md)
- [Architecture](docs/architecture.md)
- [Bot TLDR RSS](docs/bots/tldr_rss_bot.md)

## 🛠️ Développement

```bash
# Lister les bots
python manage.py list

# Lancer les tests
pytest

# Format du code
black .
```

## 📝 License

MIT
EOF
echo -e "${GREEN}✅ README.md créé${NC}"

# ============ RÉSUMÉ ============
echo ""
echo "=============================================================="
echo -e "${GREEN}✅ Création de l'arborescence terminée !${NC}"
echo "=============================================================="
echo ""
echo "📋 Prochaines étapes :"
echo "   1. cd discord-bots-ecosystem"
echo "   2. python -m venv venv"
echo "   3. source venv/bin/activate  (ou venv\\Scripts\\activate sur Windows)"
echo "   4. pip install -r requirements.txt"
echo "   5. cp .env.example .env"
echo "   6. Éditer .env avec vos tokens Discord"
echo "   7. python manage.py start tldr_rss_bot"
echo ""
echo "📁 Structure créée dans: $(pwd)"
echo ""
echo "🎉 Bon développement !"