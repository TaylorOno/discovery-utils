#!/bin/bash
set -e

staticConfigFile=/opt/couchbase/etc/couchbase/static_config
restPortValue=8091

function overridePort() {
    portName=$1
    portNameUpper=$(echo ${portName} | awk '{print toupper($0)}')
    portValue=${!portNameUpper}

    # only override port if value available AND not already contained in static_config
    if [[ "$portValue" != "" ]]; then
        if grep -Fq "{${portName}," ${staticConfigFile}
        then
            echo "Don't override port ${portName} because already available in $staticConfigFile"
        else
            echo "Override port '$portName' with value '$portValue'"
            echo "{$portName, $portValue}." >> ${staticConfigFile}

            if [[ ${portName} == "rest_port" ]]; then
                restPortValue=${portValue}
            fi
        fi
    fi
}

function startCouchbase() {
    if [[ "$(whoami)" = "couchbase" ]]; then
        # Ensure that /opt/couchbase/var is owned by user 'couchbase' and
        # is writable
        if [[ ! -w /opt/couchbase/var || $(find /opt/couchbase/var -maxdepth 0 -printf '%u') != "couchbase" ]]; then
            echo "/opt/couchbase/var is not owned and writable by UID 1000"
            echo "Aborting as Couchbase Server will likely not run"
            exit 1
        fi
    fi
    echo "Starting Couchbase Server -- Web UI available at http://<ip>:$restPortValue"
    echo "and logs available in /opt/couchbase/var/lib/couchbase/logs"
    couchbase-server -- -noinput -detached
    while :; do
        curl -s --fail -o /dev/null "http://localhost:8091" && break
        echo "Waiting for Couchbase to start"
        sleep 5
    done
}

function configureDatabase() {

    startCouchbase

    echo "Creating Cluster"
    couchbase-cli cluster-init \
    --cluster-username Administrator \
    --cluster-password password \
    --cluster-ramsize 1024 \
    --services data,index,query,fts
    couchbase-cli node-init \
    -c localhost:8091 \
    -u Administrator \
    -p password \
    --node-init-data-path /opt/couchbase/var/lib/couchbase/data \
    --node-init-index-path /opt/couchbase/var/lib/couchbase/data \
    --node-init-analytics-path /opt/couchbase/var/lib/couchbase/data

    for f in $(ls /initdb/*); do
        echo "found file $f"
        case "$f" in
            *.sh)     echo "[IMPORT] $0: running $f"; . "$f" ;;
        esac
        echo
    done

    echo "Import finished"
    couchbase-server -k
}


overridePort "rest_port"
overridePort "mccouch_port"
overridePort "memcached_port"
overridePort "query_port"
overridePort "ssl_query_port"
overridePort "fts_http_port"
overridePort "moxi_port"
overridePort "ssl_rest_port"
overridePort "ssl_capi_port"
overridePort "ssl_proxy_downstream_port"
overridePort "ssl_proxy_upstream_port"

case "$1" in
	'couchbase-server')
		#Check for mounted database files
		if [[ "$(ls /opt/couchbase/var/lib/couchbase/data 2>/dev/null)" ]]; then
			echo "found files in /opt/couchbase/var/lib/couchbase/data Using them instead of initial database"

		else
			echo "Initializing database."
			configureDatabase
			echo "Couchbase Ready"
		fi
		exec /usr/sbin/runsvdir-start
		;;

	*)
		echo "Database is not configured. Please run '/entrypoint.sh' if needed."
		exec "$@"
		;;
esac