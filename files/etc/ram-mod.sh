#!/bin/bash
# Modded by MSSVPN contact @mssvpn_hq t.me/mssvpn
# --- Ram Flushing ---
echo "Checking Ram Flushing Running?"
sleep 1
if [ "$(pgrep -f /etc/ram-mod.sh | wc -l)" -gt 2 ]; then
        echo "Ram Flushing Already Running!"
        exit 0
else
        echo "NO Duplicate Ram Flushing Running."
        echo ""
fi
echo "Check Available Ram . . "
echo "Ram Available: $(grep MemFree /proc/meminfo | cut -d ' ' -f12)"
if [ "$(grep MemFree /proc/meminfo | cut -d ' ' -f12)" -gt 35000 ]; then
        echo "RAM in good state!"
else
        echo "Need to flush ram. Start now . . ."
        echo 3 > /proc/sys/vm/drop_caches
fi
exit 0
# --- Passwall Network Monitor END ---
