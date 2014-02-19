#!/bin/sh

#Dependency Check
#sudo apt-get --yes --force-yes install curl > /dev/null
#sudo apt-get --yes --force-yes install nmcli > /dev/null

ip=173.194.34.132 # google.com
username=username%40btinternet.com
password=password1234
essid=BTOpenzone

# Our connectivity Loop
while [ 1 ]; do

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
		nmcli dev wifi connect $essid iface wlan2

	fi

 else
    echo "$(date "+%Y-%m-%d %H:%M:%S:") Online"
    sleep 3
  fi
done
