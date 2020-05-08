#!/usr/bin/env bash

readonly STACKIFY_HOME="${HOME}/.dpkg/usr/local/stackify"
readonly CONFIG_FILE="${STACKIFY_HOME}/stackify-agent/stackify-agent.conf"
readonly STACKIFY_INSTALL_PATH="${STACKIFY_HOME}"
readonly STACKIFY_AGENT_INSTALL_PATH="${STACKIFY_HOME}/stackify-agent"
readonly STACKIFY_JAVA_EXEC="${STACKIFY_INSTALL_PATH}/.java/latest64bit/bin/java"
readonly STACKIFY_JAVA_OPTS="-XX:+UseSerialGC -Xmx192m"
readonly STACKIFY_JAVA_JAR="${STACKIFY_AGENT_INSTALL_PATH}/stackify-agent.jar"
readonly STACKIFY_JAVA_MAIN_CLASS="com.stackify.agent.AgentMain";
readonly STACKIFY_AGENT_LOG="${STACKIFY_AGENT_INSTALL_PATH}/log/stackify-agent.log"

# update stackify-agent configuration
sed -i 's:^[ \t]*sudoDisabled[ \t]*=\([ \t]*.*\)$:sudoDisabled=true:' ${CONFIG_FILE}
sed -i 's:^[ \t]*containerized[ \t]*=\([ \t]*.*\)$:containerized=true:' ${CONFIG_FILE}

if [ ! -z "$STACKIFY_KEY" ]; then
    echo "STACKIFY_KEY: ${STACKIFY_KEY}"
    sed -i 's:^[ \t]*activationKey[ \t]*=\([ \t]*.*\)$:activationKey='\"${STACKIFY_KEY}\"':' ${CONFIG_FILE}
fi

if [ ! -z "$STACKIFY_ENV" ]; then
    echo "STACKIFY_ENV: ${STACKIFY_ENV}"
    sed -i 's:^[ \t]*environment[ \t]*=\([ \t]*.*\)$:environment='\"${STACKIFY_ENV}\"':' ${CONFIG_FILE}
fi

# set all profilers to use HTTP transport
export STACKIFY_TRANSPORT="agent_http"

# start Stackify Linux Agent in background
export STACKIFY_ROOT_FOLDER="${STACKIFY_HOME}"
cd $STACKIFY_AGENT_INSTALL_PATH
nohup $STACKIFY_JAVA_EXEC $STACKIFY_JAVA_OPTS -cp $STACKIFY_JAVA_JAR $STACKIFY_JAVA_MAIN_CLASS &

# set back to home directory
cd $HOME