[orocommerce-cheatsheet](https://kiboko-labs.github.io/orocommerce-cheatsheet/)

## Installation :

[Installation](https://www.mkdocs.org/#installation)

- Pour modifier cette doc , vous devez avoir Python en version 3.5 minimal et pip pour la version de python 3

**!!! WARNING !!!** Sur mac on utilise les commandes python3 et pip3, si vous avez des soucis pour utiliser python3 sur mac google est votre amie.

- Vous devez installer mkdocs avec pip/pip3 

- cloner ce projet `git clone git@github.com:kiboko-labs/orocommerce-cheatsheet.git`

- `cd orocommerce-cheatsheet`

- `mkdocs serve` pour lancer la doc en local http://127.0.0.1:8010/ par défault

## Pour ajouter une page :

1. Rajouter un fichier markdown dans le dossier docs
2. Ajouter un lien dans le fichier mkdocs.yml
3. Faite un `mkdocs build`
4. Si vos changements sont bon, mettez vous sur la branche master et faite un `make deploy m='message de commit'`.
5. Attendez la maj sur github pages qui est assez lente
