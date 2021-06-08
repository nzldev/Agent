#!/bin/bash

#
#////////////////////////////////////////////////////////////
#===========================================================
# Uptime360 - Installer v1.2
#===========================================================
# Set environment
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Clear the screen
clear


#SERVERKEY=$1
#GATEWAY=$2
LOG=/tmp/uptime360.log

normal=$'\e[0m'                           # (works better sometimes)
bold=$(tput bold)                         # make colors bold/bright
red="$bold$(tput setaf 1)"                # bright red text
green=$(tput setaf 2)                     # dim green text
fawn=$(tput setaf 3); beige="$fawn"       # dark yellow text
yellow="$bold$fawn"                       # bright yellow text
darkblue=$(tput setaf 4)                  # dim blue text
blue="$bold$darkblue"                     # bright blue text
purple=$(tput setaf 5); magenta="$purple" # magenta text
pink="$bold$purple"                       # bright magenta text
darkcyan=$(tput setaf 6)                  # dim cyan text
cyan="$bold$darkcyan"                     # bright cyan text
gray=$(tput setaf 7)                      # dim white text
darkgray="$bold"$(tput setaf 0)           # bold black = dark gray text
white="$bold$gray"                        # bright white text

#echo "${red}hello ${yellow}this is ${green}coloured${normal}"
echo "${yellow} _   _______ _____ ________  ________   _____  ____ _____${normal}"
echo "${yellow}| | | | ___ |_   _|_   _|  \/  |  ___| |____ |/ ___|  _  |${normal}"
echo "${yellow}| | | | |_/ / | |   | | | .  . | |__       / / /___| |/' |${normal}"
echo "${yellow}| | | |  __/  | |   | | | |\/| |  __|      \ | ___ |  /| |${normal}"
echo "${yellow}| |_| | |     | |  _| |_| |  | | |___  .___/ | \_/ \ |_/ /${normal}"
echo "${yellow} \___/\_|     \_/  \___/\_|  |_\____/  \____/\_____/\___/${normal}"
echo "${purple}*************** UPTIME360 Agent Installer ***************${normal}"
echo " "

# Are we running as root
if [ $(id -u) != "0" ]; then
	echo "${red}Uptime360 Agent installer needs to be run with root privileges${normal}"
	echo "${red}Try again with root privileges${normal}"
	exit 1;
fi

