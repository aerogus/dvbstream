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

[[ $(command -v mumudvb) ]] || { echo "mumudvb manquant"; exit 1; }
[[ $# -lt 1 ]] && { echo "mux manquant"; exit 1; }
[[ -f "${CONF_PATH}/$1.conf" ]] || { echo "fichier ${CONF_PATH}/$1.conf manquant"; exit 1; }

case $1 in
    r1) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
    r2) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
    r3) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
    r4) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
    r6) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
    r7) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
   r15) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
  hevc) mumudvb -d -c "${CONF_PATH}/$1.conf" ;;
      *) echo "mux inconnu" ;;
esac

