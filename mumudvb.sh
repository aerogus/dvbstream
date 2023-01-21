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
ALLOWED_MUXES=(r1 r2 r3 r4 r6 r7 r15 hevc)

if [[ ! $(command -v mumudvb) ]]; then
  echo "commande mumudvb manquante";
  echo "apt install mumudvb"
  exit 1;
fi

if [[ $# -lt 1 ]]; then
  echo "paramètre mux manquant";
  echo "usage: ./mumudvb.sh r1"
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

mumudvb -d -c "${CONF_PATH}/$1.conf"
