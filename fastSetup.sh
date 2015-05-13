

echo "Cleaning up previous logs"

rm -rf ./log
mkdir ./log

MAX_PROCS=5

parallel_up() {
    while read box; do
        echo "Spinning up '$box'. Output will be in: log/$box.out.txt" 1>&2
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        sh -c 'vagrant up BOXNAME >log/BOXNAME.out.txt 2>&1 || echo "Error Occurred: BOXNAME"'
}
 
parallel_provision() {
    while read box; do
        echo "Provisioning '$box'. Output will be in: log/$box.out.txt" 1>&2
        echo $box
    done | xargs -P $MAX_PROCS -I"BOXNAME" \
        sh -c 'vagrant provision BOXNAME >log/BOXNAME.out.txt 2>&1 || echo "Error Occurred: BOXNAME"'
}

vagrant status --machine-readable | egrep --color=no '\,state\,' | awk 'BEGIN { FS = "," } ; { print $2 }' | parallel_up

vagrant hostmanager

#vagrant status --machine-readable | egrep --color=no '\,state\,' | awk 'BEGIN { FS = "," } ; { print $2 }' | parallel_provision

sleep 5

vagrant ssh master -c "sudo salt-key -A --yes"

# Call state.highstate on master
echo "Calling Highstate on Master"
vagrant ssh master -c "sudo salt-call state.highstate"

echo "Calling Highstate on All Servers"
vagrant ssh master -c "sudo salt \* state.highstate"