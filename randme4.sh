#begin!

interface=$1
newhostname=$RANDOM

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. What interface do you want to randomize?"
    read -p "Please enter the interface: " interface
fi

sudo apt-get --yes --force-yes install cowsay macchanger network-manager > /dev/null

cowsay R@ndom-a-miz!ng y3r shaniz-b1ts

sudo hostname $newhostname 
echo $newhostname | sudo tee /etc/hostname > /dev/null

sudo nmcli nm enable false
sudo macchanger -A $interface
sudo nmcli nm enable true

cowsay New hostname is $newhostname!

#end!





