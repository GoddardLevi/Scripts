#!/bin/bash

#                             A basic Osint Recon Tool.
#                 Don't use the script and say its your. Be Lekker.
# 				Made by Levi Goddard 
#			    Inspired by The Cyber Mentor

#The recon tool:
                    # Inspects Whois
		    # Nmap scan
                    # Finds subdomains
                    # Checks to see if subdomains are alive
                    # Screenshots alive subdomains
Data=domain
domain=$1
RED="\033[1;31m"
GREEN="\[\033[0;32m\]"
BLUE="\[\033[0;34m\]"
PURPLE="\[\033[0;35m\]"
CYAN="\[\033[0;36m\]" 
RESET="\033[0m"

#Colors for Future Use

# Reset
Color_Off="\[\033[0m\]"       # Text Reset

# Regular Colors
Black="\[\033[0;30m\]"        # Black
Red="\[\033[0;31m\]"          # Red
Green="\[\033[0;32m\]"        # Green
Yellow="\[\033[0;33m\]"       # Yellow
Blue="\[\033[0;34m\]"         # Blue
Purple="\[\033[0;35m\]"       # Purple
Cyan="\[\033[0;36m\]"         # Cyan
White="\[\033[0;37m\]"        # White

# Bold High Intensty
BIBlack="\[\033[1;90m\]"      # Black
BIRed="\[\033[1;91m\]"        # Red
BIGreen="\[\033[1;92m\]"      # Green
BIYellow="\[\033[1;93m\]"     # Yellow
BIBlue="\[\033[1;94m\]"       # Blue
BIPurple="\[\033[1;95m\]"     # Purple
BICyan="\[\033[1;96m\]"       # Cyan
BIWhite="\[\033[1;97m\]"      # White

On_IWhite="\[\033[0;107m\]"   # White

# Various variables you might want for your PS1 prompt instead
Time12h="\T"
Time12a="\@"
PathShort="\w"
PathFull="\W"
NewLine="\n"
Jobs="\j"

info_path=$domain/info 
subdomain_path=$domain/subdomains
screenshot_path=$domain/screenshots

echo "Enter IP or URL : " 
read domain 
echo "Entered input is $domain" 

if [ ! -d "$domain" ];then
        mkdir $domain
fi 

if [ ! -d "info_path" ];then
        mkdir $info_path
fi 

if [ ! -d "$subdomain_path" ];then
        mkdir $subdomain_path
fi 

if [ ! -d "$screenshot_path" ];then
        mkdir $screenshot_path
fi 


echo -e "${BIRed} [+] Checking whois ...${RESET}" 
whois $domain > $info_path/whois.txt

echo -e "${BIYellow=} [+] Launching nmap ...${RESET}"
nmap -d $domain -sV -sC -Pn -oN nmap > $info_path/nmap.txt

echo -e "${BIBlue} [+] Launching subfinder ...${RESET}"
subfinder -d $domain > $subdomain__path/found.txt

echo -e "${BIBlue} [+] Launching finalrecon ...${RESET}"
finalrecon -host -d $domain --ful -o recon > $info_path/recon.txt

echo -e "${BIBlue} [+] Launching Nikto ...${RESET}"
nikto -d $domain > $info_path/nikto

echo -e "${BIPurple} [+] Running assetfinder ...${RESET}"
assetfinder $domain | grep $domain >> $subdomain_path/found.txt

#echo -e "${BICyan} [+] Running Amass. This could take a while ...${RESET}"
#amass enum -d $domain >> subdomain_path/found.txt

echo -e "${BIWhite} [+] Checking whats alive ...${RESET}"
cat  $subdomain_path/found.txt | grep $domain | sort -u | httprobe -prefer-https | sed 's/https\?:\/\///' | tee -a $subdomain_path/alive.txt

echo -e "${BIGreen} [+] Saving screenshots ... ${RESET}"
gowitness file -f $subdomain_path/alive.txt -P $screenshot_path/ --no-http

