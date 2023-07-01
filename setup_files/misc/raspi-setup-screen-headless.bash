


echo ------
echo Setup screen for Raspberry
echo ------
echo Setup screen: update and upgrade
sudo apt-get update && sudo apt-get upgrade -y

echo Setup screen: Install git
sudo apt-get install git -y

echo Setup screen: Load repository
sudo git clone https://github.com/goodtft/LCD-show.git

echo Setup screen: Change permissions
sudo chmod -R 755 LCD-show

echo Setup screen: Execute LCD-show
cd LCD-show/
sudo ./LCD35-show