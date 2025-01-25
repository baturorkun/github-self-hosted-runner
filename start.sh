#!/bin/bash
set -x

if [ ! -d /work ]; then
    echo 'Work dir is NOT exist'
    exit 1
fi

if [ -z "$(ls -A /work)" ]; then
  echo "Copy runner to work!"
  cp -r /runner/* /work/
  echo "Copy done"
fi

cd /work

if [ -f .runner ]; then
    echo 'Run'
    ./run.sh
else
  echo 'Configure'
  ./config.sh --no-default-labels --url $RUNNER_URL --token $RUNNER_TOKEN --name $RUNNER_NAME --work _work --labels $RUNNER_LABELS --replace --unattended
  ln -s /work/_work /runner/work
  echo 'Run'
  ./run.sh
fi