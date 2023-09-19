#!/bin/bash

. ./main.sh
PORT=${PORT:-8081}

ncat -k -l -p "$PORT" -c "source ./main.sh; ( listen>&4 ) 3>&1" 4>&1
