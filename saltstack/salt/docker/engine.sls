include:
    - common

docker-py:
    pip.installed:
        - name: docker-py
        - require:
            - sls: common

docker-engine-install:
    cmd.run:
        - name: wget -qO- https://get.docker.com/ | sh
        - unless: which docker
        - require:
            - pip: docker-py

docker-etc-default:
    file.managed:
        - name: /etc/default/docker
        - source: salt://docker/files/etc/default/docker
        - require:
            - cmd: docker-engine-install
        - watch_in:
            - service: docker-service

docker-service:
    service.running:
        - name: docker