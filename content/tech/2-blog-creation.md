+++
title = "Comment j'ai monté mon blog ? [Partie 2]"
date = 2018-10-04T00:13:24+02:00
meta_img = "/img/k8s-logo.png"
tags = ["helm","hugo","kubernetes","ingress controller"]
description = "Comment j'ai monté mon blog ? [Partie 2]"
slug = "Creation du blog [partie 2]"
+++

[[Part 1](https://kapelal.co/blog/comment-jai-monté-mon-blog--partie-1/)]
[[Part 3](https://kapelal.co/blog/creation-du-blog-partie-3)]

### Avant de commencer

Dans la première partie on a fait:

+ [VPC](https://github.com/kapelal/terraform/blob/master/vpc/main.tf)
+ [IP publique](https://github.com/kapelal/terraform/blob/master/dns/kapelal-io-ip.tf)
+ [DNS](https://github.com/kapelal/terraform/blob/master/dns/main.tf)
+ [Cluster K8s](https://github.com/kapelal/terraform/blob/master/k8s/main.tf)

Et dans cette partie, on va installer un [Hugo](https://gohugo.io/) (website framework) mais aussi un reverse proxy

On a besoin d'un RP devant Hugo sinon on ne peut pas relier kapelal.co -> Hugo

![img](/img/2-blog-creation/nginx.png)

### HELM

On ne va pas écrire directement des manifests mais des templates (accompagnés par des valeurs) grâce à [Helm](https://github.com/helm/helm/releases)

Normalement si on fait les choses bien, on a un dépôt de chart versionné (comme [Nexus](https://fr.sonatype.com/nexus-repository-sonatype) pour les artifacts Java) qui permet de déployer les charts Helm.
Par exemple, celui par défaut dans Helm: [code](https://github.com/helm/charts) + [dépôt](https://kubernetes-charts.storage.googleapis.com/)

Pour pas faire trop (ça m'arrange), je vais déployer ma chart [Hugo](https://github.com/kapelal/helm/tree/master/hugo) en local. Dans un prochain article j'installerai [chartmuseum](https://github.com/helm/chartmuseum)
### Prérequis

+ [Helm](https://github.com/helm/helm/releases) ou un container avec
+ Une configuration de kubectl (`~/.kube/config`) qui fonctionne parce que Helm l'utilise
+ De [Tiller](https://docs.helm.sh/install/#installing-tiller), dans sa version 2 (version majeure courante), Helm ne discute pas directement avec le cluster mais avec Tiller

2 choix:

> Je fais une parenthèse sur un composant majeur dans kubernetes. Les [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) (gestion des droits dans K8s)

> C'est un gros morceau. Comme en partie 1, cet article n'est pas un tuto. Je vous conseille d'aller regarder

+ Sans RBAC: `helm init`
+ Avec RBAC: [script](https://github.com/kapelal/terraform/blob/master/init/helm-rbac.yml) à déployer avec `kubectl apply` et ensuite `helm init --service-account tiller`

### Reverse proxy ... ou l'Ingress Controller

Avant d'aller plus loin il faut expliquer l'[Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-controllers)

On peut grossièrement simplifier une application dans Kubernetes comme ça:

![img](/img/2-blog-creation/ingress.png)

Le [service](https://kubernetes.io/docs/concepts/services-networking/service/) sélectionne le(s) pod(s) et expose l'accès au pod à l'intérieur du cluster

```
#Tous les pods du même namespace qui ont le label `app: foo-ap` et `release: 1.0` sont exposés par le service
selector:
    app: foo-app
    release: 1.0
```

L'[ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/) sélectionne le service et expose l'accès à l'extérieur du cluster
```
rules:
  - host: foo.com
    http:
      paths:
        - path: /
          backend:
            serviceName: foo-service
            servicePort: 80
```

Sauf que l'ingress ce n'est que de la conf. J'ai besoin d'un composant qui absorbe mon ingress et qui crée une entrée dans un ... reverse proxy

Kubernetes a donné pour nom Ingress Controller, un reverse proxy qui a la tâche d'absorber les ingress

Fin ~

---

J'utilise [NGINX](http://nginx.org/) avec la [chart officielle](https://github.com/helm/charts/tree/master/stable/nginx-ingress) comme Ingress Controller

Petite particularité, dans mon dépôt [terraform](https://github.com/kapelal/terraform), j'ai demandé une IP publique

```
#https://github.com/kapelal/terraform/blob/master/dns/kapelal-io-ip.tf
resource "google_compute_address" "kapelal-ip" {
  region = "${var.region}"
  name   = "${var.ip_name}"
  }
```

Je vais demander à K8s de me donner un [Load Balancer](https://cloud.google.com/load-balancing/docs/https/) qui aura cette IP (par défaut c'est une IP aléatoire). La demande se fait côté [Service](https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer)

```
...
spec:
  loadBalancerIP: 35.195.111.35
  type: LoadBalancer
...
```

Pourquoi ? Parce que je ne veux pas refaire de manipulation terraform si je dois redéployer mon ingress controller

```
#https://github.com/kapelal/terraform/blob/master/dns/main.tf
resource "google_dns_record_set" "kapelal-dns-record" {
  managed_zone = "${google_dns_managed_zone.default.name}"
  name         = "kapelal.io."
  type         = "A"
  ttl          = 1800
  rrdatas      = ["${google_compute_address.kapelal-ip.address}"]
}
```

Le yaml qui doit être jouer avec la chart

```
# https://github.com/kapelal/helm/blob/master/ingress-controller.yaml
controller:
  tag: "0.12.0"
  ingressClass: nginx-kapelal
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate
  replicaCount: 2
  service:
    loadBalancerIP: 35.195.111.35
  stats:
    enabled: true
  metrics:
    enabled: true
rbac:
  create: true
  serviceAccountName: default
```

Y'a plus qu'à

```
helm upgrade --install stable/nginx-ingress ingress-controller --version 0.20.0 --namespace reverse-proxy --values ./ingress-controller.yaml
```

La demande du Load Balancer est un peu longue. Un petit `kubectl describe service service_name` permet de voir la progression

#### Dernier point

> ingressClass: nginx-kapelal

On peut avoir besoin de plusieurs d'Ingress Controller pour notre infra (nom de domaine interne et externe par exemple). Pour cela les ingress controller ont un paramètre qui permet de poser une [annotation](https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/). L'ingress doit avoir cette même annotation pour être pris en compte

```
metadata:
  annotations:
    kubernetes.io/ingress.class: nginx-kapelal
```

### Hugooo

Je veux un container avec [Hugo](https://github.com/kapelal/gohugo-docker). J'utilise le [dockerhub](https://hub.docker.com/r/kapelal/gohugo-docker/)

Et pour le contenu du blog, le thème etc. un [dépôt git](https://github.com/kapelal/blog)

Donc je peux versionner mon blog et avoir une mécanique à l'intérieur de mon pod, afin de récupérer le contenu de mon blog

![img](/img/2-blog-creation/hugo.png)

Dans notre pod il y a 3 containers:

+ Hugo
+ un script (en [initContainer](https://github.com/kapelal/helm/blob/master/hugo/templates/deployment.yaml)) qui `git clone` le dépôt de blog dans un [volume](https://kubernetes.io/docs/concepts/storage/volumes/)
+ un [autre script](https://github.com/kapelal/git-sync), à intervalles réguliers, qui `git pull`

Le dépôt de la [chart](https://github.com/kapelal/helm/tree/master/hugo) et ses [valeurs](https://github.com/kapelal/helm/blob/master/hugo.yaml)

Y'a plus qu'à

```shell
helm upgrade --install blog ./hugo --namespace blog --values ./hugo.yaml
```

### La suite

Les prochains posts:

+ Helm Chart Repository
+ HTTPS avec Lets Encrypt
+ La CI
+ Logs avec Prometheus
+ Vault
