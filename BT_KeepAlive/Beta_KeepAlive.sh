#!/bin/bash

#Dependency Check
sudo apt-get --yes --force-yes install curl > /dev/null
sudo apt-get --yes --force-yes install openssl > /dev/null

ip=173.194.34.132                   # google.com
essid=BTOpenzone
attempts=1

ConnectifyMe() {
  # 3 Pings, push POST request if 100% loss of connectivity.	
  if ping -c 3 $ip | grep '100% packet loss\|Network is unreachable' ; then    
	echo "$(date "+%Y-%m-%d %H:%M:%S:") Connection down"
    if iwconfig | grep "BTOpenzone" ; then 
	  curl 'https://www.btopenzone.com:8443/ante' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Encoding: gzip, deflate' -H 'Accept-Language: en-gb,en;q=0.5' -H 'Connection: keep-alive' -H 'Cookie: JSESSIONID=716ri2hfsar64; __utma=171794931.404001753.1385254451.1385254451.1385254451.1; __utmb=171794931.3.10.1385254451; __utmc=171794931; __utmz=171794931.1385254451.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); s_cc=true; s_sq=%5B%5BB%5D%5D' -H 'Host: www.btopenzone.com:8443' -H 'Referer: https://www.btopenzone.com:8443/wpb' -H 'User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:25.0) Gecko/20100101 Firefox/25.0' -H 'Content-Type: application/x-www-form-urlencoded' --data "username=$username&password=$password&x=0&y=0&xhtmlLogon=https%3A%2F%2Fwww.btopenzone.com%3A8443%2Fante" > /dev/null
    else    
   		echo "Restarting Network Service"

		# The following code I might get rid of. It is useful if you
		# have more than one wireless NIC, as this next part resolves
		# a hardware conflict.
		# Comment it back in if you also use two NICS.

		# sudo nmcli nm enable false
		# sudo nmcli nm enable true
		# nmcli nm wifi off
		# nmcli nm wifi on
		# Disconnect onboard WLAN if my USB is plugged in.
        # nmcli dev disconnect iface wlan0

		echo "Connecting to Access Point"
        #nmcli dev wifi connect $essid
		nmcli dev wifi connect $essid iface wlan1
	fi
  else
    echo "$(date "+%Y-%m-%d %H:%M:%S:") Online"
    sleep 3
  fi
}

DecryptCheck() {
  if [ $? -ne 0 ] ; then
	rm -f .userdata.dat
	clear
	echo "Incorrect Password! Please try again!"
	echo "Attempt: $attempts"
	sleep 2
	((attempts++))
	if [ $attempts == 3 ] ; then
	   echo "If you have forgotten your password, run this script again
	         with 'new-details' and you can add your information again";
	   attempts=1
	   sleep 3
	fi
	DecryptMe
  fi	
}

EncryptCheck() {
  if [ $? -ne 0 ] ; then
    echo "Encryption Failed! Please try again!"
    sleep 3
    EncryptMe
  fi
}

EncryptMe() {
  clear
  echo "The program will now prompt you for a Password to protect your details."
  echo "Remember this, otherwise you will have to re-enter your BT credentials!"
  echo ""
  openssl des3 -salt -in .userdata.dat -out .userdata.crypt >/dev/null 2>&1
  EncryptCheck
  rm -f .userdata.dat
  ConfigCheck
}

DecryptMe() {
  # NTS: '$1' == password from second argument. 
  sleep 2
  while [ -z "$BTUsername" ]; do    #Whilst the script doesn't know your details...
    clear
    echo "The program will now ask for your password to unlock your details."
    echo ""
    # Insert pasword here...
    openssl des3 -d -salt -in .userdata.crypt -out .userdata.dat 2>/dev/null
    DecryptCheck
    . ./.userdata.dat               #Read the settings file
    username=$BTUsername            #Put the settings
    password=$BTPassword            #In the scripts memory
    rm -f .userdata.dat
  done
}

ConfigureMe() {
  echo "There is no configuration file present. Obtaining necessary data now."
  echo "Please enter the username used to log in to OpenZone."
  read -p "(Replace the email address @ with %40): " NewUsername
  clear
  read -sp "Please enter the password used to log in to OpenZone: " NewPassword
  echo ""
  echo "BTUsername="$NewUsername >> .userdata.dat
  echo "BTPassword="$NewPassword >> .userdata.dat
  . ./.userdata.dat
  username=$BTUsername
  password=$BTPassword
  echo ""
}

ConfigCheck(){
  clear
  if [ -f .userdata.crypt ] ; then   #If there's an encrypted file,
    DecryptMe
  elif [ -f .userdata.dat ] ; then  #If there's a decrypted file,
    EncryptMe
  else
    ConfigureMe
    ConfigCheck
  fi
}

main() {
  ConfigCheck
  clear
  # Our connectivity Loop
  while [ 1 ]; do
    ConnectifyMe
  done
}

if [ $# -eq 0 ] ; then
  main
elif [ $1 == "new-details" ] ; then
  echo "Deleting old entries..."
  sleep 2
  rm .userdata.crypt
  main
elif [ $1 == "pass" ] ; then
  DecryptMe $2
elif [ $1 == "help" ] ; then
  echo "new-details     - deletes existing data, allows you to start again"
  echo "pass [password] - enter password as option, useful when running this script at boot"
  echo "help            - display this"
fi


