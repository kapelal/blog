+++
title = "Division du travail IT & DevOps"
date = 2019-07-10T14:01:24+02:00
meta_img = "/img/adam_smith_photo.png"
tags = ["DevOps","division du travail"]
description = "Division du travail IT & DevOps"
slug = "Division du travail IT et DevOps"
+++

Quand j'ai commencé à bosser dans l'IT c'était en 2013. J'ai eu la chance d'avoir trouvé un stage où on devait développer une application ainsi que son infra.
J'ai encore eu de la chance d'avoir fait partie de ces deux sous-ensembles de l'équipe. 
Même si on avait nos propres enviros, la preprod et la prod était entre les mains d'un prestataire.

C'est là que j'ai découvert une guerre séculaire entre ceux qui livrent et ceux qui installent. Déterminé comme tous les autres, j'ai participé à ce grand rite, mais en ayant la chance de changer souvent de camp.

Maintenant j'ai un peu roulé ma bosse et vécu des contextes différents et des méthodes de travail différentes. Du scrum, du kanban, des anti-agiles, mais pas encore d'organisation du travail autour de la [prise de décisions asynchrone](https://www.youtube.com/watch?v=xkC4zjtAyRc)

En tout cas l'un des points communs, c'est la division du travail.

### What ??

Dans *la richesse des nations* d'Adam Smith, il tombe sur une entreprise qui fabrique des aiguilles. Il remarque que l'entreprise a découpé les tâches pour que les ouvriers se concentrent sur un seul type d'opération et à pour conséquence d'augmenter nettement la production d'aiguille. A. Smith comprend que cette spécialisation des métiers est un coefficient multiplicateur de la production et rend indissociable le progrès économique et la division du travail. 

SHAZAM ! Le terme division du travail est né.

Aujourd'hui je défie quiconque de me dire comment on produit le moindre **stylo**, des matières premières à sa livraison.

### L'IT dans tout ça ?

En informatique, comme dans tous les métiers (non artisanaux), on retrouve cette spécialisation des métiers (donc la division du travail). On a des dev qui dev, on a des ops ... qui ... ops, on a des testeurs qui testent et des agilistes qui s'agitent.

Même question que pour le **stylo**, d'après l'**Institut de mes Yeux et de mes Oreilles** (**IYO** pour la suite), dans une équipe, peu de personnes peuvent donner une vue d'ensemble du cycle de vie de leur application qui aille au-delà de l'ouverture du .gitlab-ci.yaml.

### Et le DevOps ?

Et la culture DevOps dans tout ça ? Même si tout le monde a sa définition, l'une de ses missions est d'ajouter un peu de clarté dans le cycle de vie d'une application.

Pour moi c'est, comment peut-on transformer les problématiques de tout le monde en problématique commune ?
Et dans commune, c'est "au moins s'intéresser" !

### Comment on lie les deux ?

Ah ! Alors comment on peut diviser le travail, pour produire plus tout en restant clair pour tous ?

J'ai pas de plan magique, mais je constate des choses à mon niveau.

Selon l'**IYO**, l'une d'elle, que tout le monde a fait et continue beaucoup de faire, est de créer une équipe transverse "DevOps" !

Aaaaaah, marrant ça pour un mouvement qui devait casser les murs entre les différents acteurs. 

Une équipe externe qui doit implémenter un outil et le livrer à une équipe (ou à une seule personne qu'on nomme aussi "DevOps", une culture qui s'est faite homme dans la bouche de beaucoup de gens) qui doit se conformer à suivre.

> Je parle seulement des entreprises qui ont choisi d'avoir un pôle "DevOps" et donc souvent, avec un interlocuteur esseulé (un "DevOps") dans une équipe produit.

Alors je crois que ça n'a jamais marché. Jamais ? Toute proportion gardée... ça a fonctionné et ça fonctionne, mais il y a beaucoup de casse (toujours et encore selon **IYO**). On fait quoi des gaulois réfractaire ? Comment ne pas avoir un effet tour d'ivoire ? Les problèmes de périmètre ?

Et malheureusement l'outillage est souvent choisi comme solution. Comme si la non connaissance du cycle de vie d'une application pouvait se combler par un outil. Modulo troll, il y a bien des coachs (avec un TJM à 1000) qui accompagnent ce genre de transition.

Je ne vais pas expliquer comment faire une bonne intégration de la culture DevOps parce que cela dépend **toujours du contexte**. 
Mais si on me demande quand même je dirais:

- de la lecture autour du "CALMS"
- du temps (envie de faire un t-shirt "take time and CALMS")
- plus de liberté pour l'équipe. Ce qui ne doit pas du tout déboucher à un non management pour finir avec du "vous aviez la main, si vous n'avez pas réussi c'est votre faute". Ce qui malheureusement me fait penser aux nombreux cas de France Télécom

### Si t'as pas de solution tu vas parler de quoi ?

Je vais essayer modestement d'écrire ce que j'ai constaté pendant mes missions et lors de mes débats avec d'autres collègues.

Le fil rouge c'est bien de regardé les effets de la division du travail dans l'IT. J'ajouterai un peu des implémentation de la culture DevOps que j'ai vu et un peu d'Agile.

C'est ma vérité (et non pas la vérité vraie), donc ne vaut pas grand chose ... après si je peux vous déterminer ;)

> Au sujet de la division du travail.
>
> Loin de moi l'idée de comparer avec ce que subissent les ouvriers sur une chaîne de production, je souhaite simplement regarder les méfaits de la division dans l'IT.

## La division et la propriété d'usage du backlog

Si on reprend le champ lexical mathématique, la division est une opération d'arithmétique élémentaire, avec un dividende et un diviseur associés à un quotient et un reste. En gros, dans une division, il n'y a pas de place au doute !

Quand on divise pour mieux régner, on gagne en performance. Chez nous on va parler de **delivery**.

Et comme l'Agile est partout, qu'est ce qu'on retrouve en son coeur ? Le **backlog** !

Alors on divise pour finir (toujours plus) des users stories du backlog.

Si on fait un mapping foireux avec le backlog et la division, on peut définir le backlog comme le **dividende** de la division (ou la somme des points de complexité des users stories), les différentes de users stories en **diviseur** et leurs points de complexité en **quotient**.

Et le **reste** ?

Le reste, c'est ce qui n'est pas divisible. Donc pas de story dans le backlog.

- Veille technique
- Les refactos ou tout ce qui concerne la dette
- Les pocs
- Les tests (ne t'excite pas j'y reviendrai !)
- La doc (ne t'excite pas j'y reviendrai !)

> « Ce n'est pas le PO ou le client qui va se taper des libs obsolètes ou des scripts sur un NFS sans README »
>
> Michelle

On essaye quand même de jouer le jeu en expliquant pourquoi c'est necéssaire d'intégrer ce reste pendant les groomings, plannings et rétros.

On peut voir l'apparition de backlogs transverse, techniques, DevOps, dette afin de quand même lister ce qu'on pense légitime ... mais finit dans des tableaux jira oubliés.
Et de semaine en semaine on se détermine à accepter cette division. C'est le backlog qui mène la danse, l'équipe suit le pas.

> On voit du shadow apparaitre, spasme musculaire d'un idéal lointain, afin de réaliser ce qui n'est pas dans le backlog.

Pour certains sujets, il y a moins de débat à faire. Les tests et la doc font maintenant partie de ce découpage (moyennant ou pas du temps ou des points de complexité en plus). Je le vois comme une tentative réussie par mes pairs lors d'interminables réunions.

Donc on peut constater que la question du qui divise permet de contrôler ce que fait l'équipe (son but premier n'est plus de construire une solution, mais de suivre un backlog à la lettre) voire d'infantiliser en l'enfermant dans un périmètre.

