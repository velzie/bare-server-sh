# TOMP Bare Server (in bash)

This repository implements the TompHTTP bare server. See the specification [here](https://github.com/tomphttp/specifications/blob/master/BareServer.md).

## Usage
```bash
PORT=8080 ./launch.sh
```
Make sure to update `uv.config.js` to point to that port

## Dependencies
`bash (4.1+)`, GNU coreutils, `xxd`, `ncat`, `curl`, `jq`

## Why?
I got nerd sniped!

![image](https://github.com/CoolElectronics/bare-server-sh/assets/58010778/0737d4c8-bf5c-4c87-b2b6-6e7a30f1a604)

Anyway, if you ignore the fact that websockets exist the bare server specification is actually remarkably simple, my implementation is only ~140 lines of bash since HTTP isn't a very complex protocol

## "it doesn't work on site X"
![e4ce080cbdc1d7bbc708f5aaff578d9c](https://github.com/CoolElectronics/bare-server-sh/assets/58010778/0b21fd03-067f-48c3-b4b4-335fd0b2ad1a)
