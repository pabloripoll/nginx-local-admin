#!/usr/bin/env bash

if [ "$iparams" -eq 3 ]; then
    platform="${SERVERS::5}"
    domain=$param_1
    if [ -z ${domain} ]; then 
        echo $(red "domain name has not been declared.")
        exit 1
    fi
else
    platform=$param_1
    domain=$param_2
fi

if [ -z $platform ]; then \
    echo $(red "Server Platform") $(yellow "must be specified!");
    exit 1;
fi

if [[ ! "$platform" =~ ^($SERVERS)$ ]]; then
    echo $(yellow "Server platform") $(red "$platform") $(yellow "is not recognizable!");
    echo Param $(yellow "1") is for $(green "platform");
    echo Param $(yellow "2") is for $(green "new domain name");
    exit 1;
fi

DIR_PLATFORM="${ETC_NGINX}"
if [[ "$platform" =~ ^(apache)$ ]]; then DIR_PLATFORM="${ETC_APACHE}"; fi

file=${DIR_PLATFORM}/sites-available/${domain}${TLD}.conf
if [ ! -f "$file" ]; then
    echo Domain $(green "${domain}${TLD}") on $(yellow "${platform^^}") platform $(red "not found!")
    exit 1
fi

file=${DIR_PLATFORM}/sites-enabled/${domain}${TLD}.conf
if [ ! -f "$file" ]; then
    echo Domain $(green "${domain}${TLD}") on $(yellow "${platform^^}") platform $(red "is not active!")
    exit 1
fi

# Process confirmation
echo Domain $(green "${domain}${TLD}") access through $(yellow "${platform^^}") platform $(yellow "will be put down offline.")
prompt_confirm_proceed "Are you sure to proceed?" || exit 1

# Down on Apache if domain belongs to
if [[ "$platform" =~ ^(apache)$ ]]; then
    action=$(echo "$(sudo a2dissite ${domain}${TLD}.conf)")
    echo Domain $(yellow "${domain}${TLD}") has been put down offline in $(yellow "APACHE") platform.
    sudo systemctl reload apache2
    echo $(yellow "APACHE") $(green "sites has been updated!")
fi

# Down on Nginx
action=$(echo "$(sudo rm ${ETC_NGINX}/sites-enabled/${domain}${TLD}.conf)")
echo Domain $(yellow "${domain}${TLD}") has been put down offline in $(yellow "NGINX") platform.
sudo systemctl restart nginx
echo $(yellow "NGINX") $(green "sites has been updated!")