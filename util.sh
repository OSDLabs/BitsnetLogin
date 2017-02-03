
# Formatting output on terminal
GREEN="$(tput setaf 2)"
RESET="$(tput sgr0)"

function show_help {
    echo "PUT HELP TEXT HERE"
}

function debug_msg {
    if [[ debug -eq 1 ]]; then
        echo "${GREEN}DEBUG:${RESET} $1"
    fi
}

function send_msg {
    if [[ debug -eq 0 ]]; then
        notify-send 'BITSnet' "$1" --icon=network-transmit
    else
        debug_msg "reply: $1"
    fi
}
