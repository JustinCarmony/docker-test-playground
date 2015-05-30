include:
    - common
    - docker.engine

/usr/local/bin/saltevent:
    file.managed:
        - contents:
            #!/bin/bash
            /usr/bin/salt-call event.send "$1" "$2"
        - mode: 755

jenkins-sources-list:
    cmd.run: 
        - name: |
            wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
            echo "" >> /etc/apt/sources.list
            echo "deb http://pkg.jenkins-ci.org/debian binary/" >> /etc/apt/sources.list
            dpkg --configure -a
            apt-get update
        - unless: grep "jenkins" /etc/apt/sources.list

jenkins-package:
    pkg.installed:
        - name: jenkins
        - require:
            - cmd: jenkins-sources-list

jenkins-service:
    service.running:
        - name: jenkins
        - enable: true

jenkins-home:
    file.directory:
        - name: /home/jenkins

jenkins-ssh-key:
    cmd.run:
        - name: "mkdir /home/jenkins/ssh; ssh-keygen -t rsa -N '' -f /home/jenkins/ssh/id_rsa"
        - unless: "ls /home/jenkins/ssh/id_rsa"
        - require:
            - file: jenkins-home