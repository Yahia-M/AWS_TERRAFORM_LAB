# 🌊 Git Flow - AWS Terraform Lab

## 📋 **Architecture des branches**

```
main (protection: ✅)
├── dev (développement + SonarQube)
├── staging (pré-production)
├── mstg (master staging - validation finale)
└── prod (production)
```

## 🏗️ **Structure des branches**

### **🔧 `dev` - Développement**
- **Objectif** : Développement actif et tests
- **Protection** : ❌ (accès libre pour développement)
- **CI/CD** : SonarQube + tests automatisés
- **Infrastructure** : Environnement de dev AWS
- **Merge** : Vers `staging`

### **🧪 `staging` - Pré-production**
- **Objectif** : Tests d'intégration et validation
- **Protection** : ✅ (PR required)
- **CI/CD** : Tests E2E + validation infrastructure
- **Infrastructure** : Environnement de staging AWS
- **Stratégie** : **MERGE** depuis `dev`

### **🚀 `mstg` - Master Staging**
- **Objectif** : Validation finale avant production
- **Protection** : ✅ (PR + reviews required)
- **CI/CD** : Tests de performance + sécurité
- **Infrastructure** : Environnement quasi-prod AWS
- **Stratégie** : **RELEASE** depuis `staging` (avec tags)

### **🏆 `prod` - Production**
- **Objectif** : Environnement de production
- **Protection** : 🔒 (PR + 2 reviews + approvals)
- **CI/CD** : Déploiement contrôlé + monitoring
- **Infrastructure** : Production AWS
- **Stratégie** : **MERGE** depuis `mstg` (avec tags finaux)

## 🔄 **Workflow de développement**

### **1. Développement de fonctionnalités**
```bash
# Créer une branche feature depuis dev
git checkout dev
git pull origin dev
git checkout -b feature/nouvelle-fonctionnalite

# Développer et committer
git add .
git commit -m "feat: ajouter nouvelle infrastructure VPC"

# Pousser et créer PR vers dev
git push origin feature/nouvelle-fonctionnalite
```

### **2. Pipeline dev → staging → mstg → prod**
```bash
# 1. Merge feature → dev (après SonarQube ✅)
git checkout dev
git merge feature/nouvelle-fonctionnalite
git push origin dev

# 2. MERGE dev → staging
git checkout staging
git merge dev
git push origin staging

# 3. RELEASE staging → mstg (après validation)
git checkout staging
git tag -a "staging-v1.2.3-rc.1" -m "Release candidate for MSTG"
git push origin staging-v1.2.3-rc.1

# Créer la release vers mstg
git checkout mstg
git merge --no-ff staging -m "Release v1.2.3-rc.1 to MSTG"
git push origin mstg

# 4. MERGE mstg → prod (après approbation finale)
git checkout prod
git merge --no-ff mstg -m "Production deployment v1.2.3"
git tag -a "v1.2.3" -m "Production release v1.2.3"
git push origin prod
git push origin v1.2.3
```

## 🛡️ **Protection des branches**

### **Configuration GitHub/GitLab**
```yaml
# .github/branch-protection.yml
protection_rules:
  staging:
    required_status_checks: true
    required_pull_request_reviews: 1
    dismiss_stale_reviews: true
    
  mstg:
    required_status_checks: true
    required_pull_request_reviews: 2
    dismiss_stale_reviews: true
    require_code_owner_reviews: true
    
  prod:
    required_status_checks: true
    required_pull_request_reviews: 2
    dismiss_stale_reviews: true
    require_code_owner_reviews: true
    required_approving_review_count: 2
```

## 📊 **Intégration SonarQube sur `dev`**

### **Configuration SonarQube**
```yaml
# sonar-project.properties
sonar.projectKey=aws-terraform-lab
sonar.projectName=AWS Terraform Lab
sonar.projectVersion=1.0
sonar.sources=lab/infra
sonar.exclusions=**/*.tfstate,**/.terraform/**
sonar.terraform.file.suffixes=.tf,.tfvars

# Métriques de qualité
sonar.qualitygate.wait=true
sonar.coverage.exclusions=**/*.tf
```

