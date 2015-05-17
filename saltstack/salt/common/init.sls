common-packages:
    pkg.installed:
        - names:
            - htop
            - strace
            - git-core
            - vim
            - curl
            - python-setuptools
    pip.installed:
        - names:
            - docker-py
        - require:
            - pkg: common-packages

common-removed-packages:
    pkg.removed:
        - names:
            - python-pip

common-pip-install:
    cmd.run:
        - name: easy_install -U pip
        - unless: which pip
        - require:
            - pkg: common-packages
            - pkg: common-removed-packages

common-salt-minion:
    pkg.installed:
        - name: salt-minion
    service.running:
        - name: salt-minion

common-etc-default-salt-minion:
    file.managed:
        - name: /etc/default/salt-minion
        - watch_in:
            - service: salt-minion
