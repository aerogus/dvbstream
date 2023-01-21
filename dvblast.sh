#!/usr/bin/env bash

##
# Lancement de diffusion d'un multiplex avec dvblast
#
# @param string $1 nom du multplex
#
# source: https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
##

ABS_PATH="$( cd "$(dirname "$0")" || return; pwd -P )"
CONF_PATH="${ABS_PATH}/conf/dvblast"
ALLOWED_MUXES=(r1 r2 r3 r4 r6 r7 r15 hevc)

if [[ ! $(command -v dvblast) ]]; then
  echo "commande dvblast manquante";
  echo "apt install dvblast"
  exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre mux manquant";
  echo "usage: ./dvblast.sh r1"
  exit 1;
fi

if ! echo "${ALLOWED_MUXES[@]}" | grep -q "$1"; then
  echo "mux $1 non autorisé"
  echo "muxes autorisés: "
  echo "${ALLOWED_MUXES[@]}"
  exit 1;
fi

if [[ ! -f "${CONF_PATH}/$1.conf" ]]; then
  echo "fichier ${CONF_PATH}/$1.conf manquant";
  exit 1;
fi

case $1 in
    r1) dvblast -f 586000000 -c "${CONF_PATH}/$1.conf" ;;
    r2) dvblast -f 506000000 -c "${CONF_PATH}/$1.conf" ;;
    r3) dvblast -f 482000000 -c "${CONF_PATH}/$1.conf" ;;
    r4) dvblast -f 546000000 -c "${CONF_PATH}/$1.conf" ;;
    r6) dvblast -f 562000000 -c "${CONF_PATH}/$1.conf" ;;
    r7) dvblast -f 642000000 -c "${CONF_PATH}/$1.conf" ;;
   r15) dvblast -f 530000000 -c "${CONF_PATH}/$1.conf" ;;
  hevc) dvblast -f 498000000 -c "${CONF_PATH}/$1.conf" -u --delsys DVBT2 ;;
     *) echo "mux inconnu" ;;
esac