### **Pipeline CI pour `dev`**
```yaml
# .github/workflows/dev-pipeline.yml
name: Dev Pipeline with SonarQube

on:
  push:
    branches: [ dev ]
  pull_request:
    branches: [ dev ]

jobs:
  sonarqube:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
          
      - name: SonarQube Scan
        uses: sonarqube-quality-gate-action@master
        env:
          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
          SONAR_HOST_URL: ${{ secrets.SONAR_HOST_URL }}
          
      - name: Terraform Validate
        run: |
          cd lab/infra
          terraform init -backend=false
          terraform validate
          terraform fmt -check
          
      - name: TFLint
        run: |
          curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
          cd lab/infra
          tflint
```

## 🚀 **Pipelines par environnement**

### **🔧 Dev Pipeline (avec SonarQube)**
```bash
# Trigger: Push sur dev
1. ✅ SonarQube Quality Gate
2. ✅ Terraform validate/fmt/lint
3. ✅ Security scan (Checkov)
4. ✅ Deploy to dev environment
5. ✅ Integration tests
6. 🔄 Auto-merge ready vers staging
```

### **🧪 Staging Pipeline (MERGE strategy)**
```bash
# Trigger: Merge depuis dev
1. ✅ All dev checks
2. ✅ E2E tests
3. ✅ Infrastructure drift detection
4. ✅ Deploy to staging environment
5. ✅ Smoke tests
6. 🏷️ Prêt pour release vers mstg
```

### **🚀 MSTG Pipeline (RELEASE strategy)**
```bash
# Trigger: Release tag depuis staging
1. ✅ All staging checks
2. ✅ Performance tests
3. ✅ Security penetration tests
4. ✅ Deploy to mstg environment
5. ✅ User acceptance tests
6. 🔄 Ready for merge vers prod
```

### **🏆 Prod Pipeline (MERGE strategy)**
```bash
# Trigger: Merge depuis mstg (manual approval)
1. ✅ All mstg checks
2. ✅ Change management approval
3. ✅ Blue/Green deployment
4. ✅ Health checks
5. ✅ Monitoring alerts setup
6. 🏷️ Production tag final
```

## 🏷️ **Stratégie de tags et releases**

### **Convention de nommage**
```bash
# Dev releases (automatiques)
dev-v1.2.3-beta.1
dev-v1.2.3-beta.2

# Staging releases
staging-v1.2.3-rc.1
staging-v1.2.3-rc.2

# MSTG releases
mstg-v1.2.3-release-candidate

# Production releases
v1.2.3
v1.2.4
```

### **Commandes de tagging**
```bash
# Tag automatique en dev (CI)
git tag "dev-v$(date +%Y.%m.%d)-beta.${BUILD_NUMBER}"

# Tag manuel pour staging
git tag -a "staging-v1.2.3-rc.1" -m "Release candidate 1"

# Tag de production
git tag -a "v1.2.3" -m "Production release v1.2.3"
git push origin v1.2.3
```

## 🛠️ **Outils et intégrations**

### **Qualité de code (dev)**
- **SonarQube** : Analyse statique du code Terraform
- **TFLint** : Linter Terraform
- **Checkov** : Analyse de sécurité
- **terraform fmt** : Formatage automatique

### **Tests par environnement**
- **Dev** : Unit tests + SonarQube
- **Staging** : Integration tests + E2E
- **MSTG** : Performance + Security tests
- **Prod** : Health checks + Monitoring

### **Notifications**
```yaml
# Slack notifications
dev_channel: "#dev-terraform"
staging_channel: "#staging-releases"
mstg_channel: "#release-candidates"
prod_channel: "#production-alerts"
```

## 📋 **Checklist de promotion**

### **✅ Dev → Staging (MERGE)**
- [ ] SonarQube Quality Gate passed
- [ ] All tests passing
- [ ] Terraform validate/fmt/lint OK
- [ ] Security scan passed
- [ ] Code review completed
- [ ] **Action**: `git merge dev` sur staging

### **✅ Staging → MSTG (RELEASE)**
- [ ] E2E tests passed
- [ ] Infrastructure validated
- [ ] Performance acceptable
- [ ] Security review completed
- [ ] Documentation updated
- [ ] **Action**: Créer release tag depuis staging
- [ ] **Action**: `git merge staging` sur mstg

### **✅ MSTG → Prod (MERGE)**
- [ ] UAT completed and signed-off
- [ ] Change management approved
- [ ] Rollback plan prepared
- [ ] Monitoring configured
- [ ] On-call team notified
- [ ] **Action**: `git merge mstg` sur prod
- [ ] **Action**: Créer tag de production final

Ce Git Flow vous permettra de maintenir une qualité de code élevée avec SonarQube en dev, tout en assurant une progression contrôlée vers la production ! 🎯
