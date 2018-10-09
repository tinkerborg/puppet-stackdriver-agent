#!/bin/bash

CENTOS=$(rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release))

if [ "$CENTOS" == "6" ]; then
  PYBIN="/usr/bin/scl enable python27 -- python - "
fi
if [ "$CENTOS" == "7" ]; then
  PYBIN="/usr/bin/python - "
fi

pipe_in=$(</dev/stdin)

$PYBIN $@ << EOF

from google.cloud import monitoring_v3

import time
import argparse
import time
import os
import sys

shell_input="""${pipe_in}"""

parser = argparse.ArgumentParser(description='Ship custom metrics directly to StackDriver')
client = monitoring_v3.MetricServiceClient()

parser.add_argument('-p', '--project', help="Project for StackDriver Metric", required=True)
parser.add_argument('-c', '--custom', help="Example: custom.googleapis.com/example_top_level/metric1", required=True)
parser.add_argument('-t', '--restype', help="Examples: gce_instance, global", required=True)
parser.add_argument('-z', '--zone', help="Examples: us-east1-b", required=True)
parser.add_argument('-i', '--id', help="Instance ID", required=True)

args = parser.parse_args()

project_name = client.project_path(args.project)

series = monitoring_v3.types.TimeSeries()

series.resource.labels['instance_id'] = args.id
series.resource.labels['zone'] = args.zone
series.resource.type = args.restype
series.metric.type = args.custom

# Get values from stdin piped value
point = series.points.add()
point.value.double_value = float(shell_input)

now = time.time()
point.interval.end_time.seconds = int(now)
point.interval.end_time.nanos = int(
    (now - point.interval.end_time.seconds) * 10**9)

client.create_time_series(project_name, [series])

print "Successfully wrote time series. %s %d" % (series.metric.type, point.value.double_value)

EOF
