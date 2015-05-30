base:
    '*':
        - common
        - docker.engine
    'master':
        - docker.registry
    'jenkins':
        - jenkins
    'host*':
        - host