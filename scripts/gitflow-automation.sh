#!/bin/bash

# 🌊 GitFlow Automation Script
# Usage: ./gitflow-automation.sh [promote-to-staging|release-to-mstg|deploy-to-prod]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "Not in a git repository"
        exit 1
    fi
}

# Promote dev to staging (MERGE strategy)
promote_to_staging() {
    log_info "🚀 Promoting dev to staging (MERGE strategy)"
    
    # Ensure we're on dev branch
    log_info "Switching to dev branch"
    git checkout dev
    git pull origin dev
    
    # Switch to staging and merge
    log_info "Switching to staging branch"
    git checkout staging
    git pull origin staging
    
    log_info "Merging dev into staging"
    git merge --no-ff dev -m "chore: merge dev to staging - $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Push changes
    log_info "Pushing staging branch"
    git push origin staging
    
    log_success "Dev successfully promoted to staging!"
    log_info "Next step: Run tests on staging, then use 'release-to-mstg'"
}

# Release staging to mstg (RELEASE strategy)
release_to_mstg() {
    log_info "🏷️  Releasing staging to mstg (RELEASE strategy)"
    
    # Ensure we're on staging branch
    log_info "Switching to staging branch"
    git checkout staging
    git pull origin staging
    
    # Generate release version
    CURRENT_DATE=$(date '+%Y.%m.%d')
    RC_VERSION="staging-v${CURRENT_DATE}-rc.$(date '+%H%M')"
    
    log_info "Creating release tag: $RC_VERSION"
    git tag -a "$RC_VERSION" -m "Release candidate for MSTG - $(date '+%Y-%m-%d %H:%M:%S')"
    git push origin "$RC_VERSION"
    
    # Switch to mstg and merge the release
    log_info "Switching to mstg branch"
    git checkout mstg
    git pull origin mstg
    
    log_info "Merging staging release into mstg"
    git merge --no-ff staging -m "release: $RC_VERSION to MSTG"
    
    # Push changes
    log_info "Pushing mstg branch"
    git push origin mstg
    
    log_success "Staging successfully released to mstg with tag: $RC_VERSION"
    log_info "Next step: Run UAT on mstg, then use 'deploy-to-prod'"
}

# Deploy mstg to prod (MERGE strategy)
deploy_to_prod() {
    log_info "🏆 Deploying mstg to prod (MERGE strategy)"
    
    # Confirmation prompt
    log_warning "⚠️  This will deploy to PRODUCTION!"
    read -p "Are you sure you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Deployment cancelled"
        exit 0
    fi
    
    # Ensure we're on mstg branch
    log_info "Switching to mstg branch"
    git checkout mstg
    git pull origin mstg
    
    # Switch to prod and merge
    log_info "Switching to prod branch"
    git checkout prod
    git pull origin prod
    
    log_info "Merging mstg into prod"
    git merge --no-ff mstg -m "deploy: production deployment - $(date '+%Y-%m-%d %H:%M:%S')"
    
    # Create production tag
    PROD_VERSION="v$(date '+%Y.%m.%d')"
    log_info "Creating production tag: $PROD_VERSION"
    git tag -a "$PROD_VERSION" -m "Production release $PROD_VERSION"
    
    # Push changes and tags
    log_info "Pushing prod branch and tags"
    git push origin prod
    git push origin "$PROD_VERSION"
    
    log_success "MSTG successfully deployed to production with tag: $PROD_VERSION"
    log_info "🎉 Production deployment complete!"
}

# Status check
check_status() {
    log_info "📊 GitFlow Status Check"
    
    echo ""
    log_info "📋 Current branch:"
    git branch --show-current
    
    echo ""
    log_info "📝 Recent commits by branch:"
    
    echo ""
    echo "🔧 DEV:"
    git log --oneline -3 dev 2>/dev/null || echo "  Branch dev not found"
    
    echo ""
    echo "🧪 STAGING:"
    git log --oneline -3 staging 2>/dev/null || echo "  Branch staging not found"
    
    echo ""
    echo "🚀 MSTG:"
    git log --oneline -3 mstg 2>/dev/null || echo "  Branch mstg not found"
    
    echo ""
    echo "🏆 PROD:"
    git log --oneline -3 prod 2>/dev/null || echo "  Branch prod not found"
    
    echo ""
    log_info "🏷️  Recent tags:"
    git tag --sort=-version:refname | head -5
}

# Initialize branches
init_branches() {
    log_info "🌱 Initializing GitFlow branches"
    
    # Create branches if they don't exist
    for branch in dev staging mstg prod; do
        if ! git show-ref --verify --quiet refs/heads/$branch; then
            log_info "Creating branch: $branch"
            git checkout -b $branch
            git push -u origin $branch
        else
            log_info "Branch $branch already exists"
        fi
    done
    
    git checkout dev
    log_success "GitFlow branches initialized!"
}

# Main script logic
case "${1:-}" in
    "promote-to-staging")
        check_git_repo
        promote_to_staging
        ;;
    "release-to-mstg")
        check_git_repo
        release_to_mstg
        ;;
    "deploy-to-prod")
        check_git_repo
        deploy_to_prod
        ;;
    "status")
        check_git_repo
        check_status
        ;;
    "init")
        check_git_repo
        init_branches
        ;;
    *)
        echo "🌊 GitFlow Automation Script"
        echo ""
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  promote-to-staging  - MERGE dev → staging"
        echo "  release-to-mstg     - RELEASE staging → mstg (with tag)"
        echo "  deploy-to-prod      - MERGE mstg → prod (with confirmation)"
        echo "  status              - Show current GitFlow status"
        echo "  init                - Initialize GitFlow branches"
        echo ""
        echo "GitFlow Strategy:"
        echo "  dev → staging  : MERGE"
        echo "  staging → mstg : RELEASE (with tags)"
        echo "  mstg → prod    : MERGE (with final tags)"
        echo ""
        exit 1
        ;;
esac
