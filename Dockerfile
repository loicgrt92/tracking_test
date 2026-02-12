# Dockerfile optimisé pour Render.com
# Compatible avec le plan Free (512MB RAM)

FROM node:18-bullseye-slim

# Installer les dépendances système pour Playwright
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    wget \
    ca-certificates \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Variables d'environnement pour Playwright
ENV PLAYWRIGHT_BROWSERS_PATH=/app/.cache/ms-playwright
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV CHROMIUM_PATH=/usr/bin/chromium

# Dossier de travail
WORKDIR /app

# Copier package.json d'abord (meilleur caching Docker)
COPY package.json ./

# Installer les dépendances npm
RUN npm ci --only=production

# Installer Playwright et ses dépendances
RUN npx playwright install chromium --with-deps

# Copier le reste des fichiers
COPY api-server.js ./
COPY tracking-tester.js ./

# Render.com utilise la variable d'environnement PORT
# Par défaut 10000 si non défini
ENV PORT=10000
EXPOSE 10000

# Utilisateur non-root pour la sécurité
RUN useradd -m -u 1001 nodeuser && \
    chown -R nodeuser:nodeuser /app
USER nodeuser

# Health check pour Render
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:${PORT}/health || exit 1

# Démarrer l'application
CMD ["node", "api-server.js"]
