Chaque fonctionnalité peut interagir avec l'application et effectuer des opérations CRUD. Par conséquent, la base de données peut être modifiée.
Pour éviter les collisions de données, les fonctionnalités sont isolées: la base de données et les répertoires de cache sont vidés avant d'exécuter les tests de fonctionnalités;
ils sont restaurés une fois l'exécution des tests de fonctionnalités terminée.

Chaque isolateur doit implémenter l'interface `Oro\Bundle\TestFrameworkBundle\Behat\Isolation\IsolatorInterface` et le tag `oro_behat.isolator avec de la priorité.

#### Désactiver l'isolation des fonctionnalités

Vous pouvez désactiver l'isolation des fonctionnalités en ajoutant l'option `-skip-isolators=database,cache` à la commande console behat.
Dans ce cas, la combinaison des tests de fonctionnalité peut s'exécuter beaucoup plus rapidement, mais la logique de test doit se soucier de la cohérence de la base de données et du cache.