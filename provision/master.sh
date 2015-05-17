echo "***********************************"
echo "       Provisioning Master"
echo "***********************************"
echo ""

if ! which salt-master ; then
    wget -O install_salt.sh https://bootstrap.saltstack.com
    sudo sh install_salt.sh -M
fi

ln -s /vagrant/saltstack/salt /srv/salt
ln -s /vagrant/saltstack/pillar /srv/pillar

if diff /vagrant/provision/salt/master /etc/salt/master >/dev/null ; then
  echo "/etc/salt/master is already correct"
else
  echo "/etc/salt/master needs to be updated"
  cp -f /vagrant/provision/salt/master /etc/salt/master
  /etc/init.d/salt-master restart
fi

if diff /vagrant/provision/salt/minion /etc/salt/minion >/dev/null ; then
  echo "/etc/salt/minion is already correct"
else
  echo "/etc/salt/minion needs to be updated"
  cp -f /vagrant/provision/salt/minion /etc/salt/minion
  /etc/init.d/salt-minion restart
fi

echo "0 0,10,14,16,20 * * * root bash /vagrant/provision/twilio/server-checkin" > /etc/cron.d/server-checkin