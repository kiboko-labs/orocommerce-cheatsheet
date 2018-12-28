### Scénario : 

> Je veux installer RabbitMQ sur mon poste 

### Comment installer RabbitMQ

> Ouvrez un terminal:

```bash
brew install rabbitmq
```
> Les excutables sont installés ici : /usr/local/sbin 

```bash
export PATH=$PATH:/usr/local/sbin
```
 > Pour le lancer
 
```bash
brew services start rabbitmq
```
 > Ou
  
```bash
rabbitmq-server
```

> Le panel d'administatrion est disponible par défault a cette adresse

[http://localhost:15672](http://localhost:15672)

> Pour Couper / Relancer le server
```bash
rabbitmqctl stop_app
rabbitmqctl start_app
```
> On a besoin de ce plugin, qui n'est pas installé par défault :

rabbitmq_del ayed_message _exchange

> On le télecharge et on le met au bon endroit

```bash
wget https://dl.bintray.com/rabbitmq/community-plugins/3.6.x/rabbitmq_delayed_message_exchange/rabbitmq_delayed_message_exchange-20171215-3.6.x.zip && unzip rabbitmq_delayed_message_exchange-20171215-3.6.x.zip -d {L'endroit ou est installer RabbitMQ}/plugins && rm rabbitmq_delayed_message_exchange-20171215-3.6.x.zip
```
> Pour savoir ou le mettre il faut trouver ou est installé rabbitmq :

```bash
 brew info rabbitmq
```
> Vous aurez un truc semblable à ça :

```bash
rabbitmq: stable 3.7.9
Messaging broker
https://www.rabbitmq.com
/usr/local/Cellar/rabbitmq/3.7.9 (235 files, 13.5MB) *
  Built from source on 2018-12-28 at 09:46:16
From: https://github.com/Homebrew/homebrew-core/blob/master/Formula/rabbitmq.rb
==> Dependencies
Required: erlang ✔
==> Caveats
Management Plugin enabled by default at http://localhost:15672

Bash completion has been installed to:
  /usr/local/etc/bash_completion.d

To have launchd start rabbitmq now and restart at login:
  brew services start rabbitmq
Or, if you don't want/need a background service you can just run:
  rabbitmq-server
==> Analytics
install: 9,589 (30 days), 33,961 (90 days), 139,298 (365 days)
install_on_request: 9,084 (30 days), 31,408 (90 days), 123,830 (365 days)
build_error: 0 (30 days)
```
> Il est donc visiblement installé ici :

/usr/local/Cellar/rabbitmq/3.7.9

> Ducoup ça donne ça :

```bash
wget https://dl.bintray.com/rabbitmq/community-plugins/3.6.x/rabbitmq_delayed_message_exchange/rabbitmq_delayed_message_exchange-20171215-3.6.x.zip && unzip rabbitmq_delayed_message_exchange-20171215-3.6.x.zip -d /usr/local/Cellar/rabbitmq/3.7.9/plugins && rm rabbitmq_delayed_message_exchange-20171215-3.6.x.zip
```
> Le plugin est installé, il faut maintenant l'activer  :

```bash
rabbitmq-plugins enable --offline rabbitmq_delayed_message_exchange
```
> Les commandes qui peuvent aider :

| Fonction             | Commands                                         |
| -------------------- |:------------------------------------------------:| 
| Activer un plugin    | ```bash rabbitmq-plugins enable nomDuPlugin ```  |
| Désactiver un plugin | ```bash rabbitmq-plugins disable nomDuPlugin ``` |   
| Lister les plugins   | ```bash rabbitmq-plugins list -e ```             |   

> Un fois que tout est bon on passe à la config :

```yml
# app/config/config.yml

oro_message_queue:
    transport:
        default: '%message_queue_transport%'
        '%message_queue_transport%': '%message_queue_transport_config%'
    client: ~
```
> Les paremètres correspondants :

```yml
# app/config/parameters.yml
    message_queue_transport: 'amqp'
    message_queue_transport_config: { host: 'localhost', port: '5672', user: 'guest', password: 'guest', vhost: '/' 
```
> On efface le cache et tout devrait fonctionner 
