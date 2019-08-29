FROM debian:stable-slim

LABEL "maintainer"="schakko <me@schakko.de>"
LABEL "repository"="https://github.com/schakko/actions"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="Release new version in WordPress Download Monitor"
LABEL "com.github.actions.description"="Releases a new version in WordPress' Download Monitor plug-in"
LABEL "com.github.actions.icon"="server"
LABEL "com.github.actions.color"="orange"

RUN apt-get update && apt-get install -y &&\
  rm -Rf /var/lib/apt/lists/*


ADD entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
