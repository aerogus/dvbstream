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

# correspondance mux/fréquence
declare -A FREQS=(
  ["r1"]=586000000
  ["r2"]=506000000
  ["r3"]=482000000
  ["r4"]=546000000
  ["r6"]=562000000
  ["r7"]=642000000
  ["r9"]=498000000
  ["r15"]=530000000
)

if [[ ! $(command -v dvblast) ]]; then
  echo "commande dvblast manquante";
  exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre card_mux manquant";
  echo "usage: ./dvblast.sh 0_r1"
  echo " 0 = le numéro de l'adaptateur"
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

if [[ ! -v "FREQS[$MUX]" ]]; then
  echo "mux $MUX inconnu"
  exit 1
fi

if [[ ! -f "${CONF_PATH}/$MUX.conf" ]]; then
  echo "fichier ${CONF_PATH}/$MUX.conf manquant";
  exit 1;
fi

# paramètres specifiques
EXTRA=""
if [[ $MUX == "r9" ]]; then
  EXTRA='-u --delsys DVBT2'
fi

dvblast --remote-socket "/tmp/dvblast-$CARD-$MUX.sock" --adapter "$CARD" --frequency "${FREQS[$MUX]}" --dvb-compliance --epg-passthrough --config-file "${CONF_PATH}/$MUX.conf" $EXTRA
