# 🎨 Guide Complet : Déploiement sur Render.com

> **Alternative gratuite à Railway !** Render.com offre 750h gratuites/mois

---

## 🎯 Pourquoi Render.com ?

### ✅ Avantages

| Critère | Render.com | Railway.app |
|---------|------------|-------------|
| **Plan Gratuit** | ✅ 750h/mois | ❌ 5$ de crédit initial |
| **Coût payant** | 7$/mois | 5€/mois |
| **Setup** | ⭐⭐⭐⭐ Facile | ⭐⭐⭐⭐⭐ Très facile |
| **PostgreSQL gratuit** | ✅ OUI (90 jours) | ❌ Non |
| **HTTPS** | ✅ Auto | ✅ Auto |
| **Docker support** | ✅ OUI | ✅ OUI |
| **Sleep mode** | ✅ Après 15 min | ✅ Après 5 min |

### 💰 Pricing Render.com

**Plan Free :**
- 750 heures/mois gratuites
- Instance sleep après 15 min d'inactivité
- 512 MB RAM
- **Parfait pour tests hebdomadaires !**

**Plan Starter : 7$/mois**
- Pas de sleep
- 512 MB RAM
- Toujours actif

---

## 🎬 Vous Allez Déployer Quoi ?

### Option 1 : API Playwright seule (Pour Make.com)

```
Render.com (Free)
  ↓
API Playwright
  ↓
Make.com l'appelle
```

**Coût : 0€** (plan gratuit Render + Make.com Free)

### Option 2 : N8N + Playwright (Self-hosted complet)

```
Render.com
├── Service 1: N8N
└── Service 2: PostgreSQL (gratuit 90 jours)
```

**Coût : 0€** pendant 90 jours, puis 7$/mois après

---

## 🚀 OPTION 1 : API Playwright pour Make.com (Recommandé)

### Étape 1.1 : Préparer les Fichiers

Créez un nouveau dossier :

```bash
mkdir playwright-api-render
cd playwright-api-render
```

Vous aurez besoin de ces fichiers :

---

### 📄 Dockerfile

```dockerfile
# Dockerfile optimisé pour Render.com
FROM node:18-bullseye-slim

# Installer Chromium et dépendances
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
    && rm -rf /var/lib/apt/lists/*

# Variables Playwright
ENV PLAYWRIGHT_BROWSERS_PATH=/app/.cache/ms-playwright
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1

# Dossier de travail
WORKDIR /app

# Copier package.json
COPY package.json ./

# Installer dépendances
RUN npm install

# Installer Playwright
RUN npx playwright install chromium --with-deps

# Copier les scripts
COPY api-server.js ./
COPY tracking-tester.js ./

# Port (Render utilise la variable PORT)
ENV PORT=10000
EXPOSE 10000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:10000/health || exit 1

# Démarrer
CMD ["node", "api-server.js"]
```

---

### 📄 package.json

```json
{
  "name": "playwright-tracking-api",
  "version": "1.0.0",
  "description": "API Playwright pour tests de tracking - Render.com",
  "main": "api-server.js",
  "scripts": {
    "start": "node api-server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "playwright": "^1.40.0"
  },
  "engines": {
    "node": "18.x"
  }
}
```

---

### 📄 render.yaml (Configuration Render)

```yaml
services:
  - type: web
    name: playwright-tracking-api
    env: docker
    repo: https://github.com/VOTRE-USERNAME/playwright-api-render
    region: frankfurt  # EU pour la latence
    plan: free
    dockerfilePath: ./Dockerfile
    envVars:
      - key: NODE_ENV
        value: production
    healthCheckPath: /health
```

---

### 📄 .dockerignore

```
node_modules
npm-debug.log
.env
.git
.gitignore
README.md
.DS_Store
```

---

### 📄 api-server.js

Utilisez le fichier `api-server.js` que je vous ai déjà créé, mais avec une petite modification pour Render :

```javascript
// En haut du fichier api-server.js, changez :
const PORT = process.env.PORT || 10000;  // Render utilise PORT

// Le reste reste identique
```

---

### Étape 1.2 : Créer le Repo GitHub

```bash
# Dans le dossier playwright-api-render/
git init
git add .
git commit -m "Initial commit: Playwright API for Render.com"

# Créer le repo sur GitHub
# https://github.com/new

git remote add origin https://github.com/VOTRE-USERNAME/playwright-api-render.git
git branch -M main
git push -u origin main
```

---

### Étape 1.3 : Déployer sur Render.com

#### A. Créer un compte Render

1. Allez sur https://render.com
2. **Sign Up** avec GitHub
3. Autorisez Render à accéder à vos repos

#### B. Créer un Web Service

1. Dashboard Render → **New +** → **Web Service**
2. **Connect repository** → Cherchez `playwright-api-render`
3. Cliquez sur **Connect**

