# 🤖 Configuration UptimeRobot - Éviter le Sleep

> **Gardez votre API Render.com active gratuitement !**

---

## 🎯 Problème

Le plan Free de Render.com met votre service en **sleep après 15 minutes** d'inactivité.

Au réveil :
- ⏱️ **30-60 secondes** de démarrage
- Première requête = timeout possible

---

## ✅ Solution : UptimeRobot

**UptimeRobot** = Service gratuit qui "ping" votre API régulièrement.

**Plan gratuit :**
- 50 monitors
- Check toutes les 5 minutes
- Alertes email si down
- **100% gratuit !**

---

## 🚀 Setup en 5 Minutes

### Étape 1 : Créer un Compte

1. Allez sur https://uptimerobot.com
2. **Sign Up Free**
3. Vérifiez votre email

### Étape 2 : Créer un Monitor

1. Dashboard → **Add New Monitor**
2. Configuration :
   ```
   Monitor Type: HTTP(s)
   Friendly Name: Playwright API - Render
   URL: https://VOTRE-APP.onrender.com/health
   Monitoring Interval: 5 minutes
   Monitor Timeout: 30 seconds
   ```
3. **Create Monitor**

✅ **C'est tout !**

---

## 📊 Résultat

Votre API sera pingée toutes les 5 minutes :

```
09:00 → Ping → API active
09:05 → Ping → API active
09:10 → Ping → API active
...
```

**L'API ne dormira jamais !** 🎉

---

## ⚙️ Configuration Avancée

### Alertes Email

Par défaut, UptimeRobot vous envoie un email si l'API est down.

**Configurer :**
1. Monitor → **Edit**
2. **Alert Contacts** → Votre email
3. **Save**

### Webhook vers Make.com (Optionnel)

Si vous voulez être notifié dans Make.com quand l'API est down :

1. Dans Make.com, créez un **Webhook**
2. Copiez l'URL webhook
3. Dans UptimeRobot :
   - Monitor → **Edit**
   - **Alert Contacts** → **Add Alert Contact**
   - Type : **Webhook**
   - URL : `https://hook.eu2.make.com/...`
4. **Save**

### Status Page Public (Optionnel)

Créez une page de statut publique :

1. UptimeRobot → **Public Status Pages**
2. **Create Status Page**
3. Ajoutez vos monitors
4. URL publique : `https://stats.uptimerobot.com/xxx`

---

## 💰 Limites du Plan Gratuit

| Limite | Gratuit | Pro |
|--------|---------|-----|
| **Monitors** | 50 | Illimités |
| **Interval** | 5 min | 1 min |
| **SMS alerts** | ❌ Non | ✅ Oui |
| **Logs** | 2 mois | 1 an |

Pour votre usage : **Gratuit suffit amplement !**

---

## 🔍 Monitoring

### Dashboard UptimeRobot

Vous voyez en temps réel :
- ✅ Uptime % (devrait être ~99.9%)
- 📊 Response time (devrait être <500ms)
- 📈 Historique des pings

### Statistiques

UptimeRobot vous envoie un **rapport mensuel** :
```
📊 Monthly Report - Playwright API

Uptime: 99.8%
Average Response Time: 342ms
Incidents: 0
```

---

## 🆘 Troubleshooting

### Monitor reste "Down"

**Causes possibles :**

1. **URL incorrecte**
   → Vérifiez : `https://VOTRE-APP.onrender.com/health`
   → Testez dans le navigateur

2. **Timeout trop court**
   → Passez à 60 secondes (Settings → Timeout)

3. **API vraiment down**
   → Vérifiez les logs Render.com

### Response time élevé (>2000ms)

C'est normal si l'API était en sleep :
- Premier ping après sleep : ~30-60s
- Pings suivants : <500ms

**Solution :** Diminuez l'intervalle à 5 min

### Trop d'alertes

Si vous recevez trop d'emails "API down" :

**Option 1 :** Augmentez la tolérance
```
Monitor → Edit
→ Check "Send alert when site is down for" : 3 minutes
```

**Option 2 :** Désactivez les alertes
```
Alert Contacts → Remove email
```

---

## 🎯 Alternatives à UptimeRobot

### 1. Cron-job.org (Gratuit)

https://cron-job.org

- Ping toutes les 1-60 minutes
- Interface simple
- Gratuit

### 2. Freshping (Gratuit)

https://www.freshworks.com/website-monitoring/

- 50 monitors gratuits
- Check toutes les 1 minute
- Dashboard élégant

### 3. Better Uptime (Payant)

https://betteruptime.com

- Interface moderne
- Intégrations Slack/Discord
- À partir de 10$/mois

**Pour vous : UptimeRobot gratuit est parfait !** ✅

---

## 📋 Checklist

- [ ] Compte UptimeRobot créé
- [ ] Monitor configuré avec l'URL de votre API Render
- [ ] Interval : 5 minutes
- [ ] URL testée manuellement dans le navigateur
- [ ] Premier ping réussi (voir dashboard)
- [ ] Alert email configuré
- [ ] Uptime 99%+ après 24h

---

## 🎉 Résultat

Avec UptimeRobot configuré :

```
Render.com Free : 0€
UptimeRobot Free : 0€
Make.com Free   : 0€
──────────────────────
TOTAL           : 0€ 🎊

API toujours active !
Tests automatiques hebdo !
Rapports dans Notion !
```

**Stack 100% gratuite et fonctionnelle !** 🚀

---

**Questions sur UptimeRobot ? Dites-moi !**
