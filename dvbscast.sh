#!/usr/bin/env bash

##
# Lancement de diffusion d'un multiplex DVBS/2 avec dvblast
#
# @param string $1 ADAPTER_ZONE-MUX
#
# source: https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
##

ABS_PATH="$( cd "$(dirname "$0")" || return; pwd -P )"
CONF_PATH="${ABS_PATH}/conf/dvbs"

# correspondance mux / paramètres
declare -A PARAMS=(
  ["eutelsat5wb-11096V"]="--frequency 11096000 --delsys DVBS2 --modulation psk_8 --voltage 13 --symbol-rate 29950000"
  ["eutelsat5wb-11455H"]="--frequency 11455000 --delsys DVBS2 --modulation qpsk  --voltage 18 --symbol-rate  2550000"
  ["eutelsat5wb-11461H"]="--frequency 11461000 --delsys DVBS2 --modulation qpsk  --voltage 18 --symbol-rate  5780000"
  ["eutelsat5wb-11471V"]="--frequency 11471000 --delsys DVBS2 --modulation psk_8 --voltage 13 --symbol-rate 29950000"
  ["eutelsat5wb-11472H"]="--frequency 11472000 --delsys DVBS2 --modulation psk_8 --voltage 18 --symbol-rate  9900000"
  ["eutelsat5wb-11480H"]="--frequency 11480000 --delsys DVBS2 --modulation qpsk  --voltage 18 --symbol-rate  3165000"
  ["eutelsat5wb-11555V"]="--frequency 11555000 --delsys DVBS2 --modulation psk_8 --voltage 13 --symbol-rate 29950000"
  ["eutelsat5wb-11679V"]="--frequency 11679000 --delsys DVBS2 --modulation psk_8 --voltage 13 --symbol-rate 29950000"
  ["eutelsat5wb-12648V"]="--frequency 12648000 --delsys DVBS2 --modulation psk_8 --voltage 13 --symbol-rate 29500000"
  ["eutelsat5wb-12732V"]="--frequency 12732000 --delsys DVBS2 --modulation psk_8 --voltage 13 --symbol-rate 29500000"
)

if [[ ! $(command -v dvblast) ]]; then
  echo "commande dvblast manquante";
  exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre adapter_zone-mux manquant";
  echo "usage: ./dvblast.sh 11_eutelsat5WB-11471V"
  echo " 1 = le numéro de l'adaptateur"
  echo " 1 = le numéro du frontend"
  echo "eutelsat5WB-11471V = satellite-multiplex"
  exit 1;
fi

ADAPTER=${1:0:1}
FRONTEND=${1:1:1}
MUX=${1#*_}

if [[ ! -f "${CONF_PATH}/$MUX.conf" ]]; then
  echo "fichier ${CONF_PATH}/$MUX.conf manquant";
  exit 1;
fi

dvblast --remote-socket "/tmp/dvbscast-$ADAPTER-$FRONTEND.sock" --adapter "$ADAPTER" --frontend "$FRONTEND" ${PARAMS[$MUX]} --any-type --dvb-compliance --epg-passthrough --config-file "${CONF_PATH}/$MUX.conf"