#### C. Configuration

Render détecte automatiquement votre Dockerfile !

```
Name: playwright-tracking-api
Region: Frankfurt (EU Central)
Branch: main
Runtime: Docker

Instance Type: Free
```

**Variables d'environnement :** (optionnel)
```
NODE_ENV = production
```

#### D. Créer le service

1. Cliquez sur **Create Web Service**
2. Render commence le build ! ⏳

Le build prend **5-10 minutes** la première fois (installation de Chromium).

#### E. Obtenir l'URL

Une fois déployé, Render vous donne une URL :
```
https://playwright-tracking-api.onrender.com
```

---

### Étape 1.4 : Tester l'API

```bash
# Health check
curl https://VOTRE-APP.onrender.com/health

# Test simple
curl -X POST https://VOTRE-APP.onrender.com/test \
  -H "Content-Type: application/json" \
  -d '{
    "eventName": "test",
    "url": "https://example.com",
    "dataLayerEventName": "page_view",
    "testGA4": true
  }'
```

**Résultat attendu :** JSON avec les résultats du test

✅ **API opérationnelle !**

---

## ⚠️ Limitation du Plan Free Render

### Sleep Mode

Le service **sleep après 15 min d'inactivité**.

Au premier appel après sleep :
- ⏱️ **Démarrage : ~30-60 secondes**
- Ensuite : réponse normale

**Solutions :**

