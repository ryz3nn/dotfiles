#!/usr/bin/env bash

if fcitx5-remote -c >/dev/null 2>&1; then
    echo '{"text":"EN"}'
else
    echo '{"text":"中"}'
fi
