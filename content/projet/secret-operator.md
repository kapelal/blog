+++
title = "Secret Controller ... Secret Operator"
date = 2019-05-16T14:01:24+02:00
meta_img = "/img/k8s-logo.png"
tags = ["operator","replicator","kubernetes","secret"]
description = "Secret Controller ... Secret Operator"
slug = "secret operator"
+++

Comme ces temps-ci, je fais pas mal d'operator k8s, j'ai décidé de refaire un de mes controllers en operator

Petit rappel de c'est quoi un <a href="https://kapelal.io/blog/creation-du-blog-partie-3/#title_cert">operator/controller</a>

## Encore 1 !

Aujourd'hui il y a déjà des secrets operators qui font le taff. Beaucoup d'entre eux synchronise une source de vérité (AWS Secrets Manager, Vault..) et les secret K8s.
De mon point de vue, quand le secret source est modifié, ce n'est pas trivial (va et viens entre l'operator et la source de vérité, qui peut être plus au moins long)

Je préfère avoir un namespace "source de vérité" afin d'avoir une base sur laquelle je puisse m'appuyer, pour pas chère (`kubectl get secret`), lors des modifications des secrets sources.

Et j'ai envie de faire de l'Elixir avec [bonny][https://github.com/coryodaniel/bonny]

## 1, 2 ...

A chaque mission je mets en place mon [secret controller](https://github.com/rodesousa/replicator) pour avoir des "secret cluster-wide".
C'est à dire avoir des secrets tagués **mandatory** et les copier dans tous les namespaces (comme des certificats ou des creds de registry)

Quelques soucis:

+ Je n'ai pas facilement la liste de tous mes *mandatories* secret en une commande
+ Il y a des cas où je n'ai pas envie de les avoirs partout
+ Je ne peux pas rajouter, à chaud, des secrets sans redémarrer mon controller

Pour pallier à tout ça, j'ai décidé de faire une CRD :

+ cluster-wide, c'est à dire que les CR ne sont pas un namespace. 
+ avec des [*Additional printer columns*](https://kubernetes.io/docs/tasks/access-kubernetes-api/custom-resources/custom-resource-definitions/#additional-printer-columns), namespace origine et namespace cible
+ qui permet de ne pas redémarer mon application pour ajouter/modifier/supprimer des secrets

## Comment ça se passe ?

*Un dessin !*

![](/img/secret-operator/so-flow.png)

Pour chaque deploy, on a un SecretRef avec:

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

1- L'operator détecte la CR

2- Il récupère le secret source

3- Il crée le secret dans le namespace cible

## Et les customs colonnes ?

```
kubectl get secretrefs
```

![](/img/secret-operator/screen.png)


Sur ce ~