1. **Accepter le délai** (c'est gratuit !)
2. **Pinger l'API régulièrement** avec un cron job externe
3. **Passer au plan Starter (7$/mois)** = pas de sleep

### Pinger l'API (Gratuit)

Utilisez **UptimeRobot** (gratuit) :

1. https://uptimerobot.com
2. **Add New Monitor**
3. Type : HTTP(s)
4. URL : `https://VOTRE-APP.onrender.com/health`
5. Interval : 5 minutes

L'API restera "chaude" ! 🔥

---

## 🎯 OPTION 2 : N8N Complet sur Render

Pour héberger N8N + Playwright + PostgreSQL sur Render.

### Différences vs Railway

| Composant | Render | Railway |
|-----------|--------|---------|
| **N8N** | Docker custom | Docker custom |
| **PostgreSQL** | ✅ Gratuit 90j | 💰 2€/mois |
| **Complexité** | Moyenne | Facile |
| **Support** | Docs | Docs + Dashboard |

### Architecture

```
Render.com
├── Service 1: N8N + Playwright (Web Service)
│   └── 7$/mois (ou Free avec sleep)
│
└── Service 2: PostgreSQL (Database)
    └── Gratuit 90 jours, puis 7$/mois
```

**Coût : 0€** pendant 90 jours, puis **14$/mois**

### Setup N8N sur Render

#### 1. Créer le repo GitHub

Utilisez les mêmes fichiers que pour Railway :
- `Dockerfile` (celui avec N8N complet)
- `docker-compose.yml` (ignoré sur Render)
- `package.json`
- `tracking-tester.js`

#### 2. Créer PostgreSQL

1. Render Dashboard → **New +** → **PostgreSQL**
2. Name : `n8n-database`
3. Database : `n8n`
4. User : `n8n`
5. Region : Frankfurt
6. Plan : **Free**
7. **Create Database**

Render vous donne :
```
Internal Database URL: postgres://...
External Database URL: postgres://...
```

**Copiez l'Internal Database URL !**

#### 3. Créer le Web Service N8N

1. **New +** → **Web Service**
2. Connect repo `n8n-tracking-tester`
3. Configuration :
   ```
   Name: n8n-tracking-tester
   Region: Frankfurt
   Branch: main
   Runtime: Docker
   Instance Type: Starter (7$/mois) - recommandé pour N8N
   ```

4. **Variables d'environnement :**

```bash
# Database (coller l'URL de votre PostgreSQL Render)
DATABASE_TYPE=postgresdb
DATABASE_URL=postgres://n8n:PASSWORD@dpg-xxx.frankfurt-postgres.render.com/n8n

# OU décomposé (si DATABASE_URL ne marche pas) :
DB_POSTGRESDB_HOST=dpg-xxx.frankfurt-postgres.render.com
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=n8n
DB_POSTGRESDB_USER=n8n
DB_POSTGRESDB_PASSWORD=VOTRE_PASSWORD

# Auth (CHANGEZ!)
N8N_BASIC_AUTH_ACTIVE=true
N8N_BASIC_AUTH_USER=votre-email@example.com
N8N_BASIC_AUTH_PASSWORD=MotDePasseSecurise123!

# Config
N8N_HOST=$RENDER_EXTERNAL_URL
WEBHOOK_URL=https://$RENDER_EXTERNAL_URL/
N8N_PROTOCOL=https
NODE_ENV=production

# Timezone
GENERIC_TIMEZONE=Europe/Paris
TZ=Europe/Paris

# Encryption
N8N_ENCRYPTION_KEY=VotreCleAleatoire32Caracteres123
```

5. **Create Web Service**

Build : ~10-15 minutes

✅ **N8N accessible à** : `https://n8n-tracking-tester.onrender.com`

---

## 💰 Comparaison des Coûts

### Option 1 : API Playwright + Make.com

| Service | Coût |
|---------|------|
| Render.com (Free) | 0€ |
| Make.com (Free) | 0€ |
| **TOTAL** | **0€** 🎉 |

Avec **UptimeRobot** pour éviter le sleep : toujours **0€** !

### Option 2 : N8N sur Render

| Service | Gratuit | Payant |
|---------|---------|--------|
| N8N (Free) | 0€ (avec sleep) | 7$/mois |
| PostgreSQL | 0€ (90j) | 7$/mois |
| **TOTAL** | **0€** pendant 90j | **14$/mois** après |

### Comparaison avec Railway

| Setup | Render | Railway |
|-------|--------|---------|
| API seule | **0€** | ~5€ |
| N8N complet | 0-14$/mois | ~6€/mois |

**Render est gratuit pour commencer !** 🎉

---

## 🔧 Configuration Make.com avec Render

Même chose qu'avec Railway !

Dans Make.com, module HTTP :
```
URL: https://VOTRE-APP.onrender.com/test
Method: POST
Headers:
  Content-Type: application/json
Body: (même JSON qu'avant)
```

**Différence :** Premier appel peut prendre 30-60s (sleep).

**Solution :** UptimeRobot pour garder l'API active.

---

## 🆘 Troubleshooting Render

### Build échoue

**Vérifier les logs :**
1. Render Dashboard → Votre service
2. Onglet **Logs**
3. Cherchez les erreurs

**Erreurs fréquentes :**

**"Out of memory during build"**
→ Le plan Free a peu de RAM
→ Optimisez le Dockerfile (une seule couche pour Playwright)

**"Chromium not found"**
→ Vérifiez l'installation dans Dockerfile
```dockerfile
RUN npx playwright install chromium --with-deps
```

### Service sleep trop souvent

→ Utilisez UptimeRobot (gratuit) pour pinger toutes les 5 min

### Base de données connection failed

→ Vérifiez que PostgreSQL est dans la même région (Frankfurt)
→ Utilisez **Internal Database URL** (pas External)

### N8N très lent

→ Le plan Free a seulement 512MB RAM
→ Passez au Starter (7$/mois) avec 512MB garantis

---

## 📊 Render vs Railway - Résumé

### Render.com : ✅ Gratuit mais limité

**Avantages :**
- ✅ Plan gratuit généreux (750h)
- ✅ PostgreSQL gratuit (90j)
- ✅ Bon pour tester

**Inconvénients :**
- ⏱️ Sleep après 15 min
- 🐌 Démarrage lent (30-60s)
- 💾 RAM limitée (512MB)

### Railway.app : 💰 Payant mais meilleur

**Avantages :**
- ⚡ Pas de sleep (ou 5 min)
- 🚀 Démarrage rapide (<5s)
- 💪 Plus de flexibilité
- 🎯 Meilleur pour production

**Inconvénients :**
- 💰 Pas de plan gratuit (5€ crédit initial)
- 💵 ~5-6€/mois minimum

---

## 🎯 Ma Recommandation

### Pour Tester (0€) : Render.com

1. Déployez l'API sur Render (Free)
2. Utilisez Make.com (Free)
3. Configurez UptimeRobot
4. **Coût : 0€ !**

### Pour Production : Railway.app

1. API ou N8N sur Railway
2. Pas de sleep, rapide
3. **Coût : 5-6€/mois**

### Meilleur Compromis : Make.com + Render

```
Make.com Free (0€)
  ↓
Render.com Free (0€) + UptimeRobot
  ↓
Tests hebdomadaires parfaits !
```

**Commencez avec Render gratuit, passez à Railway si besoin !**

---

## 📦 Fichiers Nécessaires

Pour déployer sur Render, vous avez besoin de :

**API Playwright seule :**
- ✅ Dockerfile (version Render)
- ✅ package.json
- ✅ api-server.js
- ✅ tracking-tester.js
- ✅ render.yaml (optionnel)
- ✅ .dockerignore

**N8N complet :**
- ✅ Dockerfile (version N8N complète)
- ✅ package.json
- ✅ tracking-tester.js
- ✅ render.yaml
- ✅ .dockerignore

---

## 🚀 Prochaines Étapes

**Je vais créer pour vous :**

1. ✅ Dockerfile optimisé pour Render
2. ✅ render.yaml de configuration
3. ✅ Guide UptimeRobot
4. ✅ Script de test de l'API

**Voulez-vous que je crée ces fichiers maintenant ?** 🎨
