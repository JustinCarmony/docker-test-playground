echo "***********************************"
echo "       Provisioning Master"
echo "***********************************"
echo ""

if ! which salt-master ; then
    wget -O install_salt.sh https://bootstrap.saltstack.com
    sudo sh install_salt.sh -M
fi

cp -f /vagrant/provision/salt/master /etc/salt/master
cp -f /vagrant/provision/salt/minion /etc/salt/minion

ln -s /vagrant/saltstack/salt /srv/salt
ln -s /vagrant/saltstack/pillar /srv/pillar

#/etc/init.d/salt-master restart
#/etc/init.d/salt-minion restart