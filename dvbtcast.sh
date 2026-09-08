#!/usr/bin/env bash

##
# Lancement de diffusion d'un multiplex DVBT/2 avec dvblast
#
# @param string $1 ADAPTER_ZONE/MUX
#
# source: https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
##

ABS_PATH="$( cd "$(dirname "$0")" || return; pwd -P )"
CONF_PATH="${ABS_PATH}/conf/dvbt"

# correspondance mux / paramètres
declare -A PARAMS=(
  ["paris/r1"]="--frequency 586000000 --modulation DVBT"
  ["paris/r2"]="--frequency 506000000 --modulation DVBT"
  ["paris/r4"]="--frequency 546000000 --modulation DVBT"
  ["paris/r6"]="--frequency 562000000 --modulation DVBT"
  ["paris/r7"]="--frequency 642000000 --modulation DVBT"
  ["paris/r9"]="--frequency 498000000 --modulation DVBT2 --budget-mode"
  ["paris/r15"]="--frequency 530000000 --modulation DVBT"
)

if [[ ! $(command -v dvblast) ]]; then
  echo "commande dvblast manquante";
  #exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre adapter_zone/mux manquant";
  echo "usage: ./dvbtcast.sh 00_paris/r1"
  echo " 0 = le numéro de l'adaptateur"
  echo " 0 = le numéro du frontend"
  echo " paris/r1 = zone / nom du multiplex"
  exit 1;
fi

ADAPTER=${1:0:1}
FRONTEND=${1:1:1}
MUX=${1#*_}

if [[ ! -f "${CONF_PATH}/$MUX.conf" ]]; then
  echo "fichier ${CONF_PATH}/$MUX.conf manquant";
  exit 1;
fi

dvblast --remote-socket "/tmp/dvbtcast-$ADAPTER-$FRONTEND.sock" --adapter "$ADAPTER" --frontend-number "$FRONTEND" ${PARAMS[$MUX]} --any-type --dvb-compliance --epg-passthrough --config-file "${CONF_PATH}/$MUX.conf"
