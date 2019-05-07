+++
title = "Secret Controller pour les gouverner tous !"
date = 2019-01-19T14:01:24+02:00
meta_img = "/img/k8s-logo.png"
tags = ["controller","replicator","kubernetes","secret"]
description = "Secret Controller pour les gouverner tous ! rodesousa/replicator 0.2.0"
slug = "secret operator"
+++

Comme ces temps ci, je fais pas mal de operator k8s, j'ai decidé de refaire un de mes controller en operator

Petit rappel de c'est quoi un <a href="//blog/creation-du-blog-partie-3/#title_cert">operator/controller</a>

## Encore 1 !

Aujourdhui il y a deja des secret operators qui font le taff. Beaucoup d'entre eux synchronise entre une source de vérité (AWS Secrets Manager, Vault..) et le K8s.
De mon point de vue, quand le secret source est modifié, ce n'est pas trivial (va et viens entre l'operator et la source de vérité, qui peut être plus au moins long)

Je prèfere avoir un namespace "source de vérité" afin d'avoir une base sur laquelle je puisse m'appuyer, pour pas chère (`kubectl get secret`), lors des modifications des secrets source.

Et j'ai envie de faire du Elixir avec [bonny][https://github.com/coryodaniel/bonny]

## 1, 2 ...

A chaque mission je met en place mon [secret controller](https://github.com/rodesousa/replicator) pour avoir des "secret cluster-wide".
C'est à dire avoir des secrets tagué **mandatory** et les copier dans tous les namespaces (comme des certificats ou des creds registry)

Quelque soucis:

+ Je n'ai pas facilement la liste de tous mes *mandatories* secret en une commande
+ Il y a des cas où je n'ai pas envie de les avoirs partout
+ Je ne peux pas rajouter, à chaud, des secrets sans redemarrer mon controller

Pour palier à tous ça, j'ai decidé de faire une CRD :

+ cluster-wide, c'est à dire que les CR ne sont pas un namespace. 
+ avec des [*Additional printer columns*](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#additional-printer-columns), origine du secrets et copies des secrets
+ qui permet de pas redémarer mon application pour ajouter/modifier/supprimer des secrets

## Comment ça se passe ?

*Un dessin !*

![](secret_operator.jpeg)

Donc pour chaque deploy, on doit avoir un SecretRef avec:

+ nom du secret, `secretName`
+ namespace origine, `originNamespace`
+ namespace cible, `targetNamespace`

```yaml
apiVersion: secret-operator.example.com/v1
kind: SecretRef
metadata:
  name: test
spec:
  originNamespace: secret
  targetNamespace: default
  secretName: mysecret2
```

L'opérator s'occupe de le copier !

## Et les custom colonnes ?

```
kubectl get secretrefs
```

![](img/secret-operator/screen.png)



Sur ce ~
