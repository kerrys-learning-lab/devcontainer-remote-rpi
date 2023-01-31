#! /bin/bash

PHASE=$1

for root_dir in ./.devcontainer .; do
  PHASE_FILE=${root_dir}/.dev-lifecycle-scripts.d/${PHASE}.sh
  PHASE_DIR=${root_dir}/.dev-lifecycle-scripts.d/${PHASE}.d

  if [[ -r ${PHASE_FILE} ]]; then
    ${PHASE_FILE}
  elif [[ -d ${PHASE_DIR} ]]; then
    for script in $(ls -1 ${PHASE_DIR}/*.sh | sort); do
      $script
    done
  fi
done