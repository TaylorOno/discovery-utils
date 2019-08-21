#!/bin/bash
set -e

case "$1" in
	'kafka')
		$KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties &
		sleep 5
		$KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
		;;

	*)
		echo "Kafka is not running or configured."
		exec "$@"
		;;
esac