#
# util.sh
# Defines a set of utility function for bitsnet
#

# Used to format output on terminal
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

#
# Display help msg on screen
# use man page for that
#
function show_help {
    man bitsnet
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
# Return IP address of the current route
#
function get_ip() {
    ip route show | grep -o '[0-9]\+[.][0-9]\+[.][0-9]\+[.][0-9]\+' | head -1
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
    if [[ $debug -eq 0 && $quiet -ne 1 ]]; then
        notify-send 'BITSnet' "$1" --icon=network-transmit --hint=int:transient:1
    else
        debug_msg "reply: $1"
    fi
}

#
# Get device info
#
function get_device {
    for device in /sys/class/net/* ; do
        dev_state=$(cat "$device/operstate")
        if [[ "$dev_state" == "up" ]]; then
            # retain the part after the last '/' ie the interface name
            echo "${device##*/}"
        fi
    done
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
