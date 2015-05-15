echo "***********************************"
echo "       Provisioning Minion"
echo "***********************************"
echo ""

if ! which salt-minion ; then
    wget -O install_salt.sh https://bootstrap.saltstack.com
    sudo sh install_salt.sh
fi

cp -f /vagrant/provision/salt/minion /etc/salt/minion

#/etc/init.d/salt-minion restart