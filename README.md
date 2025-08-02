# AWS Terraform Lab

Ce repository contient des exercices pratiques pour apprendre Terraform avec AWS.

## Structure du Repository

- **Branche `main`** : Cette branche contient uniquement ce README avec les instructions
- **Branche `lab1`** : Contient le premier laboratoire avec l'infrastructure Terraform complète

## Prérequis

Avant de commencer les laboratoires, assurez-vous d'avoir :

1. **Terraform installé** (version >= 1.0)
   ```bash
   # Vérifiez votre installation
   terraform version
   ```

2. **AWS CLI installé et configuré**
   ```bash
   # Installez AWS CLI
   # macOS avec Homebrew
   brew install awscli
   
   # Configurez vos credentials AWS
   aws configure
   ```

3. **Un compte AWS** avec les permissions appropriées

## Comment démarrer

### Étape 1 : Cloner le repository
```bash
git clone <votre-repository-url>
cd AWS_TERRAFORM_LAB
```

### Étape 2 : Basculer vers la branche lab1
```bash
git checkout lab1
```

### Étape 3 : Configurer vos credentials AWS
1. Ouvrez le fichier `lab/infra/provider.tf`
2. Remplacez les credentials d'exemple par vos vraies credentials AWS :
   ```terraform
   provider "aws" {
     region     = "us-east-1"
     access_key = "VOTRE_ACCESS_KEY"
     secret_key = "VOTRE_SECRET_KEY"
   }
   ```

### Étape 4 : Initialiser Terraform
```bash
cd lab/infra
terraform init
```

### Étape 5 : Planifier le déploiement
```bash
terraform plan
```

### Étape 6 : Appliquer la configuration
```bash
terraform apply
```

## Structure du Lab1

```
lab/
└── infra/
    ├── backend.tf      # Configuration du backend S3 pour l'état Terraform
    ├── provider.tf     # Configuration du provider AWS
    └── ec2.tf          # Ressources EC2
```

## Sécurité

⚠️ **Important** : Ne jamais committer vos vraies credentials AWS dans le repository !

Le fichier `provider.tf` est inclus avec des credentials d'exemple. Modifiez-le localement avec vos vraies credentials, mais ne commitez jamais ces modifications.

## Commandes Terraform Utiles

```bash
# Initialiser le projet
terraform init

# Voir le plan d'exécution
terraform plan

# Appliquer les changements
terraform apply

# Détruire l'infrastructure
terraform destroy

# Valider la syntaxe
terraform validate

# Formater le code
terraform fmt
```

## Dépannage

### Erreur de permissions AWS
- Vérifiez que vos credentials AWS sont correctement configurés
- Assurez-vous que votre utilisateur AWS a les permissions nécessaires

### Erreur de backend S3
- Vérifiez que le bucket S3 existe et est accessible
- Assurez-vous que la région est correcte

### Erreur de syntaxe Terraform
```bash
terraform validate
terraform fmt
```

## Ressources Utiles

- [Documentation officielle Terraform](https://www.terraform.io/docs)
- [Provider AWS pour Terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/)

## Support

Pour toute question ou problème, créez une issue dans ce repository.
