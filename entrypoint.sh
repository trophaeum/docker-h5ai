#!/bin/bash -xe

function populate_config() {
  jq "map(if .ParameterKey == \"$1\"
          then . + {\"ParameterValue\":\"$2}
          else .
          end)"
}

function h5ai_config() {
  file=$1

  php5 /root/minify.php

  jq -r $file
}

if [ -z "$SKIP_CFG" ]; then
  h5ai_cfg /usr/share/h5ai/_h5ai/private/conf/options.json
fi

supervisord -c /etc/supervisor/conf.d/supervisord.conf

