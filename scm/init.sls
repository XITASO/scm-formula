{% from "scm/map.jinja" import scm with context %}

include:
  - java
  - .repo

scm-manager:
  pkg.installed:
    - name: scm-server
    - fromrepo: scm-releases
    - require:
      - pkgrepo: scm-manager-repo

  module.wait:
    - name: service.systemctl_reload
    - watch:
      - pkg: scm-manager

  service.running:
    - name: scm-server
    - enable: True
    - require:
      - pkg: scm-manager
    - watch:
      - file: scm-manager-config
      - file: scm-manager-config-java

scm-manager-config-java:
  file.replace:
    - name: /etc/default/scm-server
    - pattern: ^#?[ \t]*JAVA_HOME=.*$
    - repl: 'JAVA_HOME="{{ scm.config.JAVA_HOME }}"'
    - require:
      - pkg: scm-manager

scm-manager-config:
  file.managed:
    - name: /opt/scm-server/conf/server-config.xml
    - source: salt://scm/files/server-config.xml
    - mode: 644
    - user: root
    - group: root
    - template: jinja
    - defaults:
        config: {{ scm.config|json }}
    - require:
      - pkg: scm-manager
