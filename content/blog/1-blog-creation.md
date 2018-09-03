+++
title = "Comment j'ai monté mon blog ? [Partie 1]"
date = 2018-07-05T14:01:24+02:00
draft = true
meta_img = "/images/image.jpg"
tags = ["gcloud","terraform","kubernetes","hugo"]
description = "Comment j'ai monté mon blog ? [Partie 1]"
+++

### Avant de commencer

J'utilise Kubernetes depuis + d'un an au boulot et j'ai envie d'avoir des répôts/outils/scripts pour mes prochaines utilisations. Ce blog est un prétexte pour faire tout ça.
Il y a beaucoup plus simple, par exemple [netlify](https://www.netlify.com/)

Je ne vais pas rentrer dans les détails sur les différents objets Google et Terraform, ce n'est pas le but. C'est plus un exercice de présentation à une tierce personne qui aurait choisi de faire du gcloud avec terraform.

### Liste des courses

+ Cloud: [Google Cloud Platform](https://cloud.google.com/) avec [Terraform](https://www.terraform.io/)
+ Blog: [Hugo](https://gohugo.io/) sous [K8s](https://kubernetes.io/)
+ Code: Sur [github/kapelal](https://github.com/kapelal) et quelques images sur le [hub docker public](https://hub.docker.com/)

Un sensei m'a dit un jour *qui deploie à la main redéploie le lendemain*. On va éviter toutes actions manuelles et tout faire en IaC.

Un dépôt terraform avec toutes mon infra !

### Le marteau et la faucille

Pour voir, lister, ajouter ce que nous allons créer vous pouvez soit passer par les images docker, ce que je vais faire, soit télécharger les outils:

+ [gcloud](https://cloud.google.com/sdk/install)
+ [terraform](https://www.terraform.io/downloads.html)

### Jour de Paye

Avec une addresse `*.gmail.com`, il faut créer un compte [Google Cloud Platform](https://cloud.google.com/). 300 balles gratos ! C'est amplement suffisant pour se faire les dents.

### Multipass

Sur la [cloud console](https://console.cloud.google.com/) dans `IAM / Administration` -> `Compte de service` il faut créer une compte de service, genèrer une clé et la stocker sur son pc.

C'est fini, il n'y a plus aucune autre action manuelle, on continue à faire de l'infra mais sans les mains !

### VPC / DNS / K8s avec Terraform

Le code se trouve ici [kapelal/terraform](https://github.com/kapelal/terraform)

Dans chaque dossier on a quelques choses comme ça:

```
config.backend
main.tf
Makefile
outputs.tf
vars.tf
vars.tfvars
```

+ `config.backend` sert à la phase d'init (`terraform init`) pour générer la conf des backends (ici [backend gcs](https://www.terraform.io/docs/backends/types/gcs.html)) (qui est déclaré dans le `main.tf`) [Doc](https://www.terraform.io/docs/backends/config.html)

+ `main.tf` l'infra qui va être créé.

Terraform stocke l'état de l'infra dans un `.tfstate`. Sauvegarder c'est bien, mais si ça reste sur le pc c'est zéro ! On stock tout ça dans un bucket

```
terraform {
  backend "gcs" {
    prefix = "k8s"
  }

  required_version = "= 0.11.3"
}
```

+ `outputs.tf` sert à partager certaines variables avec les .tfstate. [Doc](https://www.terraform.io/intro/getting-started/outputs.html)

Exemple dans [k8s/main.tf](https://github.com/kapelal/terraform/blob/master/k8s/main.tf) on récupère le .tfstate de [k8s/vpc](https://github.com/kapelal/terraform/tree/master/vpc)
```
data "terraform_remote_state" "vpc" {
  backend = "gcs"

  config {
    bucket = "${var.bucket}"
    prefix = "vpc"
  }
}
```

On utilise un output qui a été déclaré

[vpc/outputs.tf](https://github.com/kapelal/terraform/blob/master/vpc/outputs.tf)
```
output "name" {
  value = "${google_compute_network.default.name}"
}
```

[k8s/main.tf](https://github.com/kapelal/terraform/blob/master/k8s/main.tf)
```
data "google_compute_zones" "available" {}

resource "google_container_cluster" "default" {
  name               = "${var.project}"
  network            = "${data.terraform_remote_state.vpc.name}"
...
```

On peut voir les outputs de chaque dossier avec la commande:
```
make output
```

+ `var.tf` et `var.tfvars` déclaration et initialisation des variables. [Doc](https://www.terraform.io/intro/getting-started/variables.html)

+ `Makefile` encapsulation de commande pour faire du terraform avec des images docker.

Dans [terraform.mk](https://github.com/kapelal/terraform/blob/master/terraform.mk) il faut éditer
```
ifndef CREDENTIALS
	CREDENTIALS =
endif
```

Et mettre le path de la clé qui a été généré plus haut.

Je résume ce qu'on va créer:
+ Une zone reseau, un vpc
+ Une IP externe, l'ip qui sera derrière `kapelal.io`
+ Une résolution DNS, pour la connexion nom de domaine -> ip
+ Un K8s

Un coup de make dans chaque dossier: vpc -> dns -> k8s

Je vous laisse jouer avec la cloud console pour voir les objets créés.

### La suite

Les prochains posts:

+ Hugo sous K8s
+ HTTPS avec Lets Encrypt
+ La CI
+ Logs avec Prometheus
+ Vault
