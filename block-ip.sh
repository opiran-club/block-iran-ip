#!/bin/bash
clear 

# Color variables for dark mode
RED=$(tput setaf 1)       # Dark red
YELLOW=$(tput setaf 3)    # Dark yellow
CYAN=$(tput setaf 6)      # Dark cyan
GREEN=$(tput setaf 2)     # Dark green
BLUE=$(tput setaf 4)      # Dark blue
MAGENTA=$(tput setaf 5)   # Magenta
WHITE=$(tput setaf 7)     # White
BOLD=$(tput bold)
RESET=$(tput sgr0)

# Function to block IPs from a specific country
block_country_ips() {
  country_code="$1"
  echo -e "\e[33mBlocking IPs from $country_code\e[0m"
  curl -sSL "https://www.ipdeny.com/ipblocks/data/countries/$country_code.zone" | awk '{print "sudo ufw deny out from any to " $1}' | bash
}

# Function to print the formatted question and response table
print_table() {
  echo -e "\e[32m─────────────────────────────────────────────────────────────\e[0m"
  echo -e "\e[37m  ㅤ      ─────────── OPIRAN PANEL ───────────  \e[0m"
  echo -e "\e[31m─────────────────────────────────────────────────────────────\e[0m"
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
echo -e "\e[31m─────────────────────────────────────────────────────────────\e[0m"

echo -e "\e[33mWhich country IPs do you want to block?\e[0m"
echo ""
echo -e "\e[31m1)\e[0m \e[36mIran\e[0m"
echo -e "\e[31m2)\e[0m \e[36mChina\e[0m"
echo -e "\e[31m3)\e[0m \e[36mRussia\e[0m"
echo ""
echo -e "\e[31m─────────────────────────────────────────────────────────────\e[0m"

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
  *)
    echo "\e[31mInvalid choice. Exiting...\e[0m"
    exit 1
    ;;
esac

# Print the question and response table again
print_table

# Ask the user whether to enable the firewall or not
read -p "\e[33mDo you want to enable the firewall\e[0m \e[31m(without enabling ufw the function won't work correctly)\e[0m? \e[33m(yes/no):\e[0m " enable_firewall
echo -e "\e[31m─────────────────────────────────────────────────────────────\e[0m"

if [[ "$enable_firewall" =~ ^(Y|y|YES|yes)$ ]]; then
  ufw enable
else
  echo -e "\e[31mFirewall remains disabled.\e[0m"
fi

# Set up a cronjob to update the zone every 1 month
cronjob_command="curl -sSL https://www.ipdeny.com/ipblocks/data/countries/$country_code.zone | awk '{print \"sudo ufw deny out from any to \" \$1}' | bash"
(crontab -l ; echo "0 0 1 * * $cronjob_command") | crontab -