Depuis peu, j'ai l'intime conviction que les travailleurs (ceux qui utilisent vim, intellij ou visual studio) peuvent, et doivent, s'auto-organiser.

Ce n'est pas une critique de l'Agile et je ne dis pas que l'équipe doit rentre des comptes qu'à elle même.

J'essaye d'exprimer que comme la division est au/le coeur du backlog, la question des **rapports de force** de qui choisit les users stories, leur complexité et surtout leurs priorités est essentielle à une bonne organisation du travail.

> « Je viens vers le PO en lui expliquant qu'il nous faut de la place pour mettre à jours notre stack parce que l'équipe se démoralise et qu'on arrive pas a recruter ... lui il me parle d'un ROI. C'est compliqué ! »
>
> Mohamed

## La compassion et l'égoïsme

Toujours et encore dans *la richesse des nations* de A. Smith, un paragraphe célèbre parle d'égoïsme:

> Tout en ne cherchant que son intérêt personnel, il travaille souvent d'une manière bien plus efficace pour l'intérêt de la société, que s'il avait réellement pour but d'y travailler.

On peut remplacer aisément *société* par *entreprise* ou simplement par *équipe*. L'intérêt personnel est devenu une philosophie début du 20ème siècle.

J'ai cette impression de retrouver ce modèle dans nos organisations de travail IT. 

