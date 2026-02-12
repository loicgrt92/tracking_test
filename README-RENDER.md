# 🎨 Playwright Tracking API - Render.com

> **API gratuite** pour tester votre tracking analytics avec Make.com

---

## 🚀 Déploiement Rapide

### Prérequis

- Compte GitHub
- Compte Render.com (gratuit)

### Étapes

1. **Fork ou Clone ce repo**
2. **Créer un Web Service sur Render.com**
3. **Connecter votre repo GitHub**
4. **Déployer !**

Render détecte automatiquement le Dockerfile.

---

## 📦 Contenu

```
playwright-api-render/
├── Dockerfile              # Container optimisé pour Render
├── render.yaml             # Configuration Infrastructure as Code
├── package.json            # Dépendances Node.js
├── api-server.js           # Serveur Express
├── tracking-tester.js      # Logique Playwright
├── test-api.sh             # Script de test
└── README.md               # Ce fichier
```

---

## 🔧 Configuration Render.com

### Via l'Interface Web

1. **New Web Service**
2. **Connect Repository**
3. Configuration automatique :
   ```
   Name: playwright-tracking-api
   Region: Frankfurt (EU)
   Branch: main
   Runtime: Docker
   Plan: Free
   ```
4. **Create Web Service**

### Via render.yaml (Blueprint)

```bash
# Render détecte automatiquement render.yaml
# Il crée tous les services définis

git push origin main
# → Auto-deploy !
```

---

## 🧪 Tester l'API

### Health Check

```bash
curl https://VOTRE-APP.onrender.com/health
```

### Test Complet

```bash
chmod +x test-api.sh
./test-api.sh https://VOTRE-APP.onrender.com
```

### Test Manuel

```bash
curl -X POST https://VOTRE-APP.onrender.com/test \
  -H "Content-Type: application/json" \
  -d '{
    "eventName": "page_view",
    "url": "https://example.com",
    "dataLayerEventName": "page_view",
    "testGA4": false
  }'
```

---

## 🌐 Endpoints

### GET /health

Vérifier que l'API fonctionne.

**Réponse :**
```json
{
  "status": "ok",
  "service": "Tracking Tester API",
  "version": "1.0.0",
  "timestamp": "2026-02-11T10:00:00.000Z"
}
```

### GET /

Informations sur l'API.

### POST /test

Exécuter un test de tracking.

**Body :**
```json
{
  "eventName": "add_to_cart",
  "url": "https://votresite.com/produit",
  "userAction": "click:.btn-cart",
  "dataLayerEventName": "add_to_cart",
  "expectedParams": "{\"value\": \"*\", \"currency\": \"EUR\"}",
  "testGA4": true,
  "testAmplitude": true,
  "testMixpanel": false
}
```

**Réponse :**
```json
{
  "success": true,
  "results": {
    "eventName": "add_to_cart",
    "success": true,
    "errors": [],
    "dataLayerEvents": [...],
    "networkRequests": [...],
    "toolsDetected": {
      "ga4": true,
      "amplitude": true,
      "mixpanel": false
    }
  }
}
```

### POST /batch-test

Exécuter plusieurs tests en batch.

---

## ⚙️ Variables d'Environnement

Render les configure automatiquement :

```bash
PORT=10000                    # Port du service
NODE_ENV=production           # Environnement
PLAYWRIGHT_BROWSERS_PATH=...  # Chemin des browsers
```

---

## 💰 Coûts

### Plan Free (Recommandé pour tests)

- **0€/mois**
- 750 heures gratuites
- 512 MB RAM
- Sleep après 15 min d'inactivité

**Parfait pour tests hebdomadaires !**

### Plan Starter

- **7$/mois**
- Toujours actif (pas de sleep)
- 512 MB RAM
- Meilleur uptime

---

## 🤖 Éviter le Sleep (Gratuit)

Utilisez **UptimeRobot** pour pinger l'API toutes les 5 minutes :

1. https://uptimerobot.com (gratuit)
2. Créez un monitor HTTP(s)
3. URL : `https://VOTRE-APP.onrender.com/health`
4. Interval : 5 minutes

Voir : **UPTIMEROBOT_GUIDE.md**

---

## 🔗 Utilisation avec Make.com

Dans Make.com, module **HTTP Request** :

```
URL: https://VOTRE-APP.onrender.com/test
Method: POST
Headers:
  Content-Type: application/json

Body (JSON):
{
  "eventName": "{{notion.eventName}}",
  "url": "{{notion.url}}",
  "userAction": "{{notion.userAction}}",
  "dataLayerEventName": "{{notion.dataLayerName}}",
  "expectedParams": "{{notion.expectedParams}}",
  "testGA4": {{notion.testGA4}},
  "testAmplitude": {{notion.testAmplitude}},
  "testMixpanel": {{notion.testMixpanel}}
}
```

---

## 📊 Monitoring

### Logs Render

```
Render Dashboard
→ Votre service
→ Logs tab
```

Logs en temps réel de toutes les requêtes.

### Metrics

```
Render Dashboard
→ Votre service
→ Metrics tab
```

- CPU usage
- Memory usage
- Bandwidth
- Response time

---

## 🆘 Troubleshooting

### Build échoue

**Vérifier les logs :**
- Render Dashboard → Logs
- Cherchez "error" ou "failed"

**Problème fréquent :** Out of memory
**Solution :** Le Dockerfile est optimisé pour 512MB

### Service ne démarre pas

**Vérifier :**
- Le PORT est bien `process.env.PORT`
- Health check répond sur `/health`

### Playwright ne fonctionne pas

**Vérifier dans les logs :**
```
✅ Installing Playwright...
✅ Chromium installed successfully
```

### Timeout sur les requêtes

**Cause :** Service en sleep
**Solution :**
1. UptimeRobot (gratuit)
2. OU Plan Starter (7$/mois)

---

## 📚 Documentation

- **Guide complet** : GUIDE_RENDER.md
- **Setup Make.com** : QUICK_START_MAKE.md
- **UptimeRobot** : UPTIMEROBOT_GUIDE.md
- **Render Docs** : https://render.com/docs

---

## 🎯 Architecture Complète

```
Make.com (Gratuit)
  ↓ HTTP POST
Render.com (Gratuit)
  ↓ Playwright
Site Web à Tester
  ↓ Résultats
Make.com → Notion
  ↓
📧 Email Rapport

UptimeRobot (Gratuit)
  ↓ Ping toutes les 5 min
Render.com (Reste actif)
```

**Coût total : 0€ !** 🎉

---

## 📝 Checklist Déploiement

- [ ] Repo GitHub créé
- [ ] Fichiers copiés
- [ ] Code poussé sur GitHub
- [ ] Compte Render.com créé
- [ ] Web Service créé
- [ ] Build réussi
- [ ] URL générée et notée
- [ ] Health check testé
- [ ] Test complet réussi (test-api.sh)
- [ ] UptimeRobot configuré
- [ ] Make.com configuré avec l'URL
- [ ] Test end-to-end Notion → API → Notion réussi

---

## 🚀 Prochaines Étapes

1. **Déployez l'API** (suivez GUIDE_RENDER.md)
2. **Configurez UptimeRobot** (UPTIMEROBOT_GUIDE.md)
3. **Créez le scénario Make.com** (QUICK_START_MAKE.md)
4. **Testez le workflow complet**
5. **Activez le schedule hebdomadaire**
6. **Profitez de l'automatisation !** 🎊

---

**Made with ❤️ for analytics automation**

**Stack 100% gratuite • Zéro maintenance • Toujours opérationnelle**
