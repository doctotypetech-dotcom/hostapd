sudo apt-get install hostapd dnsmasq -y
cd /tmp
git clone https://git.w1.fi/hostap.git
mkdir temp
cd temp
git clone https://github.com/doctotypetech-dotcom/hostapd.git
cd hostapd
cp fix.h /tmp/hostapd/src/ap/sta_info.h
cd /tmp/hostapd/hostapd
cp defconfig .config
make
mv /usr/sbin/hostapd /usr/sbin/hostapd.bak
sudo cp hostapd /usr/sbin/hostapd
cd /tmp/temp/
sudo rm /etc/dnsmasq.conf
sudo rm /etc/hostapd/hostapd.conf
sudo cp dnsmasq.conf /etc/dnsmasq.conf
sudo cp hostapd.conf /etc/hostapd.conf
echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
sudo iptables -A FORWARD -i eth0 -o wlan0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i wlan0 -o eth0 -j ACCEPT
sudo apt install iptables-persistent
sudo netfilter-persistent save
sudo nano /etc/hostapd/hostapd.conf
