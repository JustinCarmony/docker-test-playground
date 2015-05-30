include:
    - common
    - docker.engine

host-test-app-image:
    docker.pulled:
        - name: master:5000/docker-test-app
        - tag: master
        - insecure_registry: True
        - force: True
        - require:
            - sls: docker.engine
        - watch_in:
            - docker: host-test-app-service
            - cmd: host-test-app-remove

host-test-app-container:
    docker.present:
        - name: host-test-app
        - image: master:5000/docker-test-app:master
        - require:
            - docker: host-test-app-image

host-test-app-remove:
    cmd.wait:
        - name: "docker stop host-test-app; docker rm host-test-app"

host-test-app-service:
    docker.running:
        - image: master:5000/docker-test-app:master
        - container: host-test-app
        - ports:
            "80/tcp":
                HostIp: ""
                HostPort: "80"
        - require:
            - docker: host-test-app-container
            - cmd: host-test-app-remove