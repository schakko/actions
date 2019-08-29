FROM debian:stable-slim

LABEL "maintainer"="schakko <me@schakko.de>"
LABEL "repository"="https://github.com/schakko/actions"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="Git meta information"
LABEL "com.github.actions.description"="Export Git meta information into plain files"
LABEL "com.github.actions.icon"="server"
LABEL "com.github.actions.color"="orange"

RUN apt-get update && apt-get install -y \
  git && \
  rm -Rf /var/lib/apt/lists/*


ADD entrypoint.sh /entrypoint.sh


ENTRYPOINT ["/entrypoint.sh"]
