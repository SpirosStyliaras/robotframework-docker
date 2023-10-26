#!/bin/bash
# Script to execute Robot test cases

# Print commands and arguments as they are executed.
# Exit immediately if a command exits with a non-zero status.
set -xe

DEFAULT_LOG_LEVEL="INFO"
ROBOT_LOG_LEVEL=${ROBOT_LOG_LEVEL:-$DEFAULT_LOG_LEVEL}

DEFAULT_ROBOT_OPTIONAL_PARAMETERS="--timestampoutputs"
ROBOT_OPTIONAL_PARAMETERS=${ROBOT_OPTIONAL_PARAMETERS:-$DEFAULT_ROBOT_OPTIONAL_PARAMETERS}

if [[ -z ${ROBOT_TESTS} ]];
  then
    echo "[ERROR] Please specify the robot test cases for execution as environment variable ROBOT_TESTS"
    exit 1
fi

if [[ -z ${ROBOT_SUITES} ]];
  then
    echo "[ERROR] Please specify the robot test suites or suites directory for execution as environment variable ROBOT_SUITES"
    exit 1
fi

# Run Robot tests
echo -e "[INFO] Executing robot tests with log level ${ROBOT_LOG_LEVEL}"

export ROBOT_OPTIONS="${ROBOT_OPTIONAL_PARAMETERS}"

# Do not place robot arguments in double quotes, they will be interpreted with single quotes making robot binary to fail
robot --loglevel ${ROBOT_LOG_LEVEL} --outputdir ${ROBOT_LOGS_DIR} \
${ROBOT_VARIABLES} \
${ROBOT_TESTS} \
${ROBOT_SUITES}
