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

 ### Envoie sur github pages méthode manuelle :
    1. Faite un `mkdocs build`
    2. Committez et poussez sur master si vos changements sont bon.
    3. Deployer sur Github Pages avec un `mkdocs gh-deploy`
  ### Envoie sur github pages méthode auto :
    1. make deploy m="message de commit"

