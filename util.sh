#
# util.sh
# Defines a set of utility function for bitsnet
#

# Used to format output on terminal
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

#
# Display help msg on screen
#
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
    -f
        force login attempt
    -U
        update
    -w
        Force sending request to wireless
    -q
        Quiet mode. Don't send a notification
    -h
        display help"
}

#
# Display debug messages if enabled
#
function debug_msg {
    if [[ debug -eq 1 ]]; then
        echo "${GREEN}DEBUG:${RESET} $1"
    fi
}

#
# Extract reply from the recieved response
#
function extract_msg {
    reply="${reply##*\<message><\![CDATA[}"
    reply=$(echo "$reply" | cut -d']' -f1)

    # if there was no readable reply
    if [[ "$reply" == "" ]];
    then
        reply="Cannot connect to BITSnet"
    fi
    echo "$reply"
}

#
# Send notification if enabled
#
function send_msg {
    if [[ $debug == 0 && $quiet != 1 ]]; then
        notify-send 'BITSnet' "$1" --icon=network-transmit --hint=int:transient:1
    else
        debug_msg "reply: $1"
    fi
}

#
# Get device info
#
function get_device {
    devInfo="$(nmcli dev | grep " connected" | cut -d " " -f1)"

    # If the connection is through a virtual bridge, select the next device
    if [[ $devInfo == "virbr"* ]]; then
        devInfo=$(echo "$devInfo" | sed 1,1d)
    fi;

    if [[ $devInfo == "en"* ]]; then
        # ethernet
        dev=1
    elif [[ $devInfo == "wl"* ]]; then
        # wifi
        dev=2
    elif [[ $devInfo == "virbr"* ]]; then
        # virtual bridge
        dev=3
    else
        # unknown
        dev=0
    fi

    echo "$dev"
}

#
# Login to the router
#
function router_login() {
    wget --post-data="username=${username[1]}&password=${password[1]}&loginAccept=1&buttonClicked=4&err_flag=0&info_flag=0&Submit=Submit&err_msg=&info_msg=&redirect_url=" "https://20.20.2.11/login.html" --no-check-certificate --quiet -O /dev/null
}

#
# Login to the LDAP
# returns reply
#
function ldap_login() {
    reply=$(wget -qO- --no-check-certificate --post-data="mode=191&username=$1&password=$2" "$login_url")
    echo "$reply"
}

#
# Send a logout request
#
function log_out {
    reply=$(wget -qO- --no-check-certificate --post-data="mode=193&username=garbage" "$login_url" -O /dev/null)
    reply=$(extract_msg "$reply")
    send_msg "$reply"
    exit 0
}

#
# Update the program
#
function update {
    debug_msg "Updating"
    cd /tmp || exit 1
    debug_msg "Cloning repo"
    git clone --depth=1 https://github.com/OSDLabs/BitsnetLogin
    cd BitsnetLogin || exit 1
    debug_msg "Installing"
    ./install
    echo "Updated"
    cd /tmp || exit 1
    rm -rf BitsnetLogin
    debug_msg "Exiting"
    exit 0
}
