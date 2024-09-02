#!/usr/bin/env bash

get_env="${1:-staging}"

if [ "$get_env" != "staging" ] || [ "$get_env" != "production" ]; then
  echo "invalid environment!"
  exit 1
fi

cp /secrets/azkaban-properties/azkaban.properties /azkaban/conf
cp /secrets/azkaban-users-xml/azkaban-users.xml /azkaban/conf
/scripts/wait_for_port_ready.py 3306 15 $get_env
/azkaban/bin/start-exec.sh
/scripts/wait_for_port_ready.py 12321 15 $get_env
/scripts/executor_action.py activate
/scripts/reload_exec.py
tail -f /azkaban/executorServerLog_*