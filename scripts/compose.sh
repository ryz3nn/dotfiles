#!/data/data/com.termux/files/usr/bin/sh

mkdir -p $HOME/projects/.tmp
pg_ctl -D $HOME/projects/postgresql -l $HOME/projects/.tmp/psql.log start

nohup cloudflared tunnel run --token eyJhIjoiY2JkY2UyZGY2YTY5Zjc0MzZjZjkzNWMwY2QxYmNjYzgiLCJ0IjoiZjI2NjQyOTktMTM3NC00YTA0LWI2MWUtMzI1OWVlYjc5YzIxIiwicyI6Ik9HTXlOall5WWpBdFlXUTNZeTAwTVRZMExUZ3daakl0TmpNeU5EWTROR1prWWpFNCJ9 >/dev/null 2>&1 &
