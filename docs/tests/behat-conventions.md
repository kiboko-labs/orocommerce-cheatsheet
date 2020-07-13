## Conventions

Utilisez le mapping de formulaire au lieu de sélecteurs dans vos scénarios pour les garder clairs et compréhensibles pour les personnes du monde technique et non technique.

### Example 

Ne pas:

```
I fill in "oro_workflow_definition_form[label]" with "User Workflow Test"
I fill in "oro_workflow_definition_form[related_entity]" with "User"
```

Mais plutot :

```
 And I fill "Workflow Edit Form" with:
   | Name                  | User Workflow Test |
   | Related Entity        | User               |
```

avec la description des éléments indépendament :

```
 Workflow Edit Form:
   selector: 'form[name="oro_workflow_definition_form"]'
   class: Oro\Bundle\TestFrameworkBundle\Behat\Element\Form
   options:
     mapping:
       Name: 'oro_workflow_definition_form[label]'
       Related Entity: 'oro_workflow_definition_form[related_entity]'
```

Utilisez des menu et des liens pour obtenir les bonnes pages au lieu de l'URL de la page directe

Faire :

```
And I open User Index page
```

Et non pas :

```
And I go to "/users"
```

Évitez la redondance des scénarios (par exemple, en répétant la même séquence d'étapes, comme la connexion, dans plusieurs scénarios).

Couvrez la fonctionnalité avec les scénarios séquentiels où chaque scénario suivant réutilise les résultats (les états et les données) préparés par leurs prédécesseurs. Cette méthode a été choisie en raison des avantages suivants:

- Exécution de scénario plus rapide grâce à la session utilisateur partagée et à la préparation intelligente des données.
L'action de connexion dans le scénario initial ouvre la session qui est réutilisable par les scénarios suivants.
Les scénarios préliminaires (par exemple, créer) préparent des données pour les scénarios suivants (par exemple, supprimer).
- L'isolation au niveau des fonctionnalités augmente la vitesse d'exécution, en particulier dans les environnements de test lents.
- Actions de développement de routine minimisées (par exemple, vous n'avez pas à charger les fixtures pour chaque scénario; au lieu de cela, vous réutilisez les résultats disponibles des scénarios précédents).
- Gestion aisée des états d'application difficiles à émuler uniquement avec des fixtures (par exemple, lors de l'ajout de nouveaux champs d'entité dans l'interface utilisateur).


En couplant les scénarios, la facilité de débogage et de localisation des bogues est réduite. Il est difficile de déboguer les fonctionnalités de l'interface utilisateur
et les scénarios qui se produisent après plusieurs scénarios préliminaires. Plus la ligne est longue, plus il est difficile d'isoler le problème.

- **Utiliser des fixtures yml sémantiques**

Utilisez uniquement les entités qui se trouvent dans le bundle que vous testez. Toutes les autres entités doivent être incluses via une importation. Voir les [Fixtures Alice](https://github.com/nelmio/alice) pour plus d'informations.

- **Nommer les éléments dans le style camelCase sans espaces**

Vous pouvez toujours vous y référer en utilisant le style camelCase avec des espaces dans les scénarios behat.
Par exemple, un élément nommé OroProductForm peut être mentionné dans l'étape du scénario comme «Oro Product From»:

- **Use Scenario: Feature Background instead of the Background step**