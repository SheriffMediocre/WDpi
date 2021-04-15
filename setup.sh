#!/bin/bash

  ######################################
 # One time setup script for the WDpi #
######################################



# stops installation if not running as root
if [ $EUID -ne 0 ]; then
	echo "Run as root"
	exit
fi

# change this to where ever you are installing to
installpath=/home/pi/Desktop/WDpi/

# move to install directory
cd $installpath



# LIBCOMPOSITE CONFIG SETUP (USB OTG)

# adds dwc2 to the list of modules to be loaded
echo "dwc2" | sudo tee -a /etc/modules

# adds libcomposite to the list of modules to be loaded
sudo echo "libcomposite" | sudo tee -a /etc/modules

# remove “modules-load=dwc2,g_ether” from /boot/cmdline.txt
sudo sed -i 's/ modules-load=dwc2,g_ether / /g' /boot/cmdline.txt



# DUCKYSCRIPT SETUP

# compile the hid-gadget-test program
gcc hid-gadget-test.c -o hid-gadget-test

# compile the usleep program
make usleep

# make files executeable
chmod 755 hid-gadget-test.c hid-gadget-test usleep.c usleep run.sh usbconfig led

# makes a directory for the user to put payloads into for manual execution
mkdir /home/pi/Desktop/payloads/



# CUSTOMIZATION

# creates/overwrites .bash_profile with new $PS1 prompt variable
sudo touch ~/.bash_profile
echo 'PS1="\[\e[34m\]\u\[\e[m\]\[\e[34m\]@\[\e[m\]\[\e[34m\]\h\[\e[m\]<\[\e[31m\]\w\[\e[m\]> $ "' | sudo tee ~/.bash_profile

# changes password
sudo usermod --password $(openssl passwd -1 "backslashx1b") "pi"

# disables screen blanking (auto sleep)
sudo raspi-config nonint do_blanking 1

# changes the permissions on /etc/motd
sudo chmod +777 /etc/motd

# replaces the motd in /etc/motd
echo -e '\e[31m  Welcome to the WDpi\n#HACKTHEPLANET\n #PWNTHEWORLD' | sudo tee /etc/motd

# moves the awesome ssh motd to the correct location
sudo mv motd2 /etc/motd2

# displays the secondary motd before password prompt in ssh
sudo sed -i 's/#Banner none/Banner \/etc\/motd2/g' /etc/ssh/sshd_config

# disables the "last login" message when opening a new bash session
sudo sed -i 's/#PrintLastLog yes/PrintLastLog no/g' /etc/ssh/sshd_config

# disables the uname message when opening a new bash session
sudo sed -i 's/uname -snrvm/#uname -snrvm/g' /etc/update-motd.d/10-uname



# SETS UP SCRIPTS TO RUN ON BOOT

sudo touch /boot/payload.dd
echo -e 'DELAY 1000\nGUI\nDELAY 250\nGUI SPACE\nDELAY 250\nSTRING github.com/backslashx1b/WDpi\nDELAY 500\nENTER' | sudo tee /boot/payload.dd


# remove "exit 0" from the end of the rc.local file
sed -i '/exit/d' /etc/rc.local

# pastes into the end of /etc/rc.local
cat <<END>>/etc/rc.local

# enables usb gadget with specified config
/home/pi/Desktop/WDpi/usbconfig

# WDpi stuff
cat /boot/payload.dd > /home/pi/Desktop/WDpi/payload.dd
sleep 1
tr -d '\r' < /home/pi/Desktop/WDpi/payload.dd > /home/pi/Desktop/WDpi/payload2.dd
sleep 1

exit 0
END


# FINISHING UP

# sets correct preferences as specified in the prefs file
sudo ./startprefs

# reboot message
echo -e '\e[31m Rebooting in 20 seconds. It might say "sudo: unable to resolve host testing: Temporary failure in name resolution" but it will reboot anyway so you can ignore it\e[0m'

# starts reboot without default message
sudo reboot --no-wall
