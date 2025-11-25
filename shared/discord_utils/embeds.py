from datetime import UTC, datetime
from typing import Any

import discord


class EmbedTemplates:
    """
    Template d'embeds réutilisables
    """
    @staticmethod
    def info_embed(title: str, description: str, color: int = 0x3498db) -> discord.Embed:
        """
        docstring
        """
        embed = discord.Embed(
            title=title,
            description=description,
            color=color,
            timestamp=datetime.now(UTC)
        )
        return embed

    @staticmethod
    def error_embed(title: str, description: str) -> discord.Embed:
        """
        Embed d'erreur
        """
        return EmbedTemplates.info_embed(title, description, 0xe74c3c)

    @staticmethod
    def succes_embed(title: str, description: str) -> discord.Embed:
        """
        Embed de succés
        """
        return EmbedTemplates.info_embed(title, description, 0x2ecc71)

    @staticmethod
    def rss_article_embed(article: dict[str, Any], feed_name: str) -> discord.Embed:
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
            timestamp=datetime.now(UTC)
        )

        embed.add_field(name="📂 Source", value=feed_name.upper(), inline=True)
        if 'published' in article:
            embed.add_field(name="📅 Publié", value=article['published'], inline=True)
        embed.set_footer(text="Bot RSS • Powered by Discord Bots Ecosystem")
        return embed
