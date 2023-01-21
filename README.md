# captation-tnt

Projet: capter localement la TNT avec un Raspberry Pi muni d'un tuner DVB-T + DVB-T2 (Pi-hat)

## Multiplex

Dans le répertoire `mux` se trouvent la configuration des multiplex disponibles sur Paris avec leur adresse de diffusion multicast.

## Monitoring réseau

L'outil `iptraf` permet d'avoir une vue d'ensemble du trafic réseau. Utile pour débuguer le multicast :)

```bash
$ apt install iptraf
```

## Configuration réseau

On va restreindre la plage d'ip multicast à la boucle locale pour ne pas innonder le réseau si les switchs sont mal configurés. À faire avant de jouer avec le multicast.

```bash
$ ip route add 239.255.0.0/24 dev lo src 127.0.0.1
```

Pour vérifier les routes

```bash
$ ip route show
default via 192.168.1.1 dev eth0 src 192.168.1.74 metric 202
192.168.1.0/24 dev eth0 proto dhcp scope link src 192.168.1.74 metric 202
239.255.0.0/24 dev lo scope link src 127.0.0.1
```

## Applicatifs

### mumudvb

Installation

```bash
$ apt install mumudvb
```

Marche mieux que `dvblast` ? 
A finir de convertir les .conf

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

- `--ttl 0` ne marche pas.
- `/ifindex=1` ne marche pas
- `/ifaddr=127.0.0.1` ne marche pas
- BUG avec le multicast

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

### captation.php

Outil dédié de lecture sur l'entrée standard et nommage + découpe à l'heure du fichier

Installation des dépendances

```bash
apt install php8.0-cli php8.0-xml php8.0-curl php8.0-mbstring
+ composer
```

enregistrer localement à partir du raspberry

```
ffmpeg -i rtp://239.255.0.83:1234 -c copy /mnt/magnetoscope/hevc-83c.ts
```

## Divers

Ça stream tous les flux du fichier, même si aucun abonné au groupe multicast

à > 50000 kbps le raspberry pi 3+ fait des pertes de paquets sur le réseau

## Ressources

- https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
- https://www.hospitableit.com/howto/streaming-dvb-t-over-an-ip-network-using-mumudvb-on-a-raspberry-pi-3/
- https://chiliproject.tetaneutral.net/projects/tetaneutral/wiki/Streaming_de_cha%C3%AEnes_TNT_sur_un_r%C3%A9seau_local

