+++
title = "Comment j'ai monté mon blog ? [Partie 3]"
date = 2018-12-11T00:13:24+02:00
meta_img = "/img/k8s-logo.png"
tags = ["helm","hugo","kubernetes","cert-manager","tls","ssl","https"]
description = "Comment j'ai monté mon blog ? [Partie 3]"
slug = "Creation du blog [partie 3]"
+++

[[Part 1](https://kapelal.io/blog/comment-jai-monté-mon-blog--partie-1/)]
[[Part 2](https://kapelal.io/blog/creation-du-blog-partie-2)]

### Previously On ... Kapelal !

+ Un projet GCP sous terraform avec un Kubernetes managé (GKE).
+ Un ingress controller (nginx).
+ Un déploiement Hugo sous k8s synchronisé avec un dépôt git (le contenu du blog).

Maintenant je m'attaque à la partie https du blog.

On a simplement besoin d'un certificat TLS. Comme pour toutes les autres actions, je ne souhaite pas avoir des actions manuelles. Pour cela je vais utiliser [cert manager](https://github.com/jetstack/cert-manager).

### <div id="title_cert">Cert manager</div>

Cert manager est une solution qui administre la vie de certificat TLS avec [Letsencrypt](https://letsencrypt.org/) sous k8s.

> Je vais parler d'objet k8s qui s'appelle les [Custom Resources Definitions](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) (CRD). Un pod, service, ingress, secret etc. sont les ressources "core" de k8s. Avec les CRD, on peut ajouter d'autres objets qui auront d'autres rôles.
>
> La déclaration d'une CRD est simple

```
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: issuers.certmanager.k8s.io
spec:
  group: certmanager.k8s.io
  names:
    kind: Issuer
    listKind: IssuerList
    plural: issuers
    singular: issuer
  scope: Namespaced
  version: v1alpha1
 ```
> Comme pour l'ingress controller avec l'ingress, la CRD a aussi besoin de son controller. D'un mécanisme qui va venir absorber la ressource pour en faire quelque chose.

La solution s'appuie sur 2 [CRD](http://docs.cert-manager.io/en/latest/reference/index.html) pour décrire:

+ **Issuer**: comment on discute avec Letsencrypt.
+ **Certificate**: quel est la forme des certificats TLS.

Une chart [cert manager](https://github.com/helm/charts/tree/master/stable/cert-manager) existe déjà et on va la prendre.

### Issuer

La [doc](http://docs.cert-manager.io/en/latest/reference/issuers.html)

```
apiVersion: certmanager.k8s.io/v1alpha1
kind: Issuer
metadata:
  name: "letsencrypt-prod-RELEASE-NAME"
  labels:
    app: RELEASE-NAME-cert-impl
    chart: "cert-impl-0.1.0"
    release: "RELEASE-NAME"
    heritage: "Tiller"
spec:
  acme:
    server: "https://acme-v02.api.letsencrypt.org/directory"
    email: "foo@bar.com"
    privateKeySecretRef:
      name: "letsencrypt-prod-private-key"
    dns01:
      providers:
      - name: clouddns
        clouddns:
          project: "kapelal-203808"
          serviceAccountSecretRef:
            name: "cloud-sa"
            key: "credentials.json"
```

Pour simplifier, on déclare quel est:

+ l'URL, l'autorité de certification, qui va nous délivrer un certificat.
+ le type de challenge que l'autorité de certification va utiliser, afin de vérifier que je suis bien propriétaire du nom de domaine que je souhaite sécuriser.

Moi j'ai choisi d'utiliser le challenge DNS. Il y a aussi le challenge HTTP, voir la [doc](https://letsencrypt.org/how-it-works/).

Pour le challenge DNS, cert manager a besoin de pouvoir créer une entrée DNS. C'est pas magique, il faut lui filer un service account GCP qui en donne le droit.

Pas de clic clic, on le fait avec [terraform](https://github.com/kapelal/terraform/tree/master/service_account)

```
# https://github.com/kapelal/terraform/tree/master/service_account
resource "google_service_account" "dns-admin" {
  account_id   = "dns-admin"
  display_name = "dns-admin"
  project = "${var.project}"
}

resource "google_service_account_key" "dns-admin-key" {
  service_account_id = "${google_service_account.dns-admin.name}"
  public_key_type = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_member" "service-accounts" {
  role   = "roles/dns.admin"
  member = "serviceAccount:${google_service_account.dns-admin.email}"
}
```

Ce qu'on souhaite aussi, c'est de stocker le service account dans le cluster k8s pour cert-manager (avec les mêmes informations que `serviceAccountSecretRef`).

Terraform sait le faire aussi

```
# https://github.com/kapelal/terraform/tree/master/service_account

provider "kubernetes" {
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "cloud-sa"
    namespace = "reverse-proxy"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.dns-admin-key.private_key)}"
  }
}
```

> Pour configurer le provider kubernetes, il faut avoir un `kubectl` avec une conf valide sur la machine qui lance terraform. J'utilise docker pour me simplifier la tâche https://github.com/kapelal/terraform/blob/master/service_account/Makefile

Un conseil, il y a 2 autorités de certification avec Letsencrypt, une staging et une prod https://letsencrypt.org/docs/rate-limits/. Commencer par la staging !

### Certificate

La [doc](http://docs.cert-manager.io/en/latest/reference/certificates.html)

```
apiVersion: certmanager.k8s.io/v1alpha1
kind: Certificate
metadata:
  name: tls.kapelal.io-tls
spec:
  acme:
    config:
    - dns01:
        provider: clouddns
      domains:
      - kapelal.io
  dnsNames:
  - kapelal.io
  issuerRef:
    kind: Issuer
    name: letsencrypt-prod-tls
  secretName: tls.kapelal.io
```

Pour simplifier, on déclare quel est:

+ le issuer et le challenge utilisés
+ le nom du secret k8s où sera stocké le certificat TLS
+ le nom de domaine a protégé

Quand on déploie le certificate, un coup de `kubectl describe certificates NOM_DU_CERTIFICATE` afin de vérifier si le challenge a réussi.

### Chart Helm

Les [values](https://github.com/kapelal/helm/blob/master/cert-manager.yaml) que j'utilise pour [cert manager](https://github.com/helm/charts/tree/master/stable/cert-manager)

Pour créer le certificate et l'issuer, j'utilise cette [chart](https://github.com/kapelal/helm/tree/master/cert-impl) avec ces [values](https://github.com/kapelal/helm/blob/master/tls.yaml)

### Hugo x TLS

L'ajout du certificat TLS, avec nginx, sous k8s, se fait coté ingress

```
# https://github.com/kapelal/helm/blob/master/hugo/templates/ingress.yaml
spec:
  rules:
  - host: kapelal.io
    http:
      paths:
      - backend:
          serviceName: blog-hugo
          servicePort: 443
        path: /
  tls:
  - hosts:
    - kapelal.io
    secretName: tls.kapelal.io
```

Mais j'ai déployé mon certificate dans un namespace différent que celui de Hugo. Parce que demain, il n'y a pas que hugo qui aura besoin du certificat. Il faut le copier dans son namespace.

Pas de clic clic ou de commande `kubectl` dans un Readme. Mais plutôt un controller k8s qui permet de copier une liste de secret dans tous les namespaces. Je le veux pas en one shot mais qu'a chaque nouveau namespace, cette liste soit copiée.

Comme je suis devenu récemment fan [d'Elixir](https://elixir-lang.org/), avec une [lib qui tape les API k8s en elixir](https://github.com/obmarg/kazan), j'ai dev un controller k8s: https://github.com/rodesousa/replicator

Un jour, un article dessus, mais là ce n'est pas le sujet

La [chart](https://github.com/rodesousa/replicator/tree/master/chart/replicator) et ses [values](https://github.com/kapelal/helm/blob/master/replicator.yaml)

Quelques changements dans la [chart Hugo](https://github.com/kapelal/helm/tree/master/hugo) et ses [values](https://github.com/kapelal/helm/blob/master/hugo.yaml) pour basculer en https

Fin~

### La suite

Les prochains posts:

+ Helm Chart Repository
+ Metrics avec Prometheus
+ Log avec Kibana/Fluent
+ Vault
