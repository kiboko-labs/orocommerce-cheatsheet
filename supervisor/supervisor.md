Supervisor avec Oro
========================

## Documentation

http://supervisord.org/running.html


## Usage

* **1** Créer un fichier de configuration dans `~/supervisor/cond.d/mon_apppli.conf`

Oro fournit un modèle de fichier de configuration : https://oroinc.com/b2b-ecommerce/doc/current/install-upgrade/installation-quick-start-dev/commerce-crm#configure-and-run-required-background-processes

```
[program:oro_web_socket]
command=php ./bin/console gos:websocket:server --env=prod
numprocs=1
autostart=true
autorestart=true
directory=/usr/share/nginx/html/oroapp
user=nginx
redirect_stderr=true

[program:oro_message_consumer]
command=php ./bin/console oro:message-queue:consume --env=prod
process_name=%(program_name)s_%(process_num)02d
numprocs=5
autostart=true
autorestart=true
directory=/usr/share/nginx/html/oroapp
user=nginx
redirect_stderr=true
```

Changer les repertoires et le User dans le fichier .conf

* **2** Lancer `supervisorctl update` pour qu'il recharge les conf.
* **3** Lancer `supervisorctl status` pour voir ce qui tournent
