Exercice : 

# Image to Cluster – Atelier Infrastructure as Code

## Objectif de l’atelier

Cet atelier a pour objectif d’illustrer une chaîne complète d’industrialisation du cycle de vie d’une application simple, depuis la construction d’une image applicative maîtrisée jusqu’à son exécution sur un cluster Kubernetes.

Les outils utilisés sont :
- **GitHub Codespaces** pour un environnement de travail reproductible
- **Packer** pour la construction d’une image Docker customisée
- **K3d** pour l’exécution d’un cluster Kubernetes léger
- **Ansible** (à venir) pour l’automatisation du déploiement applicatif

## Prérequis

- Docker
- Packer
- Ansible
- kubectl
- k3d
- Make

## Structure du projet

.
├── ansible/        # Déploiement Kubernetes
├── k8s/            # Manifests Kubernetes
├── packer/         # Build de l’image Docker
├── index.html      # Application web
├── Makefile        # Orchestration des commandes
└── README.md

## Workflow

1. Build de l’image Docker avec Packer
2. Import de l’image dans le cluster K3d
3. Déploiement Kubernetes via Ansible
4. Exposition du service et test de l’application

## Vérification

Une fois le déploiement terminé :
- Le service Kubernetes est exposé
- L’application est accessible via le port forward
- La page HTML s’affiche correctement

## Commandes Make

| Commande     | Description                          |
|--------------|--------------------------------------|
| make setup   | Initialise l’environnement            |
| make all     | Build et déploie l’application        |
| make status  | Vérifie l’état du cluster              |
| make clean   | Supprime les ressources Kubernetes    |
| make stop    | Arrête le cluster K3d                 |

## Points clés

- Déploiement 100 % automatisé
- Infrastructure as Code
- Reproductibilité via Codespaces
- Chaîne complète : code → image → cluster

## Conclusion

Ce projet illustre un pipeline DevOps complet permettant de passer d’un simple artefact applicatif à un déploiement Kubernetes automatisé et reproductible.
