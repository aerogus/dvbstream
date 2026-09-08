#!/usr/bin/env bash

##
# Lancement de diffusion d'un multiplex DAB+ avec dablast
#
# @param string $1 ADAPTER_ZONE_BLOCK
#
# ./dabcast.sh 0_paris/6A
#
# source: https://aerogus.net/posts/diffuser-tele-radio-reseau-local/
##

ABS_PATH="$( cd "$(dirname "$0")" || return; pwd -P )"
CONF_PATH="${ABS_PATH}/conf/dab"

# correspondance block / fréquence
# cf. https://www.digitalbitrate.com/dtv.php?page=dab
declare -A FREQS=(
  ["5A"]=174928000
  ["5B"]=176640000
  ["5C"]=178352000
  ["5D"]=180064000
  ["6A"]=181936000
  ["6B"]=183648000
  ["6C"]=185360000
  ["6D"]=187072000
  ["7A"]=188928000
  ["7B"]=190640000
  ["7C"]=192352000
  ["7D"]=194064000
  ["8A"]=195936000
  ["8B"]=197648000
  ["8C"]=199360000
  ["8D"]=201072000
  ["9A"]=202928000
  ["9B"]=204640000
  ["9C"]=206352000
  ["9D"]=208064000
  ["10A"]=209936000
  ["10B"]=211648000
  ["10C"]=213360000
  ["10D"]=215072000
  ["11A"]=216928000
  ["11B"]=218640000
  ["11D"]=222064000
  ["12A"]=223936000
  ["12B"]=225648000
  ["12C"]=227360000
  ["12D"]=229072000
  ["13A"]=230784000
  ["13B"]=232496000
  ["13C"]=234208000
  ["13D"]=235776000
  ["13E"]=237488000
  ["13F"]=239200000
)

if [[ ! $(command -v dablast) ]]; then
  echo "commande dablast manquante";
  #exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre adapter_localization/block manquant";
  echo "usage: ./dablast.sh 0_paris/6A"
  echo " 0 = le numéro de l'adaptateur"
  echo "paris/6A = localisation/block"
  exit 1;
fi

ADAPTER=${1:0:1} # 1er caractère
MUX=${1#*_} # "zone/block"
BLOCK=${MUX#*/}

if [[ ! -v "FREQS[$BLOCK]" ]]; then
  echo "mux $MUX inconnu"
  exit 1
fi

if [[ ! -f "${CONF_PATH}/$MUX.conf" ]]; then
  echo "fichier ${CONF_PATH}/$MUX.conf manquant";
  exit 1;
fi

dablast --remote-socket "/tmp/dabcast-$ADAPTER-$BLOCK.sock" -a "$ADAPTER" -f "${FREQS[$BLOCK]}" -c "${CONF_PATH}/$MUX.conf"
