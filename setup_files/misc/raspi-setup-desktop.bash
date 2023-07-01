echo ------
echo Switch from lite to desktop version
echo ------
echo Switch to deskop: update and upgrade
sudo apt-get update && sudo apt-get upgrade -y

echo Switch to deskop: Install raspberrypi-ui-mods
sudo apt-get install raspberrypi-ui-mods

echo Switch to deskop: Adjust the display setting
echo Backup actual setting:
echo sudo cp /boot/config.txt /boot/config.txt.bak
echo Get actual resolution
echo xdpyinfo | grep dimensions

echo Switch to deskop: reboot
sudo reboot
