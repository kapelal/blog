+++
title = "LLM is a genius — Be careful what you wish for"
date = 2025-07-23T14:01:24+02:00
meta_img = "/img/genius.png"
tags = ["AI"]
description = "LLM is a genius — Be careful what you wish for"
slug = "LLM is a genius — Be careful what you wish for"
+++

[Who is LLM?](https://martinfowler.com/articles/who-is-llm.html)

Trop content que Martin Fowler ait écrit ce genre d'article. J'adhère énormément à l'image du génie.

Quand je formule un prompt je sais toujours que j'ouvre un éventail d'interprétations possibles, comme un entonnoir inversé. Et j'aime bien imaginer l'élargissement de l'entonnoir comme des couches qui se superposent et qui permettent d'amplifier l'interprétation. 

Je crois que l'exercice de l'entonnoir inversé est mal compris par une majorité d'entre nous. Ceux qui ne comprennent pas disent "Regarde la réponse est nulle" d'autres "ça montre qu'il manque de contexte".

Quand je cherche une réponse, mes prompts sont sous cette forme :

- Donner un rôle clair
- Préciser à qui la réponse est destinée et pourquoi (intention)
- Donnez des exemples 
- Préciser le format de réponse en indiquant les modalités pour chaque étape de la réponse (un plan)
- **Bonus**: Utiliser des balises XML, pour découper le prompt (précision)
- **Bonus**: Spliter les réponses attendues en mettant les outputs des prompts précédent dans les prompts suivants (moins de chance de s'égarer)

Moi je vois l'entonnoir inversé comme un outil heuristique. Une méthode qui permet d'explorer une idée et de faire des découvertes. C'est le travail d'un pisteur. Comprendre l'intention, suivre des pistes, baliser et trouver les culs de sac.

Jouer avec les LLM non pas comme un outil magique, mais comme un outil opérable : Ne pas nier le côté hallucinatoire mais le rendre utilisable.

Exemple de prompt: J'écris un futur article sur pourquoi je trouve que l'Agile ne permet pas ou peu l'innovation

"""
Tu es un CTO expérimenté, doté d'une compréhension approfondie des méthodologies Agile. Tu es ouvert à une remise en question argumentée et tu écoutes attentivement une critique spécifique :

"La méthodologie Agile, de par son cadre (cycles de vie rigides, rythme soutenu, rituels fixes), ne favorise pas, voire entrave, l'innovation au sein des équipes de développement."

Mon objectif est que tu analyses et débattes en profondeur sur le contenu de mon **draft** qui expose cette critique.

Notre interaction sera un dialogue itératif:
1.  **Chaque tour, tu me poseras une seule question à la fois.**
2.  Tes questions devront viser à :
    *   Éclaircir des passages ou des concepts qui te semblent flous. Me pousser à développer des aspects moins détaillés.
    *   Explorer les motivations ou les exemples concrets.
    *   Sonder les implications pratiques ou les conséquences des points soulevés.
    *   Comprendre les nuances de ma pensée et les limites éventuelles de ma critique.
3.  J'y répondrai, et j'attendrai ensuite que tu me poses une nouvelle question. Ce pourra être une question d'approfondissement sur ma dernière réponse, ou une nouvelle question.
4.  Le but est de construire une compréhension mutuelle précise et détaillée de la critique, en explorant toutes ses facettes.

<draft>
... 
</draft>
"""

Générallement mes prompts que j'ai utilisé pour cohortes, pour analyser des témoignages, ont suivi ce patern: Entonnoir inversé comme un input d'un autre entonnoir mais celui là dans le bon sens.

![image](/img/entonnoir.png)


Inspiration:

- https://martinfowler.com/articles/who-is-llm.html
- https://blog.agent.ai/avoiding-the-3-wishes-problem-in-agentic-ai-design

