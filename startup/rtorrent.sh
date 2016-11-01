#!/bin/sh

set -x

# arrange dirs and configs
mkdir -p /downloads/.rtorrent/session /downloads/.rtorrent/watch
ln -s /downloads/.rtorrent/.rtorrent.rc /.rtorrent.rc
chown -R rtorrent:rtorrent /downloads/.rtorrent /home/rtorrent
rm -f /downloads/.rtorrent/session/rtorrent.lock

su -l -c "TERM=dumb rtorrent" rtorrent
