#!/usr/bin/env bash

prompt_confirm() {
    while true; do
        read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
        REPLY="${REPLY,,}"
        case $REPLY in
            [y]) echo ;return 0 ;;
            [n]) echo ;return 1 ;;
            *) printf " \033[31m %s \n\033[0m" "invalid input"
        esac
    done
}

prompt_confirm_proceed() {
    while true; do
        read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
        REPLY="${REPLY,,}"
        case $REPLY in
            [y]) echo ;return 0 ;;
            [n]) echo ;return 1 ;;
            *) printf " \033[31m %s \n\033[0m" "invalid input"
        esac
    done
}
