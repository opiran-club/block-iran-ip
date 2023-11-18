#!/bin/bash

CYAN="\e[96m"
GREEN="\e[92m"
YELLOW="\e[93m"
RED="\e[91m"
BLUE="\e[94m "
MAGENTA="\e[95m"
NC="\e[0m"
BOLD=$(tput bold)

logo=$(cat << "EOF"
    ______    _______   __      _______        __      _____  ___  
   /    " \  |   __ "\ |" \    /"      \      /""\    (\"   \|"  \ 
  // ____  \ (. |__) :)||  |  |:        |    /    \   |.\\   \    |
 /  /    ) :)|:  ____/ |:  |  |_____/   )   /' /\  \  |: \.   \\  |
(: (____/ // (|  /     |.  |   //      /   //  __'  \ |.  \    \. |
 \        / /|__/ \    /\  |\ |:  __   \  /   /  \\  \|    \    \ |
  \"_____/ (_______)  (__\_|_)|__|  \___)(___/    \___)\___|\____\)
EOF
)

logo() {
echo -e "\033[1;34m$logo\033[0m"
}

# Function to block IPs from a specific country
block_country_ips() {
  country_code="$1"
  echo -e "\e[33mBlocking IPs from $country_code\e[0m"
  curl -sSL "https://www.ipdeny.com/ipblocks/data/countries/$country_code.zone" | awk '{print "sudo ufw deny out from any to " $1}' | bash
}

flush() {
echo -e "\e[33mUninstalling and flushing UFW rules\e[0m"
  sudo ufw reset
  sudo ufw disable

  echo -e "\e[32mUFW rules have been uninstalled and flushed, and also ufw is disabled. \e[0m"
}

print_table() {
    tg_title="https://t.me/OPIranCluB"
    yt_title="youtube.com/@opiran-inistitute"
    clear
    logo
    echo -e "\e[93m╔═══════════════════════════════════════════════╗\e[0m"  
    echo -e "\e[93m║            \e[94mBlock IP                           \e[93m║\e[0m"   
    echo -e "\e[93m╠═══════════════════════════════════════════════╣\e[0m"
    echo ""
    echo -e "${BLUE}   ${tg_title}   ${NC}"
    echo -e "${BLUE}   ${yt_title}   ${NC}"
    echo ""
}

# Install required packages
apt update
apt install ufw libapache2-mod-geoip geoip-database -y
a2enmod geoip
apt install geoip-bin -y

# Open desired ports
ufw allow ssh
ufw allow http
ufw allow https

clear
# Print the question and response table
print_table

# Ask the user which country IPs to block
echo -e "\e[31m!!\e[0m\e[32m Its the common script to block outgoing traffic base on"
echo -e "country with UFW so after that allow your required ports\e[0m"
printf "\e[93m+-----------------------------------------------+\e[0m\n" 

echo -e "\e[33mWhich country IPs do you want to block?\e[0m"
echo ""
echo -e "\e[31m1)\e[0m \e[36mIran\e[0m"
echo -e "\e[31m2)\e[0m \e[36mChina\e[0m"
echo -e "\e[31m3)\e[0m \e[36mRussia\e[0m"
echo ""
echo -e "\e[31m4)\e[0m \e[36mUninstall and flush rules\e[0m"
echo ""
printf "\e[93m+-----------------------------------------------+\e[0m\n" 

read -p "Enter the number of your choice (1/2/3): " choice


case "$choice" in
  1)
    block_country_ips "ir"
    ;;
  2)
    block_country_ips "cn"
    ;;
  3)
    block_country_ips "ru"
    ;;
  4)
    flush
    ;;
  *)
    echo "\e[31mInvalid choice. Exiting...\e[0m"
    exit 1
    ;;
esac

# Print the question and response table again
print_table

# Ask the user whether to enable the firewall or not
echo -ne "\e[33mDo you want to enable the firewall\e[0m \e[31m(without enabling ufw the function won't work correctly)\e[0m? \e[33m(yes/no):\e[0m "
read enable_firewall
printf "\e[93m+-----------------------------------------------+\e[0m\n" 

if [[ "$enable_firewall" =~ ^(Y|y|YES|yes)$ ]]; then
  ufw enable
else
  echo -e "\e[31mFirewall remains disabled.\e[0m"
fi

# Set up a cronjob to update the zone every 1 month
cronjob_command="curl -sSL https://www.ipdeny.com/ipblocks/data/countries/$country_code.zone | awk '{print \"sudo ufw deny out from any to \" \$1}' | bash"
(crontab -l ; echo "0 0 1 * * $cronjob_command") | crontab -
