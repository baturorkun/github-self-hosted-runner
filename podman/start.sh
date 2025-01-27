#!/bin/bash
set -x

if [ ! -d /workspace ]; then
    echo 'Work dir is NOT exist'
    exit 1
fi

if [ -z "$(ls -A /workspace)" ]; then
  echo "Copy runner to workspace!"
  cp -r /runner/* /workspace/
  echo "Copy done"
fi

cd /workspace

if [ -f .runner ]; then
    echo 'Run'
    RUNNER_ALLOW_RUNASROOT=true ./run.sh
else
  echo 'Configure'
   RUNNER_ALLOW_RUNASROOT=true ./config.sh --no-default-labels --url $RUNNER_URL --token $RUNNER_TOKEN --name $RUNNER_NAME --work _work --labels $RUNNER_LABELS --replace --unattended
   #ln -s /workspace/_work /runner/work
   echo 'Run'
   RUNNER_ALLOW_RUNASROOT=true ./run.sh
fi