# dvbstream

Streamer la TV localement

+ d'infos:
https://aerogus.net/posts/diffuser-tele-radio-reseau-local/

outil monitoring réseau

```
sudo apt install iptraf
iptraf
```

restreindre la plage d'ip multicast à la boucle locale (à faire avant de lancer dvblast)

```
ip route add 239.255.0.0/24 dev lo src 127.0.0.1
```

avec `dvblast`:

- `--ttl 0` ne marche pas.
- `/ifindex=1` ne marche pas
- `/ifaddr=127.0.0.1` ne marche pas

enregistrer localement à partir du raspberry

```
ffmpeg -i rtp://239.255.0.83:1234 -c copy /mnt/magnetoscope/hevc-83c.ts
```

ça stream tous les flux du fichier, même si aucun abonné au groupe multicast

à > 50000 kbps le raspberry pi 3+ fait des pertes de paquets sur le réseau

