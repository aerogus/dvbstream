#!/usr/bin/env bash

##
# Lancement de diffusion d'un multiplex avec mumudvb
#
# @param string $1 nom du multplex
#
# source: https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
##

ABS_PATH="$( cd "$(dirname "$0")" || return; pwd -P )"
CONF_PATH="${ABS_PATH}/conf/mumudvb"
ALLOWED_CARDS=(0 1 2 3 4 5 6 7)
ALLOWED_MUXES=(r1 r2 r3 r4 r6 r7 r9 r15 hevc)

if [[ ! $(command -v mumudvb) ]]; then
  echo "commande mumudvb manquante";
  echo "apt install mumudvb"
  exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre card_mux manquant";
  echo "usage: ./mumudvb.sh 0_r1"
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

mumudvb --card "$CARD" --debug --config "${CONF_PATH}/$MUX.conf"
