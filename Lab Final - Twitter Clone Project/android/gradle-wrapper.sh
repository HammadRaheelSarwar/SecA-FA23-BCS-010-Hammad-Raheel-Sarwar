#!/bin/bash
export JAVA_HOME="C:\Program Files\Java\jdk-25"
cd "$(dirname "$0")/.."
exec ./gradlew "$@"
