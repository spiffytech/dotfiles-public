#!/bin/bash

export DISPLAY=:0.0

md5sum ~/Dropbox/IFTTT/reddit/EarthPorn/* | grep -P '(e0fc1d135589ed54430864ac0e590c38|3993028fcea692328e097de50b26f540)' | awk -F' ' '{print $2}' | xargs rm -f  # Remove wallpapers that are 404
fbsetbg -a "$(find /home/spiffytech/Dropbox/IFTTT/reddit/EarthPorn | sort -R | tail -n 1)"
