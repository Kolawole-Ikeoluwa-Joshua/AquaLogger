#!/bin/sh

# this simulates an application with fluentd library installed
# which sends logs over to fluentd
while true
do
	echo "Sending logs to FluentD"
  curl -X POST -d 'json={"foo":"bar"}' http://fluentd:9880/http-myapp.log
	sleep 5
done