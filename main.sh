#shellcheck shell=bash

. ./util.sh

listen() {
  read -r line

  request=($line)

  unset headers
  declare -A headers
  while read -r line; do
    if [ "$line" = "$(echo -en "0d0a" | xxd -r -p)" ]; then
      break
    fi
    header_parse "$line"
  done

  case "${request[1]}" in
  /)
    kbused=$(pmap -x $$ | tail -n 1 | awk '{print $3}')
    content=$(
      jq -r -n --argjson versions '["v3"]' \
        --arg language "$(ps -p $$ -ocomm=)" \
        --arg memoryUsage "$((kbused / 1000))" \
        --argjson project "$(
          jq -r -n --arg name "bare-server-sh" \
            --arg description "TOMPHTTP bash Bare Server" \
            --arg repository "https://github.com/CoolElectronics/bare-server-sh" \
            --arg version "1.0.0" \
            '$ARGS.named'
        )" \
        '$ARGS.named' |
        tohex
    )

    unset headers
    declare -A headers

    response 200 "$content" >&3
    ;;
  /v3*)
    bareURL=${headers[x-bare-url]}
    if [ -n "$bareURL" ]; then
      # create a pipefd
      exec {stderr}<> <(:)
      data=$(curl -s -v "$bareURL" 2>&$stderr | tohex)

      unset headers
      declare -A headers
      while read -r line; do
        line=${line//$'\r'/}
        case "$line" in
        \<*)
          line=${line:2}
          if [ -n "$line" ]; then
            case "$line" in
            *:*)
              header_parse "$line"
              ;;
            esac
          else
            break
          fi
          ;;
        esac
      done <&$stderr

      headersobj=$(
        for i in "${!headers[@]}"; do
          echo "$i"
          echo "${headers[$i]}"
        done |
          jq -n -R 'reduce inputs as $i ({}; . + { ($i): (input|(tonumber? // .)) })' | tr -d "\n"
      )

      unset headers
      declare -A headers
      headers[X-Bare-Headers]=$headersobj
      headers[X-Bare-Status]=200
      headers[X-Bare-Status-Text]="OK"
      response 200 "$data" >&3
    else
      unset headers
      declare -A headers
      resp=$(echo -en "qhar" | tohex)
      response 200 "$resp" >&3
    fi
    ;;
  *)
    unset headers
    declare -A headers
    response 200 "$(echo -e "404" | tohex)" >&3
    ;;
  esac
}
