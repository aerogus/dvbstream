#!/usr/bin/env bash

##
# Générateur de mosaïque
##

# récupérer le pid du dernier processus lancé
# ps > /dev/null &; echo "$\!"

SCREEN_WIDTH=1920
SCREEN_HEIGHT=1080

PIDS=()

STREAMS=()
#STREAMS+=('http://dvbt02.local/rtp/239.10.10.1:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.2:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.3:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.4:1234')
#STREAMS+=('http://dvbt02.local/rtp/239.10.10.5:1234')
#STREAMS+=('http://dvbt02.local/rtp/239.10.10.6:1234')
#STREAMS+=('http://dvbt02.local/rtp/239.10.10.7:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.8:1234')
#STREAMS+=('http://dvbt02.local/rtp/239.10.10.9:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.10:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.11:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.12:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.13:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.14:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.15:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.16:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.17:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.18:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.20:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.21:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.22:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.23:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.24:1234')
STREAMS+=('http://dvbt02.local/rtp/239.10.10.25:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.26:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.27:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.30:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.31:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.32:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.33:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.34:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.41:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.42:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.43:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.45:1234')
STREAMS+=('http://dvbt01.local/rtp/239.10.10.46:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.52:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.53:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.81:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.82:1234')
STREAMS+=('http://dvbt03/rtp/239.10.10.83:1234')

# 3x2 streams full HD met à genou le M1
COLS=3
ROWS=2

MOSA_WIDTH=$((SCREEN_WIDTH / COLS))
MOSA_HEIGHT=$((SCREEN_HEIGHT / ROWS))

IDX=0
for (( ROW=0; ROW<$ROWS; ROW++ )); do
  for (( COL=0; COL<$COLS; COL++ )); do  
    echo "row $ROW col $COL"
    POS_X=$((COL * MOSA_WIDTH))
    POS_Y=$((ROW * MOSA_HEIGHT))
    echo "x $POS_X y $POS_Y"
    echo "stream: ${STREAMS[IDX]}"
    GEOMETRY="$MOSA_WIDTH""x""$MOSA_HEIGHT""+""$POS_X""+""$POS_Y"
    mpv ${STREAMS[IDX]} --geometry=$GEOMETRY --mute=yes --no-border --deinterlace=yes &
    PIDS+=($!)
    IDX=$((IDX+1))
  done
done

echo $PIDS
