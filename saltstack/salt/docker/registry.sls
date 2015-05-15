include:
    - common
    - docker.engine

docker-registry-image:
    docker.pulled:
        - name: registry
        - tag: 2.0
        - require:
            - sls: docker.engine

docker-registry-app-container:
    docker.installed:
        - name: registry-app
        - hostname: registry-app
        - image: registry:2.0
        - require:
            - docker: docker-registry-image

docker-registry-data-container:
    docker.installed:
        - name: registry-data
        - hostname: registry-data
        - image: registry:2.0
        - require:
            - docker: docker-registry-image

docker-registry-app-service:
    docker.running:
        - image: registry:2.0
        - container: registry-app
        - ports:
            "5000/tcp":
                HostIp: ""
                HostPort: "5000"
        - volumes_from:
            - registry-data
        - require:
            - docker: docker-registry-app-container
            - docker: docker-registry-data-container

