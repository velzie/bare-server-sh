#shellcheck shell=bash

echosafe() {
  printf "%s" "$1"
}

fromhex() {
  xxd -p -r -c999999
}

tohex() {
  xxd -p
}

header_parse() {
  line=$1
  line=${line//$'\r'/}
  key=${line%: *}
  key=${key,,}

  headers[$key]=${line#*: }
}

response() {
  echo "HTTP/1.0 $1"
  headers[Access-Control-Allow-Origin]="*"
  headers[Access-Control-Allow-Headers]="*"
  headers[Access-Control-Allow-Methods]="*"
  headers[Access-Control-Expose-Headers]="*"
  for header in "${!headers[@]}"; do
    echo "${header}: ${headers[$header]}"
  done
  echo
  echosafe "$2" | fromhex
}
