#begin!
dpkg -s cowsay 2>/dev/null >/dev/null || sudo apt-get --yes --force-yes install cowsay > /dev/null
dpkg -s macchanger 2>/dev/null >/dev/null || sudo apt-get --yes --force-yes install macchanger > /dev/null
dpkg -s network-manager 2>/dev/null >/dev/null || sudo apt-get --yes --force-yes install network-manager > /dev/null

interface=$1
newhostname=$RANDOM

if [ $# -eq 0 ]
  then
    echo "No arguments supplied. What interface do you want to randomize?"
    read -p "Please enter the interface: " interface
fi



cowsay R@ndom-a-miz!ng y3r shaniz-b1ts

sudo hostname $newhostname 
echo $newhostname | sudo tee /etc/hostname > /dev/null

sudo nmcli nm enable false
sudo macchanger -A $interface
sudo nmcli nm enable true

cowsay New hostname is $newhostname!

#end!





