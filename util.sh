
# Formatting output on terminal
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

function show_help {
    echo "Usage: "
    echo "bitsnet [OPTIONS]"
    echo
    echo "Options:
    -u USERNAME 
        use specific username
    -p PASSWORD
        specify a different password
    -o
        logout
    -d
        turn debug on
    -U
        update
    -h
        display help"
    exit
}

function debug_msg {
    if [[ debug -eq 1 ]]; then
        echo "${GREEN}DEBUG:${RESET} $1"
    fi
}

function extract_msg {
    reply="${reply##*\<message><\![CDATA[}"
    reply=$(echo "$reply" | cut -d']' -f1)
    echo $reply
}

function send_msg {
    if [[ debug -eq 0 ]]; then
        notify-send 'BITSnet' "$1" --icon=network-transmit
    else
        debug_msg "reply: $1"
    fi
}

function update {
    debug_msg "Updating"
    cd /tmp
    debug_msg "Cloning repo"
    git clone https://github.com/OSDLabs/BitsnetLogin
    cd BitsnetLogin
    debug_msg "Installing"
    ./install
    echo "Updated"
    cd /tmp
    rm -rf BitsnetLogin
    debug_msg "Exiting"
    exit
}

function logOut() {
    reply=$(wget -qO- --no-check-certificate --post-data="mode=193&username=$username&submit=Logout" $login_url)
    reply=$(extract_msg $reply)
    send_msg "$reply"
    exit
}
