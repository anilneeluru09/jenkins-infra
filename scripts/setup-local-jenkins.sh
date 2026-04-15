#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOWNLOADS_DIR="$ROOT_DIR/.downloads"
JENKINS_WAR="$DOWNLOADS_DIR/jenkins.war"

mkdir -p "$DOWNLOADS_DIR"

if [ ! -f "$JENKINS_WAR" ]; then
  echo "Downloading latest Jenkins LTS WAR..."
  curl -fsSL -o "$JENKINS_WAR" "https://get.jenkins.io/war-stable/latest/jenkins.war"
fi

echo "Jenkins WAR is ready at $JENKINS_WAR"
