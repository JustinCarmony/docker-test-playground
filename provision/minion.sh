echo "***********************************"
echo "       Provisioning Minion"
echo "***********************************"
echo ""

if ! which salt-minion ; then
    wget -O install_salt.sh https://bootstrap.saltstack.com
    sudo sh install_salt.sh
fi

if diff /vagrant/provision/salt/minion /etc/salt/minion >/dev/null ; then
  echo "/etc/salt/minion is already correct"
else
  echo "/etc/salt/minion needs to be updated"
  cp -f /vagrant/provision/salt/minion /etc/salt/minion
  /etc/init.d/salt-minion restart
fi