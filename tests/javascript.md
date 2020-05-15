# Test unitaire Javascript
## Installation
Les logiciel suivant sont nécessaire pour exécuter les tests JS :

- Node.js (Moteur JavaScript)
- Karma (Lanceur de test Javascript)
- Jasmine 3.5 (Framework BDD)

### NOTE
Pour obtenir des instructions sur la façon d’installer Node.js, accédez au [site officiel](https://nodejs.org/en/download/).

Une fois Node installé, installez plusieurs modules en utilisant [Node Packaged Modules](https://npmjs.org/) en exécutant la commande suivante à partir du dossier racine de votre application

`npm install --prefix=vendor/oro/platform/build`

Où le paramètre –prefix spécifie le chemin relatif au répertoire platform/build.

##Configuration

La configuration pour lancer les tests et dans build/karma.config.js.dist.

### Note 
Voir plus d’informations dans la [documentation officielle de Karma](http://karma-runner.github.io/4.0/config/configuration-file.html).

Il peut être utile de créer une configuration séparé en copiant ./vendor/oro/platform/build/karma.config.js.dist vers ./vendor/oro/platform/build/karma.config.js et le modifier.

## Lancement

Pour exécuter des tests, appelez la commande suivante :

`./vendor/oro/platform/build/node_modules/.bin/karma start ./vendor/oro/platform/build/karma.conf.js.dist --single-run`

N’oubliez pas de changer le chemin vers le répertoire de plateform/build, s’il est différent dans votre application.
`
Pour exécuter une testsuite avec une configuration personnalisée, vous pouvez utiliser les paramètres de ligne de commande qui écrasent les paramètres dans le fichier de configuration.

Quelques options personnalisées ont été ajoutées pour préparer la configuration de Karma :

–mask _string_ file masque pour les fichiers Spec.Par défault c'est `vendor/oro/**/Tests/JS/**/*Spec.js ` qui correspond à tous les fichiers Spec du projet dans le répertoire vendor oro.
–spec _string_ chemin vers un fichier de Spec spécifique, s’il est passé, alors la recherche par masque est ignorée et le test est exécuté fichier Spec unique.
–skip-indexing _boolean_ permet de sauter la phase de la collecte des fichiers de spécifications et de réutiliser la collection des des lancements précédent.
–theme _string_ le nom du thème est utilisé pour générer la configuration de webpack pour certains thèmes. Par défaut, c’est `admin.oro.

Les extensions suivantes peuvent être utiles si vous utilisez Phpstorm:

Le plugin [Karma](https://plugins.jetbrains.com/plugin/7287-karma) aide à exécuter des testsuite à partir de l’IDE et voir les résultats facilement.
[ddescriber](https://plugins.jetbrains.com/plugin/7233-ddescriber-for-jasmine) pour jasmin aide à désactiver ou à sauter certains tests de la testsuite rapidement

## Rédaction

### NOTE

Voir la [documentation de Jasmine 3.5](https://jasmine.github.io/api/3.5/global) pour de plus amples renseignements sur la rédaction de tests avec Jasmine 3.5.

L’exemple ci-dessous illustre les spécifications du module oroui/js/mediator :

````javascript
import mediator from 'oroui/js/mediator';
import Backbone from 'backbone';

describe('oroui/js/mediator', function () {
    it("compare mediator to Backbone.Events", function() {
        expect(mediator).toEqual(Backbone.Events);
        expect(mediator).not.toBe(Backbone.Events);
    });
});
````

## karma-jsmodule-exposure

Cette approche permet de tester l’API publique d’un module.
Mais vous pouvez utilisez le plugin karma-jsmodule-exposure pour injecter du code exposant à l’intérieur
du js-module et fournit l’API pour manipuler les variables internes :

````javascript
 import someModule from 'some/module';
 import jsmoduleExposure from 'jsmodule-exposure';

 // get exposure instance for tested module
 var exposure = jsmoduleExposure.disclose('some/module');

 describe('some/module', function () {
     var foo;

     beforeEach(function () {
         // create mock object with stub method 'do'
         foo = jasmine.createSpyObj('foo', ['do']);
         // before each test, pass it off instead of original
         exposure.substitute('foo').by(foo);
     });

     afterEach(function () {
         // after each test restore original value of foo
         exposure.recover('foo');
     });

     it('check doSomething() method', function() {
         someModule.doSomething();

         // stub method of mock object has been called
         expect(foo.do).toHaveBeenCalled();
     });
 });
````

## Jasmine-jQuery

[Jasmine-jQuery](https://github.com/velesin/jasmine-jquery) étend la fonctionnalité de base de Jasmine, en particulier :

- ajoute un certain nombre de matchers utiles, et permet de vérifier l’état d’une instance jQuery facilement
- applique des fixtures HTML avant chaque test et retourne le document après les tests
- fournit un moyen de charger les fixtures HTML et JSON nécessaires pour un test

Cependant, parce que Jasmine-jQuery nécessite le chemin complet vers une ressource fixture, il est préférable d’utiliser import pour charger les fixtures par un chemin connexe.

````javascript
   import 'jasmine-jquery';
   import $ from 'jquery';
   import html from 'text-loader!./Fixture/markup.html';

   describe('some/module', function () {
       beforeEach(function () {
           // appends loaded html to document's body,
           // after test rolls back it automatically
           window.setFixtures(html);
       });

       it('checks the markup of a page', function () {
           expect($('li')).toHaveLength(5);
       });
   });
````
