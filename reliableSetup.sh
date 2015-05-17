#!/bin/bash

# Deploy the vagrant boxes, but don't deploy them yet.
vagrant up --no-provision

# Setup the hosts file for all the servers
vagrant hostmanager

# Install Salt & correct configs
vagrant provision

# Wait 5 seconds for the minions to connect to the master
sleep 5

# Accept the keys on the master
vagrant ssh master -c "sudo salt-key -A --yes"

# There is a bug with 2 minions running after the bootstrap installs them
# lets go ahead and do a restart on all the servers

vagrant ssh master -c 'sudo salt \* cmd.run "shutdown -r 0"'

# Wait for the servers to be back online
sleep 60

# See which servers are online
vagrant ssh master -c "sudo salt \* test.ping"

# Run Highstate on all of the servers :)
echo "Calling Highstate on All Servers"
vagrant ssh master -c "sudo salt \* state.highstate"