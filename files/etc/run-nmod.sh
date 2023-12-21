#!/bin/bash
# Modded by MSSVPN contact @mssvpn_hq t.me/mssvpn
# --- Passwall Network Monitor start ---
echo "Checking Passwall Already Run?"
sleep 1
if [ "$(pgrep -f /etc/run-nmod.sh | wc -l)" -gt 2 ]; then
        echo "Monitor Already Running!"
        exit 0
else
        echo "NO Duplicate Monitor Running."
        echo ""
fi
echo "Checking Passwall Enable?"
sleep 1
if [ "$(pgrep -f /passwall/bin | wc -l)" -gt 0 ]; then
        echo "Passwall Enable, Continue checker.."
        echo ""
else
        echo "Passwall Not Enable!"
        exit 0
fi
echo "Checking Passwall TCP & UDP Dead?"
sleep 1
if [ "$(pgrep -f passwall/TCP_UDP | wc -l)" -gt 0 ]; then
        echo "Passwall TCP_UDP Running well..."
        echo ""
        #$exit 0
else
        if [ "$(pgrep -f passwall/TCP | wc -l)" -gt 0 ]; then
        echo "Passwall TCP Running well..."
        echo ""
            if [ "$(pgrep -f passwall/UDP | wc -l)" -gt 0 ]; then
            echo "Passwall UDP Running well..."
            echo ""
            #exit 0
            else
            echo "Passwall UDP Not Running..."
            echo "Restarting Passwall..."
            /etc/init.d/passwall restart
            sleep 300
            exit 0
            fi
        #exit 0
        else
        echo "Passwall TCP Not Running..."
        echo "Restarting Passwall..."
        /etc/init.d/passwall restart
        sleep 300
        exit 0       
        fi
    #echo "Passwall TCP_UDP Not Running..."
    #echo "Restarting Passwall..."
    #/etc/init.d/passwall restart
    #sleep 300
    #exit 0 
fi
sleep 1
echo "End Passwall Monitor."
exit 0
# --- Passwall Network Monitor END ---
