# dvbstream

Objectif: capter localement la télévision TNT avec une Raspberry Pi munie du ([tuner DVB-T2 TV HAT](https://www.raspberrypi.com/products/raspberry-pi-tv-hat/))

Test avec 2 outils: `dvblast` et `mumudvb`

## Multiplex

Dans les répertoires `conf/dvblast` et `conf/mumudvb` se trouvent la configuration des multiplex disponibles sur Paris avec une adresse de diffusion multicast pour chaque chaîne.

## Configuration réseau

On va d'abord restreindre la plage d'ip multicast à la boucle locale pour ne pas innonder le réseau si les switchs ne sont pas optimisés pour le multicast (ex: [IGMP Snooping](https://fr.wikipedia.org/wiki/IGMP_snooping)).

```bash
# ip route add 239.0.0.0/24 dev lo src 127.0.0.1
```

Pour vérifier les routes des cartes réseau :

```bash
$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         lan.home        0.0.0.0         UG    202    0        0 eth0
192.168.1.0     0.0.0.0         255.255.255.0   U     202    0        0 eth0
239.0.0.0       0.0.0.0         255.255.255.0   U     0      0        0 lo
```

ou

```bash
$ ip route show
default via 192.168.1.1 dev eth0 src 192.168.1.74 metric 202
192.168.1.0/24 dev eth0 proto dhcp scope link src 192.168.1.74 metric 202
239.0.0.0/24 dev lo scope link src 127.0.0.1
```

## Applications

### dvblast

`dvblast` a pour rôle de demultiplexer le signal de la carte tuner, et la diffuser en flux ip sur le réseau.

Installation

```bash
$ apt install dvblast
```

Vérification

```bash
$ dvblast --version
DVBlast 3.4 (release)
```

Notes avec `dvblast`:

- rtp par défaut
- `--ttl 0` ne marche pas.
- `/ifindex=1` ne marche pas
- `/ifaddr=127.0.0.1` ne marche pas
- BUG avec le multicast ? (flood le réseau)

### mumudvb

`mumudvb` est une évolution de `dvblast`

Installation

```bash
$ apt install mumudvb
```

Ajouter le nouvel utilisateur `_mumudvb` au groupe `video`

```bash
usermod -a -G video _mumudvb
```

Marche mieux que `dvblast` ? 

avec `autoconfiguration=full` ça marche mais l'ensemble des service_id flood le réseau ...
si pids est précisé et autoconfiguration à 0, ça ne floode plus ? mais maintenance des pids à faire ...

### ffmpeg

`ffmpeg` est le couteau suisse de l'audiovisuel. Il permet transcodage, analyse, génération de fichiers media. On l'utilisera pour lire un flux rtp/udp et l'afficher directement sur la sortie standard. En mode passe plat.

Installation

```bash
apt install ffmpeg
```

Vérification

```bash
$ ffmpeg 2>&1 | head -1
ffmpeg version 4.3.4-0+deb11u1+rpt3 Copyright (c) 2000-2021 the FFmpeg developers
```

## Streamer un multiplex

Dans le répertoire `systemd` sont fournis 2 fichiers de services. Copions les au bon endroit :

```bash
# cp systemd/dvblast@.service /etc/systemd/system
# cp systemd/mumudvb@.service /etc/systemd/system
# systemctl daemon-reload
```

Note: le chemin des apps et des logs peut être à adapter.

Pour commencer le stream d'un multiplex, utiliser l'une des commandes exemples suivantes :

```bash
# systemctl start mumudvb@r1
# systemctl enable --now dvblast@r15
```

Lien: [Documentation sur Systemd](https://www.linuxtricks.fr/wiki/systemd-0-table-des-matieres-des-articles)

## Monitoring réseau

On peut contrôler qu'un multiplex est bien streamé sur la boucle locale avec `netstat` :

```bash
$ netstat -nu
Active Internet connections (w/o servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
udp        0      0 127.0.0.1:41809         239.0.0.14:1234         ESTABLISHED
udp        0      0 127.0.0.1:52565         239.0.0.3:1234          ESTABLISHED
udp        0      0 127.0.0.1:39327         239.0.0.2:1234          ESTABLISHED
udp        0      0 127.0.0.1:45600         239.0.0.27:1234         ESTABLISHED
udp        0      0 127.0.0.1:37410         239.0.0.30:1234         ESTABLISHED
```

D'autre part, l'outil `iptraf` permet d'avoir une vue d'ensemble du trafic réseau dans une interface texte.

```bash
$ apt install iptraf
```

## Enregistrer localement un flux

avec `ffmpeg`

```bash
ffmpeg -i rtp://239.0.0.2:1234 -c copy rec.ts
```

avec `multicat` (dépendance `bitstream`, se compile facilement)

- https://github.com/videolan/multicat
- https://github.com/videolan/bitstream

```bash
multicat -X @239.0.0.2:1234 /dev/null 2>/dev/null > rec.ts
```

- On demande à ce que le flux ts passe par la sortie standard `-X`
- On précise le groupe multicast auquel on veut s'abonner `@239.0.0.2:1234`
- On ne veut pas d'écriture du flux sur disque `/dev/null`
- On cache la sortie d'erreur `2>/dev/null`
- On pipe ou on redirige le flux d'ailleurs `> rec.ts`
- Si c'est un flux udp (pas rtp), ajouter `-u`

## Ressources

- https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
- https://www.hospitableit.com/howto/streaming-dvb-t-over-an-ip-network-using-mumudvb-on-a-raspberry-pi-3/
- https://chiliproject.tetaneutral.net/projects/tetaneutral/wiki/Streaming_de_cha%C3%AEnes_TNT_sur_un_r%C3%A9seau_local
- [Tall Paul Tech](https://www.youtube.com/@TallPaulTech)