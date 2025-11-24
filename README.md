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
