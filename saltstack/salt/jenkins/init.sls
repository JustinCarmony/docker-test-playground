include:
    - common
    - docker.engine

jenkins-group:
    group.present:
        - name: jenkins
        - system: True

jenkins-user:
    user.present:
        - name: jenkins
        - shell: /bin/bash
        - home: /home/jenkins
        - groups:
            - jenkins
        - require:
            - group: jenkins-group

jenkins-ssh-key:
    cmd.run:
        - name: "mkdir /home/jenkins/ssh; ssh-keygen -t rsa -N '' -f /home/jenkins/ssh/id_rsa"
        - unless: "ls /home/jenkins/ssh/id_rsa"
        - require:
            - user: jenkins-user


jenkins-docker-host-home:
    file.directory:
        - name: /var/docker/jenkins_home
        - mode: 755
        - makedirs: True

jenkins-docker-image:
    docker.pulled:
        - name: jenkins
        - tag: latest

jenkins-docker-app-container:
    docker.installed:
        - name: jenkins-app
        - hostname: jenkins-app
        - image: jenkins
        - require:
            - docker: jenkins-docker-image

jenkins-docker-data-container:
    docker.installed:
        - name: jenkins-data
        - hostname: jenkins-data
        - image: jenkins
        - require:
            - docker: jenkins-docker-image

jenkins-docker-app-service:
    docker.running:
        - image: jenkins
        - container: jenkins-app
        - privileged: True
        - ports:
            "8080/tcp":
                HostIp: ""
                HostPort: "8080"
            "50000/tcp":
                HostIp: ""
                HostPort: "50000"
        - volumes_from:
            - jenkins-data
        - require:
            - docker: jenkins-docker-app-container
            - docker: jenkins-docker-data-container
            - file: jenkins-docker-host-home

jenkins-docker-worker-image:
    docker.pulled:
        - name: tehranian/dind-jenkins-slave
        - tag: latest

jenkins-docker-worker-container:
    docker.installed:
        - name: jenkins-worker-app
        - hostname: jenkins-worker-app
        - image: tehranian/dind-jenkins-slave
        - require:
            - docker: jenkins-docker-worker-image

jenkins-docker-worker-service:
    docker.running:
        - image: tehranian/dind-jenkins-slave
        - container: jenkins-worker-app
        - privileged: True
        - ports:
            "50000/tcp":
                HostIp: ""
                HostPort: "50001"
        - require:
            - docker: jenkins-docker-worker-container