# Is the server key parameter given ?
if [ $# -lt 1 ]; then
	echo "${red}The server key or gateway is missing${normal}"
	echo "${red}Exiting installer${normal}"
	exit 1;
fi

### install Dependencies here
echo "${blue}Installing Dependencies${normal}"

# RHEL / CentOS / etc
if [ -n "$(command -v yum)" ]; then
  echo -ne '>>>                       [20%]\r'
	yum -y install cronie gzip curl >> $LOG 2>&1
	sleep 1
	service crond start >> $LOG 2>&1
	chkconfig crond on >> $LOG 2>&1

	echo -ne '>>>>>>>                   [40%]\r'
	sleep 1

	# Check if perl available or not
	if ! type "perl" >> $LOG 2>&1; then
		yum -y install perl >> $LOG 2>&1
	fi

	echo -ne '>>>>>>>>>>>>>>            [60%]\r'
	sleep 1
	# Check if unzip available or not
	if ! type "unzip" >> $LOG 2>&1; then
		yum -y install unzip >> $LOG 2>&1
	fi

	echo -ne '>>>>>>>>>>>>>>>>>>>>>>>   [80%]\r'
  sleep 1
	# Check if curl available or not
	if ! type "curl" >> $LOG 2>&1; then
		yum -y install curl >> $LOG 2>&1
	fi
fi

# Debian / Ubuntu
if [ -n "$(command -v apt-get)" ]; then
  echo -ne '>>>                       [20%]\r'
	apt-get update -y >> $LOG 2>&1
	apt-get install -y cron curl gzip >> $LOG 2>&1
	service cron start >> $LOG 2>&1

	# Check if perl available or not
	if ! type "perl" >> $LOG 2>&1; then
		apt-get install -y perl >> $LOG 2>&1
	fi
	echo -ne '>>>>>>>                   [40%]\r'
	sleep 1

	# Check if unzip available or not
	if ! type "unzip" >> $LOG 2>&1; then
		apt-get install -y unzip >> $LOG 2>&1
	fi
	echo -ne '>>>>>>>>>>>>>>            [60%]\r'
	sleep 1

	# Check if curl available or not
	if ! type "curl" >> $LOG 2>&1; then
		apt-get install -y curl >> $LOG 2>&1
	fi
	echo -ne '>>>>>>>>>>>>>>>>>>>>>>>   [80%]\r'
	sleep 1
fi

# ArchLinux
if [ -n "$(command -v pacman)" ]; then
	pacman -Sy  >> $LOG 2>&1
	pacman -S --noconfirm cronie curl gzip >> $LOG 2>&1
	systemctl start cronie >> $LOG 2>&1
	systemctl enable cronie >> $LOG 2>&1

	# Check if perl available or not
	if ! type "perl" >> $LOG 2>&1; then
		pacman -S --noconfirm perl >> $LOG 2>&1
	fi

	# Check if unzip available or not
	if ! type "unzip" >> $LOG 2>&1; then
		pacman -S --noconfirm unzip >> $LOG 2>&1
	fi

	# Check if curl available or not
	if ! type "curl" >> $LOG 2>&1; then
		pacman -S --noconfirm curl >> $LOG 2>&1
	fi
fi


# OpenSuse
if [ -n "$(command -v zypper)" ]; then
	zypper --non-interactive install cronie curl gzip >> $LOG 2>&1
	service cron start >> $LOG 2>&1

	# Check if perl available or not
	if ! type "perl" >> $LOG 2>&1; then
		zypper --non-interactive install perl >> $LOG 2>&1
	fi

	# Check if unzip available or not
	if ! type "unzip" >> $LOG 2>&1; then
		zypper --non-interactive install unzip >> $LOG 2>&1
	fi

	# Check if curl available or not
	if ! type "curl" >> $LOG 2>&1; then
		zypper --non-interactive install curl >> $LOG 2>&1
	fi
fi


# Gentoo
if [ -n "$(command -v emerge)" ]; then

	# Check if crontab is present or not available or not
	if ! type "crontab" >> $LOG 2>&1; then
		emerge cronie >> $LOG 2>&1
		/etc/init.d/cronie start >> $LOG 2>&1
		rc-update add cronie default >> $LOG 2>&1
 	fi

	# Check if perl available or not
	if ! type "perl" >> $LOG 2>&1; then
		emerge perl >> $LOG 2>&1
	fi

	# Check if unzip available or not
	if ! type "unzip" >> $LOG 2>&1; then
		emerge unzip >> $LOG 2>&1
	fi

	# Check if curl available or not
	if ! type "curl" >> $LOG 2>&1; then
		emerge net-misc/curl >> $LOG 2>&1
	fi

	# Check if gzip available or not
	if ! type "gzip" >> $LOG 2>&1; then
		emerge gzip >> $LOG 2>&1
	fi
fi


# Slackware
if [ -f "/etc/slackware-version" ]; then

	if [ -n "$(command -v slackpkg)" ]; then

		# Check if crontab is present or not available or not
		if ! type "crontab" >> $LOG 2>&1; then
			slackpkg -dialog=off -batch=on -default_answer=y install dcron >> $LOG 2>&1
		fi

		# Check if perl available or not
		if ! type "perl" >> $LOG 2>&1; then
			slackpkg -dialog=off -batch=on -default_answer=y install perl >> $LOG 2>&1
		fi

		# Check if unzip available or not
		if ! type "unzip" >> $LOG 2>&1; then
			slackpkg -dialog=off -batch=on -default_answer=y install infozip >> $LOG 2>&1
		fi

		# Check if curl available or not
		if ! type "curl" >> $LOG 2>&1; then
			slackpkg -dialog=off -batch=on -default_answer=y install curl >> $LOG 2>&1
		fi

		# Check if gzip available or not
		if ! type "gzip" >> $LOG 2>&1; then
			slackpkg -dialog=off -batch=on -default_answer=y install gzip >> $LOG 2>&1
		fi

	else
		echo "${red}Please install slack pkg and re-run installation.${normal}"
		exit 1;
	fi
fi


# Is Cron available?
if [ ! -n "$(command -v crontab)" ]; then
	echo "${red}Cron is required but we could not install it.${normal}"
	echo "${red}Exiting installer${normal}"
	exit 1;
fi

# Is CURL available?
if [  ! -n "$(command -v curl)" ]; then
	echo "${red}CURL is required but we could not install it.${normal}"
	echo "${red}Exiting installer${normal}"
	exit 1;
fi

# Remove previous installation
if [ -f /opt/uptime360/agent.sh ]; then
	# Remove folder
	rm -rf /opt/uptime360
	# Remove crontab
	crontab -r -u uptime360agent >> $LOG 2>&1
	# Remove user
	userdel uptime360agent >> $LOG 2>&1
fi

# Check if the system can establish SSL connection
if curl --output /dev/null --silent --head --fail "https://hop.ut360.net"; then
	### Install ###
	sleep 2
	mkdir -p /opt/uptime360 >> $LOG 2>&1
	echo "=================="
	wget -O /opt/uptime360/agent.sh https://hop.ut360.net/assets/agent.sh >> $LOG 2>&1
  sleep 1
	echo "${gray}$1${normal}" > /opt/uptime360/serverkey
	echo "${gray}https://hop.ut360.net/agent.php${normal}" > /opt/uptime360/gateway
        "SSL Connection Established..." >> $LOG 2>$1
else
	echo " "
	echo "${red}==========:( Sorry! Cannot install Uptime360 Agent :(==========${normal}"
	echo " "
	echo "${red}Maybe you are using old OS which cannot establish SSL connection.${normal}"
	echo "${red}But still if you want to continue monitoring then your system data${normal}"
	echo "${red}will be sent to Uptime360 using HTTP protocol.${normal}"
	echo " "
	read -n 1 -p "Do you want to continue? [Y/n] " reply;
	if [ ! "$reply" = "${reply#[Nn]}" ]; then
	   echo ""
	   echo ""
	   echo "${red}Terminated Uptime360 agent installation.${normal}"
	   echo "${red}If you think its an error contact support.${normal}"
	   echo ""
	   echo ""
	   exit 1;
	fi
	echo ""
	echo "${green}Continuing installation with HTTP protocol...${normal}"
	echo ""
	### Install ###
        mkdir -p /opt/uptime360
        wget -O /opt/uptime360/agent.sh https://hop.ut360.net/assets/agent.sh
        echo "${gray}$1${normal}" > /opt/uptime360/serverkey
        echo "${gray}http://hop.ut360.net/agent.php${normal}" > /opt/uptime360/gateway
fi

# Did it download ?
if ! [ -f /opt/uptime360/agent.sh ]; then
	echo "${red}Unable to install!${normal}"
	echo "${red}Exiting installer${normal}"
	exit 1;
fi

useradd uptime360agent -r -d /opt/uptime360 -s /bin/false >> $LOG 2>&1
groupadd uptime360agent >> $LOG 2>&1

# Disable cagefs for uptime360
if [ -f /usr/sbin/cagefsctl ]; then
	/usr/sbin/cagefsctl --disable uptime360agent >> $LOG 2>&1
fi

# Modify user permissions
chown -R uptime360agent:uptime360agent /opt/uptime360 && chmod -R 700 /opt/uptime360 >> $LOG 2>&1

# Configure cron
crontab -u uptime360agent -l 2>/dev/null | { cat; echo "* * * * * bash /opt/uptime360/agent.sh > /opt/uptime360/cron.log 2>&1"; } | crontab -u uptime360agent -

echo -ne '>>>>>>>>>>>>>>>>>>>>>>>>>>[100%]\r'
echo -ne '\n'

echo " "
echo "${green}-------------------------------------"
echo " Installation Completed "
echo "-------------------------------------${normal}"
echo "${purple}Log: cat /tmp/uptime360.log${normal}"
echo " "
echo "====== Uninstall instructions ======="
echo "Execute the command below to uninstall Uptime360 Agent from your server"
echo " "
echo "-------------------------------------"
echo "${purple}rm -rf /opt/uptime360 && crontab -r -u uptime360agent >> /tmp/uptime360.log 2>&1 && userdel uptime360agent >> /tmp/uptime360.log 2>&1${normal}"
echo "${green}-------------------------------------${normal}"
echo " ${normal}"
echo "${gray}www.uptime360.net"
echo "Thank you for choosing Uptime360!${normal}"

# Attempt to delete this installer
if [ -f $0 ]; then
	rm -f $0
fi
