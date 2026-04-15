#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
JAVA_SETUP_SCRIPT="$ROOT_DIR/scripts/setup-local-java.sh"
JENKINS_SETUP_SCRIPT="$ROOT_DIR/scripts/setup-local-jenkins.sh"
JAVA_HOME_DIR="$ROOT_DIR/.tools/jdk-current/Contents/Home"
JENKINS_WAR="$ROOT_DIR/.downloads/jenkins.war"
JENKINS_HOME_DIR="${JENKINS_HOME:-$ROOT_DIR/var/jenkins_home}"
JENKINS_WEBROOT_DIR="$ROOT_DIR/var/war"
JENKINS_LOG_DIR="$ROOT_DIR/logs"
JENKINS_HTTP_PORT="${JENKINS_HTTP_PORT:-8080}"

"$JAVA_SETUP_SCRIPT"
"$JENKINS_SETUP_SCRIPT"

mkdir -p "$JENKINS_HOME_DIR" "$JENKINS_WEBROOT_DIR" "$JENKINS_LOG_DIR"

export JAVA_HOME="$JAVA_HOME_DIR"
export PATH="$JAVA_HOME/bin:$PATH"
export JENKINS_HOME="$JENKINS_HOME_DIR"

echo "Starting Jenkins on http://localhost:${JENKINS_HTTP_PORT}"
echo "JENKINS_HOME=$JENKINS_HOME"

exec java -jar "$JENKINS_WAR" \
  --httpPort="$JENKINS_HTTP_PORT" \
  --webroot="$JENKINS_WEBROOT_DIR"
