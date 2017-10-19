#!/bin/bash

#Identifies OS
YUM_CMD=$(command -v yum)
APT_GET_CMD=$(command -v apt-get)
#OTHER_CMD=$(command -v <other installer>)

# Other Variables
ip=173.194.34.132 # google.com
essid=BTOpenzone

#All of the individual functions are up here!

#<-------------------------------FUNCTIONS---------------------------------------->#

ConnectifyMe(){

 # Ping is 3 packets, Grep looks for total failure. This is to give BT some leeway for having shitty ping.
  if ping -c 3 $ip | grep '100% packet loss\|Network is unreachable'
  then
     
	echo "$(date "+%Y-%m-%d %H:%M:%S:") Connection down"

    if iwconfig | grep "BTOpenzone"
    then 
	
	curl 'https://www.btopenzone.com:8443/ante' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-gb,en;q=0.5' -H 'Connection: keep-alive' -H 'Cookie: JSESSIONID=716ri2hfsar64; __utma=171794931.404001753.1385254451.1385254451.1385254451.1; __utmb=171794931.3.10.1385254451; __utmc=171794931; __utmz=171794931.1385254451.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); s_cc=true; s_sq=%5B%5BB%5D%5D' -H 'Host: www.btopenzone.com:8443' -H 'Referer: https://www.btopenzone.com:8443/wpb' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:25.0) Gecko/20100101 Firefox/25.0' -H 'Content-Type: application/x-www-form-urlencoded' --data "username=$username&password=$password&x=0&y=0&xhtmlLogon=https%3A%2F%2Fwww.btopenzone.com%3A8443%2Fante" > /dev/null
	
    else    

   		echo "Restarting Network Service"

		#sudo nmcli nm enable false
		#sudo nmcli nm enable true
		nmcli nm wifi off
		nmcli nm wifi on

		# Disconnect onboard WLAN if my USB is plugged in.
        nmcli dev disconnect iface wlan0


		echo "Connecting to Access Point"
		#nmcli dev wifi connect $essid
		nmcli dev wifi connect $essid iface wlan1

	fi

 else
    echo "$(date "+%Y-%m-%d %H:%M:%S:") Online"
    sleep 3
  fi
}

#<-------------------------------------------------------------------------------->#
DecryptCheck() {

if [ $? -ne 0 ] ; then
rm -f userdata.dat
  echo "Incorrect Password! Please try again!"
sleep 3

DecryptMe
fi
}
#<-------------------------------------------------------------------------------->#
EncryptCheck() {

if [ $? -ne 0 ] ; then

  echo "Encryption Failed! Please try again!"
sleep 3

EncryptMe
fi
}
#<-------------------------------------------------------------------------------->#
EncryptMe(){
clear
echo "The program will now prompt you for a Password to protect your details."
echo "Remember this, otherwise you will have to re-enter your BT credentials!"
echo ""
openssl des3 -salt -in userdata.dat -out userdata.crypt >/dev/null 2>&1
EncryptCheck
rm -f userdata.dat
ConfigCheck
}
#<-------------------------------------------------------------------------------->#
DecryptMe(){
while [ -z "$BTUsername" ]; do #Whilst the script doesn't know your details...
clear
echo "The program will now ask for your password to unlock your details."
echo ""
openssl des3 -d -salt -in userdata.crypt -out userdata.dat 2>/dev/null
DecryptCheck



. ./userdata.dat #Read the settings file
username=$BTUsername #Put the settings
password=$BTPassword #In the scripts memory
rm -f userdata.dat
done
}
#<-------------------------------------------------------------------------------->#
ConfigureMe(){
echo "There is no configuration file present. Obtaining necessary data now."
 
echo "Please enter the username used to log in to OpenZone."
read -p "(Replace the email address @ with %40): " NewUsername
clear
read -sp "Please enter the password used to log in to OpenZone: " NewPassword
echo ""
echo "BTUsername="$NewUsername >> userdata.dat
echo "BTPassword="$NewPassword >> userdata.dat
. ./userdata.dat
username=$BTUsername
password=$BTPassword
echo ""
}
#<-------------------------------------------------------------------------------->#
ConfigCheck(){
clear
if [ -f userdata.crypt ] #If there's an encrypted file,
then

DecryptMe

elif [ -f userdata.dat ] #If there's a decrypted file,
then

EncryptMe



else

ConfigureMe

ConfigCheck
fi
}
#<-------------------------------------------------------------------------------->#
#Package Installer
dep-install(){
 PACKAGE=$1
 if [[ ! -z $YUM_CMD ]]; then
    sudo yum -y install $PACKAGE > /dev/null
 elif [[ ! -z $APT_GET_CMD ]]; then
    sudo apt-get --yes --force-yes install curl $PACKAGE > /dev/null
# elif [[ ! -z $OTHER_CMD ]]; then
#    $OTHER_CMD <proper arguments>
 else
    echo "error: Do not know how to install $PACKAGE"
    exit 1;
 fi
}
#<-------------------------------------------------------------------------------->#
#Dependency Check
dependson(){
if [hash $program 2>/dev/null]; then
        :
    else
        dep-install $1
    fi
}
#<-------------------------------------------------------------------------------->#

#All dependencies are installed here
dependson curl
dependson openssl


ConfigCheck
clear

# Our connectivity Loop
while [ 1 ]; do
ConnectifyMe
done



#<-------------------------------------------------------------------------------->#

