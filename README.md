## WDpi

<b> If you need a more detailed explanation of the installation, check out my instructable [here](http://instructables.com/The-WDpi-a-10-Pentesting-Multi-tool/)
These instructions assume you are working from a computer with a 'nix terminal.</b>


1. You will need an SD card flashed with a fresh copy of Raspberry Pi OS

2. Before inserting the SD card into the Raspberry Pi, unplug it from the computer and then plug it back in again.
This will remount the disk so you can access the boot partition.

3. Move to the main directory of the SD card. Make a new text file with no extension called "ssh" by running <code> touch ssh </code>

4. Add <b> dtoverlay=dwc2 </b> to the end of config.txt by running <code> echo "dtoverlay=dwc2" >> config.txt </code>

5. Add <b> modules-load=dwc2,g_ether </b> to cmdline.txt right after rootwait with a single space before and after.
The spacing and spelling on this file is very important and if anything is spelled or spaced incorrectly the Pi will not boot.
When you are done it should look something like the below.
<code> </code>

6. (Optional) Optionally you can set up wifi on first boot but this is not needed as you will be able to ssh into the WDpi over usb. If you want to do this, read the tutorial here.
https://www.raspberrypi.org/documentation/configuration/wireless/headless.md

7. Eject the SD card from the computer and insert it into the Pi. Plug one end of a micro usb data cable into the port on the Pi that is usually used for connecting usb peripherals.
Plug the other end of the cable into the computer you are using and then wait about 2 minutes for the Pi to fully boot up.

8. Run <code> lsusb </code> in your terminal and check the results. If you see something like this -- ID 0525:a4a2 PLX Technology, Inc. RNDIS/Ethernet Gadget -- then your are good to go on.
If you do not see anything like that, wait a minute, then run <code> lsusb </code> again. If you still do not see it showing up then check the cable you are using.

9. Run <code> ssh pi@raspberrypi.local </code> to connect to the Pi with the default password <code style="color:purple;"> raspberry </code>.

10. Move to the ~/Desktop directory with <code> cd ~/Desktop/ </code>.

11. Copy the code for the WDpi from GitHub with <code> git clone http://github.com/backslashx1b/WDpi/ </code>

12. Move into the ~/Desktop/WDpi directory with <code> cd ~/Desktop/WDpi/ </code>

13. Run the one time installation script with <code> sudo ./setup.sh </code>

14. Restart the WDpi with <code> sudo reboot </code>




And that's it. (<b>whew</b>) you can now ssh into the WDpi by running <code> ssh pi@wdpi.local </code> with the password <code> backslashx1b </code>




#### The features implemented into the WDpi and their uses are below.

##### 1. DuckyScript ability (main reason for the entire project)
If automatically running a DuckyScript at start is enabled (see below), you will need to make a plain text file and put your script into it. Rename the script as payload.dd and place it in the /boot/ partition.
You can access this partition easily by inserting the WDpi SD card into a computer.
If you would like to manually execute a DuckyScript then move to the ~/Desktop/WDpi/ directory and run <code> sudo ./run.sh /path/to/duckyscript.dd </code>. 
When you manually execute a DuckyScript you can execute any duckyscript with any name as long as it is plain text.


##### 2. Preferences Script
To easily change preferences for the WDpi, <b>look in the prefs file</b>. There are only a couple preferences you can change from this file right now but more options will be added later.
When you are done editing the prefs to your liking, save it and then run the startprefs script to put them into effect.

If you would like a ducky script to run when the WDpi boots up then set $startupscript to 1. If you would like this feature turned off then set it to 0. The default is <code> export startupscript=1 </code>
For whatever reason you could possibly have for wanting to do so... You can change the hostname of the WDpi by changing the value of $hostname to whatever you want. The default is <code> export hostname=WDpi </code>


Thanks to @ossiozac for the [DuckBerry Pi](https://github.com/ossiozac/Raspberry-Pi-Zero-Rubber-Ducky-Duckberry-Pi) project. Without it, the WDpi would not have come out until about 2025.
