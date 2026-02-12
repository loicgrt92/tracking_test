#!/bin/bash

# 🧪 Script de Test - API Playwright
# Teste que votre API sur Render.com fonctionne correctement

set -e

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# URL de votre API (MODIFIEZ CETTE LIGNE!)
API_URL="${1:-https://VOTRE-APP.onrender.com}"

echo -e "${BLUE}🧪 Test de l'API Playwright${NC}"
echo -e "${BLUE}════════════════════════════${NC}"
echo ""
echo -e "API URL: ${YELLOW}${API_URL}${NC}"
echo ""

# Test 1: Health Check
echo -e "${BLUE}Test 1: Health Check${NC}"
echo -e "GET ${API_URL}/health"
echo ""

HEALTH_RESPONSE=$(curl -s "${API_URL}/health")
HEALTH_STATUS=$(echo $HEALTH_RESPONSE | grep -o '"status":"ok"' || echo "")

if [ -n "$HEALTH_STATUS" ]; then
    echo -e "${GREEN}✅ Health check OK${NC}"
    echo -e "Response: ${HEALTH_RESPONSE}"
else
    echo -e "${RED}❌ Health check FAILED${NC}"
    echo -e "Response: ${HEALTH_RESPONSE}"
    exit 1
fi

echo ""
echo "---"
echo ""

# Test 2: Test Simple (Page View)
echo -e "${BLUE}Test 2: Test Page View Simple${NC}"
echo -e "POST ${API_URL}/test"
echo ""

TEST_RESPONSE=$(curl -s -X POST "${API_URL}/test" \
  -H "Content-Type: application/json" \
  -d '{
    "eventName": "test_page_view",
    "url": "https://example.com",
    "dataLayerEventName": "page_view",
    "expectedParams": "{\"page_title\": \"*\"}",
    "testGA4": false,
    "testAmplitude": false,
    "testMixpanel": false
  }')

TEST_SUCCESS=$(echo $TEST_RESPONSE | grep -o '"success":true' || echo "")

if [ -n "$TEST_SUCCESS" ]; then
    echo -e "${GREEN}✅ Test page view réussi${NC}"
    echo ""
    echo -e "${YELLOW}Résultats:${NC}"
    echo $TEST_RESPONSE | python3 -m json.tool 2>/dev/null || echo $TEST_RESPONSE
else
    echo -e "${RED}❌ Test page view échoué${NC}"
    echo ""
    echo -e "${YELLOW}Réponse:${NC}"
    echo $TEST_RESPONSE | python3 -m json.tool 2>/dev/null || echo $TEST_RESPONSE
fi

echo ""
echo "---"
echo ""

# Test 3: Test avec Action Utilisateur
echo -e "${BLUE}Test 3: Test avec Action Utilisateur${NC}"
echo -e "POST ${API_URL}/test"
echo ""

ACTION_RESPONSE=$(curl -s -X POST "${API_URL}/test" \
  -H "Content-Type: application/json" \
  -d '{
    "eventName": "test_click",
    "url": "https://example.com",
    "userAction": "wait:2000",
    "dataLayerEventName": "click",
    "expectedParams": "{}",
    "testGA4": false,
    "testAmplitude": false,
    "testMixpanel": false
  }')

ACTION_SUCCESS=$(echo $ACTION_RESPONSE | grep -o '"success"' || echo "")

if [ -n "$ACTION_SUCCESS" ]; then
    echo -e "${GREEN}✅ Test avec action réussi${NC}"
else
    echo -e "${YELLOW}⚠️  Test avec action terminé (peut échouer si pas de tracking sur example.com)${NC}"
fi

echo ""
echo "---"
echo ""

# Résumé
echo -e "${BLUE}📊 Résumé des Tests${NC}"
echo -e "${BLUE}═══════════════════${NC}"
echo ""

if [ -n "$HEALTH_STATUS" ] && [ -n "$TEST_SUCCESS" ]; then
    echo -e "${GREEN}✅ Tous les tests principaux ont réussi !${NC}"
    echo ""
    echo -e "Votre API est ${GREEN}opérationnelle${NC} et prête à être utilisée avec Make.com."
    echo ""
    echo -e "${YELLOW}Prochaines étapes :${NC}"
    echo "1. Configurez UptimeRobot pour éviter le sleep"
    echo "2. Créez votre scénario Make.com"
    echo "3. Testez le workflow complet Notion → API → Notion"
    echo ""
    exit 0
else
    echo -e "${RED}❌ Certains tests ont échoué${NC}"
    echo ""
    echo -e "${YELLOW}Vérifications :${NC}"
    echo "1. L'API est-elle bien déployée sur Render ?"
    echo "2. L'URL est-elle correcte ?"
    echo "3. Vérifiez les logs Render.com"
    echo ""
    exit 1
fi
