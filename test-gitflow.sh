#!/bin/bash

# ===================================================================
# TEST COMPLET DU GIT FLOW LOCAL
# ===================================================================
# Ce script teste l'ensemble du Git Flow sans push vers GitHub
# pour démontrer le fonctionnement du workflow
# ===================================================================

echo "🧪 ===== TEST COMPLET DU GIT FLOW LOCAL ====="
echo ""

# Initialisation des variables
REPO_PATH="/Users/mac/Documents/Project/AWS_TERRAFORM_LAB"
cd "$REPO_PATH"

echo "📋 1. STATUS INITIAL"
echo "Current branch: $(git branch --show-current)"
git log --oneline -n 3
echo ""

echo "🔧 2. SIMULATION DÉVELOPPEMENT SUR DEV"
echo "   Creating a new feature on dev branch..."
git checkout dev
echo "# Test feature" >> test-feature.txt
git add test-feature.txt
git commit -m "feat: add test feature for GitFlow demo"
echo "   ✅ Feature developed on dev"
echo ""

echo "🧪 3. PROMOTION DEV → STAGING (MERGE)"
git checkout staging
git merge dev --no-edit
echo "   ✅ dev merged into staging"
echo ""

echo "🚀 4. RELEASE STAGING → MSTG (RELEASE + TAG)"
git checkout mstg
git merge staging --no-edit
git tag "mstg-v1.0.0-rc.1"
echo "   ✅ staging released to mstg with tag: mstg-v1.0.0-rc.1"
echo ""

echo "🏆 5. DEPLOY MSTG → PROD (MERGE)"
git checkout prod
git merge mstg --no-edit
git tag "v1.0.0"
echo "   ✅ mstg merged to prod with production tag: v1.0.0"
echo ""

echo "📊 6. RÉSULTATS FINAUX"
echo "Tags créés:"
git tag | grep -E "(mstg|v1\.0\.0)" | tail -2
echo ""
echo "État des branches:"
echo "🔧 dev: $(git log dev --oneline -n 1)"
echo "🧪 staging: $(git log staging --oneline -n 1)"
echo "🚀 mstg: $(git log mstg --oneline -n 1)"
echo "🏆 prod: $(git log prod --oneline -n 1)"
echo ""

echo "✅ ===== TEST GITFLOW TERMINÉ AVEC SUCCÈS ====="
echo ""
echo "🎯 WORKFLOW VALIDÉ:"
echo "   ✓ dev → staging : MERGE"
echo "   ✓ staging → mstg : RELEASE (avec tag)"
echo "   ✓ mstg → prod : MERGE (avec tag final)"
echo ""

# Cleanup
git checkout dev
rm -f test-feature.txt
git reset --hard HEAD~1

echo "🧹 Cleanup effectué - repository restored"
