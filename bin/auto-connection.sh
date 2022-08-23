#!/usr/bin/env bash

res=$(nmcli dev wifi)

if echo "$res" | grep -q "Maltepe_Student"; then
        echo "CONNECTING TO Maltepe_Student";
        sudo /home/lem0n/.dotfiles/bin/connect-to-maltepe-student;
elif echo "$res" | grep -q "GSBWIFI"; then
        echo "CONNECTING TO GSBWIFI";
        /home/lem0n/.dotfiles/bin/connect-to-kyk;
else
        echo "Kütüphanede ya da yurtta değilsin, sana bırakıyorum...";
fi