- Le dev il dev (l'ops lui ne dev pas, il scripte. Distinction débile selon moi)
- L'ops... fait tout le reste quoi

Pas besoin de partager grand chose, si chacun fait bien son job, ça nourrit l'intérêt personnel, donc bon pour l'équipe.

Mais quand un des rouages va moins vite, moins haut, moins fort, on fait quoi ?

Selon l'**IYO**, on va identifier ce rouage comme problème dans le cycle de vie et a intérêt à se bouger le cul. 

Qu'es ce qu'on a avec une difficulté non partagée ? Des gens un peu seuls dans leur misère.

> « Parce que c'est pas mon périmètre !
> Moi j'ai déjà assez de taff. J'aime aussi prendre mon temps mais de toute façon c'est pas à mois de rendre des comptes sur cette partie ! 
>
> Chacun sa merde ! On peut pas être au four et au moulin ! »
>
> Julien

Et souvent certaines tâches qui sont de l'ordre du commun (parce que le périmètre est à la jonction des différentes équipes) sont systématiquement attribuées à quelqu'un (ou à un sous ensemble de personnes identifiées qui devraient résoudre au mieux cette tâche)

Des exemples:

- CI/CD
- Test post install
- Monitorer l'appli

Mettre ça en commun ?

> C'est pas assez productif
>
> Sarah

Selon **IYO**, la non mise en commun se caractérise par un manque de communication et le non partage des problématiques entre les différents acteurs. Une non compassion, même au sein d'une équipe notamment à cause de cette spécialisation des métiers.

Si pas de commun ... on divise. Communauté des archis, des dev, des ops, de prod ou d'astreinte, qui ont pour rôle de renforcer la communication et le suivi à propos des choix qui pourraient impacter au-delà de la propre division.

On a tous vu dans les présentations DevOps, des schémas de mur entre le dev et l'ops avec une image de superman qui casse le mur...

> « Si notre entitée SRE qui gère notre usine logicielle pour simplifier les déploiements, n'a pas dans sa bibliothèque le middleware qu'on demande. Faut attendre ! Même si on est les seuls pour l'instant, faut bien que l'équipe SRE sorte une implémentation assez générique pour des futures équipes. Et faut que Vincent notre DevOps aille porté nos problématiques chez eux. Il va être charger pour lui ce sprint ! »
>
> Romain

Bien sûr, on profite de ces nouvelles **institutions** (légitimées à l'infini parce que les problèmes persistent) pour remonter les points. A qui la faute ? La personne qui veut faire du micro-service alors que l'infra le permet pas ? L'infra qui veut pas bouger de techno depuis 10 ans ? L'intégrateur dans l'équipe qui n'a pas le temps de faire les MEP, de gérer les sous environnements, les incidents et de s'occuper des nouveaux besoins ?

Comme si la spécialisation des métiers déresponsabilise l'équipe en divisant les problématiques.

On préfère chercher des backups et/ou choisir des missionnaires que de porter des problématiques communes.

## Donc ... elle est encore logique cette division ?

Oui certainement.

Parce qu'on ne peut pas tout faire et on ne peut pas tout savoir. Donc oui il faut avoir des spécialisations de métier.

Mais !

Ce n'est pas tout blanc tout noir. Nous ne sommes pas des automates. Même si on partage tous une même langue, on ne peut pas, et on n'a pas envie, d'échanger entre nous de façon procédurale. 

Une équipe ne doit pas se battre contre cette division mais doit en avoir la maîtrise. On ne peut pas ne pas voir ce qui se passe à côté. Des choix d'implémentations et des problèmes humains ont toujours un impact transverse.
Nos métiers sont en constante évolution, et donc il faut comprendre que les périmètres bougent.

Pour moi en tout cas, je pense que ce mouvement DevOps permet de mieux comprendre l'ensemble du cycle de vie d'une application, doit atténuer les effets néfastes de la division du travail et met en lumière les failles de nos organisations de travail.

On résume souvent le DevOps à la partie automatisation. C'est marrant comment le S(hare) de CALMS est mineur dans toutes ces transformations.

Et si c'était l'une des solutions ?

*PS: merci à mon [Vincent Cornet](https://www.linkedin.com/in/vincent-cornet-030ab387/)*
