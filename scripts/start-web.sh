#!/usr/bin/env bash

get_env="${1:-staging}"

if [ "$get_env" != "staging" ] || [ "$get_env" != "production" ]; then
  echo "invalid environment!"
  exit 1
fi

cp /secrets/azkaban-properties/azkaban.properties /azkaban/conf
cp /secrets/azkaban-users-xml/azkaban-users.xml /azkaban/conf
/scripts/wait_for_port_ready.py 3306 30 $get_env
/azkaban/bin/start-web.sh
/scripts/wait_for_port_ready.py 8081 45 $get_env
/scripts/reload_exec.py local
tail -f /azkaban/webServerLog_*