if [[ "$(grep -o "auto_configuration_at_start_of_this_scrip: " settings)" == "auto_configuration_at_start_of_this_scrip: yes" ]]; then

    echo ""
    echo "configuring..."
    if [[ "$(cat settings | grep connection_protocol: )" == "connection_protocol: TCP" ]] ; then
        protonvpn-cli config -p tcp
    elif [[ "$(cat settings | grep connection_protocol: )" == "connection_protocol: UDP" ]] ; then
        protonvpn-cli config -p udp
    else
        echo "can't continue configure connection protocol error code: 1"
        exit 1
    fi

    if [[ "$(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}, [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}, [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" settings)" != "" ]]; then
        protonvpn-cli config --dns custom --ip $(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}, [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}, [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" settings)
    elif [["$(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}, [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" settings)" != "" ]]; then
        protonvpn-cli config --dns custom --ip $(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}, [0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" settings)
    elif [[ "$(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" settings)" != "" ]]; then
        protonvpn-cli config --dns custom --ip $(grep -o "[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}" settings)
    elif [[ "$(grep -o "dns: auto")" == "dns: auto" ]]; then
        protonvpn-cli config --dns automatic
    else
        echo "can't configure dns server code exit  exit code: 2"
        exit 1
    fi

    if [[ "$(cat settings | grep killswitch)" == "killswitch: true" ]] ; then
        protonvpn-cli ks --on
    elif [[ "$(cat settings | grep killswitch)" == "killswitch: fasle" ]]; then
        protonvpn-cli ks --off
    else
        echo "can't configure kill switch exit code: 3"
        exit 1
    fi

    if [[ "$(cat settings | grep fast_connection)" == "fast_connection: true"]]; then
        fs = "-f"
    elif [[ "$(cat settings | grep fast_connection)" == "fast_connection: fasle"]]; then
        fs = ""
    else
        echo "can't configure fast connection exit code: 4"
        exit 1
    fi

    echo " "
    echo "done configuring"
    echo " "
fi

flag_loop = true
flag_clear = false

while [[ flag_loop == true ]] ; do

    if [[ "$(protonvpn-cli s | grep "No active ProtonVPN connection.")" == "NO active ProtonVPN connection." ]] ; then
        flag_active_protonvpn_connections=false
    else
        flag_active_protonvpn_connections=true
    fi

    if [[ flag_clear == true ]] ; then
        clear
    fi
    flag_clear = true

    echo "menu"
    echo "1-start proton vpn"
    if [[ $flag_active_protonvpn_connections == true ]] ; then    
        echo "2-stop proton vpn"
        echo "3-reconnect proton vpn"
    fi
    echo "st-status proton vpn"
    echo "s-settings"
    echo "e-exit"
    read answer

    if [[ $ans == 1 ]] ; then

    elif [[ $ans == 2 ]] ; then

    fi
done
