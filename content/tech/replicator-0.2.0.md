+++
title = "Secret Controller pour les gouverner tous !"
date = 2019-01-19T14:01:24+02:00
meta_img = "/img/k8s-logo.png"
tags = ["controller","replicator","kubernetes","secret"]
description = "Secret Controller pour les gouverner tous ! rodesousa/replicator 0.2.0"
slug = "replicator 0.2.0"
+++

J'ai crée un controller k8s, [replicator](https://github.com/rodesousa/replicator), avec la lib [Kazan](https://github.com/obmarg/kazan) (elixir étant devenu ma nouvelle lubie), qui à partir d'une liste de secret "mandatory":

+ ajoute les secrets de référence dans tous les namespaces
+ watche la création de nouveau namespace, et ajoute les secrets de référence

J'ai release mon projet en 0.2.0 qui ajoute la fonctionnalité de synchro des secrets copiés quand un des secrets de réference change.

Voilà Voilà !
