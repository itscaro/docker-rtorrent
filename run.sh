#!/bin/sh

set -x

mkdir -p /downloads/incoming /downloads/completed /downloads/watched /downloads/sessions /tmp/rtorrent
chown -R rtorrent:rtorrent /downloads /rutorrent /tmp/rtorrent
