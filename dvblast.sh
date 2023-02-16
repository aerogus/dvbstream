#!/usr/bin/env bash

##
# Lancement de diffusion d'un multiplex avec dvblast
#
# @param string $1 CARD_MUX
#
# source: https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
##

ABS_PATH="$( cd "$(dirname "$0")" || return; pwd -P )"
CONF_PATH="${ABS_PATH}/conf/dvblast"
ALLOWED_CARDS=(0 1 2 3 4 5 6 7)
ALLOWED_MUXES=(r1 r2 r3 r4 r6 r7 r15 hevc)

if [[ ! $(command -v dvblast) ]]; then
  echo "commande dvblast manquante";
  echo "apt install dvblast"
  exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre card_mux manquant";
  echo "usage: ./dvblast.sh 0_r1"
  echo " 0 = le numéro de l'adaptateur sdr"
  echo "r1 = le nom du multiplex"
  exit 1;
fi

CARD=${1:0:1}
MUX=${1#*_}

if ! echo "${ALLOWED_CARDS[@]}" | grep -q "$CARD"; then
  echo "card $CARD non autorisé"
  echo "cards autorisées: "
  echo "${ALLOWED_CARDS[@]}"
  exit 1;
fi

if ! echo "${ALLOWED_MUXES[@]}" | grep -q "$MUX"; then
  echo "mux $MUX non autorisé"
  echo "muxes autorisés: "
  echo "${ALLOWED_MUXES[@]}"
  exit 1;
fi

if [[ ! -f "${CONF_PATH}/$MUX.conf" ]]; then
  echo "fichier ${CONF_PATH}/$MUX.conf manquant";
  exit 1;
fi

case $MUX in
    r1) dvblast --adapter "$CARD" --frequency 586000000 --config-file "${CONF_PATH}/$MUX.conf" ;;
    r2) dvblast --adapter "$CARD" --frequency 506000000 --config-file "${CONF_PATH}/$MUX.conf" ;;
    r3) dvblast --adapter "$CARD" --frequency 482000000 --config-file "${CONF_PATH}/$MUX.conf" ;;
    r4) dvblast --adapter "$CARD" --frequency 546000000 --config-file "${CONF_PATH}/$MUX.conf" ;;
    r6) dvblast --adapter "$CARD" --frequency 562000000 --config-file "${CONF_PATH}/$MUX.conf" ;;
    r7) dvblast --adapter "$CARD" --frequency 642000000 --config-file "${CONF_PATH}/$MUX.conf" ;;
   r15) dvblast --adapter "$CARD" --frequency 530000000 --config-file "${CONF_PATH}/$MUX.conf" ;;
  hevc) dvblast --adapter "$CARD" --frequency 498000000 --config-file "${CONF_PATH}/$MUX.conf" -u --delsys DVBT2 ;;
     *) echo "mux inconnu" ;;
esac
