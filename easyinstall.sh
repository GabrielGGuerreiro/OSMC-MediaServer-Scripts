#adapted from https://discourse.osmc.tv/t/how-to-install-couchpotato-and-sickrage-on-raspberry-pi/10788/1
#!/bin/sh
# Installation script of Sickrage and CouchPotato
sudo apt-get --yes --force-yes update && sudo apt-get --yes --force-yes install git
sudo apt-get --yes --force-yes upgrade
sudo apt-get --yes --force-yes install p7zip-full
sudo wget http://sourceforge.net/projects/bananapi/files/unrar_5.2.6-1_armhf.deb
sudo dpkg -i unrar_5.2.6-1_armhf.deb
sudo rm  unrar_5.2.6-1_armhf.deb
sudo useradd couchpotato
sudo usermod -a -G osmc couchpotato
sudo mkdir /home/couchpotato
sudo chown -R couchpotato:couchpotato /home/couchpotato
sudo git clone http://github.com/RuudBurger/CouchPotatoServer /opt/CouchPotatoServer
sudo chown -R couchpotato:couchpotato /opt/CouchPotatoServer
cd /opt/CouchPotatoServer
sudo cp /opt/CouchPotatoServer/init/couchpotato.service /etc/systemd/system/couchpotato.service
cd  /etc/systemd/system/
sudo sed -i 's@/var/lib/CouchPotatoServer/CouchPotato.py@/opt/CouchPotatoServer/CouchPotato.py@g' couchpotato.service
sudo systemctl enable couchpotato.service
sudo systemctl start couchpotato.service
cd
sudo useradd sickchill
sudo usermod -a -G osmc sickchill
sudo git clone https://github.com/SickChill/SickChill.git /opt/sickchill
sudo cp /opt/sickchill/runscripts/init.systemd /etc/systemd/system/sickchill.service
sudo chown -R sickchill:sickchill /opt/sickchill
sudo chmod +x /opt/sickchill
sudo chmod a-x /etc/systemd/system/sickchill.service
cd /etc/systemd/system
sudo sed -i 's@/usr/bin/python2.7 /opt/sickrage/SickBeard.py -q --daemon --nolaunch --datadir=/opt/sickchill@/opt/sickchill/SickBeard.py -q --daemon --nolaunch --datadir=/opt/sickchill@g' sickchill.service
sudo systemctl enable sickchill.service
sudo systemctl start sickchill.service
sudo service sickchill stop
cd /opt/sickchill/
sudo sed -i 's@web_username = ""@web_username = "osmc"@g' config.ini
sudo sed -i 's@web_password = ""@web_password = "osmc"@g' config.ini
sudo service sickchill start
