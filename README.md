# dvbstream

Projet: capter localement la télévision TNT avec une Raspberry Pi munie du ([tuner DVB-T2 TV HAT](https://www.raspberrypi.com/products/raspberry-pi-tv-hat/))

Test avec 2 outils: `dvblast` et `mumudvb`

## Multiplex

Dans les répertoires `conf/dvblast` et `conf/mumudvb` se trouvent la configuration des multiplex disponibles sur Paris avec leur adresse de diffusion multicast.

## Monitoring réseau

L'outil `iptraf` permet d'avoir une vue d'ensemble du trafic réseau. Utile pour débuguer le multicast :)

```bash
$ apt install iptraf
```

## Configuration réseau

On va restreindre la plage d'ip multicast à la boucle locale pour ne pas innonder le réseau si les switchs sont mal configurés. À faire avant de jouer avec le multicast.

```bash
$ ip route add 239.0.0.0/24 dev lo src 127.0.0.1
```

Pour vérifier les routes

```bash
$ ip route show
default via 192.168.1.1 dev eth0 src 192.168.1.74 metric 202
192.168.1.0/24 dev eth0 proto dhcp scope link src 192.168.1.74 metric 202
239.0.0.0/24 dev lo scope link src 127.0.0.1
```

## Applicatifs

### dvblast

On aura besoin du programme `dvblast` qui a pour rôle de demultiplexer le signal de la carte tuner, et la diffuser en flux ip sur le réseau.

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

## Enregistrer localement

avec ffmpeg

```bash
ffmpeg -i rtp://239.0.0.83:1234 -c copy rec.ts
```

avec multicat (dépendance bitstram, se compile facilement)

- https://github.com/videolan/multicat
- https://github.com/videolan/bitstream

```bash
multicat 239.0.0.83@1234 -X /dev/null > rec.ts
```

## Divers

Ça stream tous les flux du fichier, même si aucun abonné au groupe multicast

à > 50000 kbps le raspberry pi 3+ fait des pertes de paquets sur le réseau

## Ressources

- https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
- https://www.hospitableit.com/howto/streaming-dvb-t-over-an-ip-network-using-mumudvb-on-a-raspberry-pi-3/
- https://chiliproject.tetaneutral.net/projects/tetaneutral/wiki/Streaming_de_cha%C3%AEnes_TNT_sur_un_r%C3%A9seau_local
