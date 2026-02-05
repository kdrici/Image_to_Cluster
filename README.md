Exercice : 

# Image to Cluster – Atelier Infrastructure as Code

## Objectif de l’atelier

Cet atelier a pour objectif d’illustrer une chaîne complète d’industrialisation du cycle de vie d’une application simple, depuis la construction d’une image applicative maîtrisée jusqu’à son exécution sur un cluster Kubernetes.

Les outils utilisés sont :
- **GitHub Codespaces** pour un environnement de travail reproductible
- **Packer** pour la construction d’une image Docker customisée
- **K3d** pour l’exécution d’un cluster Kubernetes léger
- **Ansible** (à venir) pour l’automatisation du déploiement applicatif

Les commandes pour tester : 

  Initialisation
  make setup

  Déploiement complet
  make all

  Vérification
  make status
