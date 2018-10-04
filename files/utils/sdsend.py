#!/bin/python

from google.cloud import monitoring_v3

import time
import argparse
import time
import os
import sys

for line in sys.stdin:
  shell_input = int(line.strip())

parser = argparse.ArgumentParser(description='Ship custom metrics directly to StackDriver')
client = monitoring_v3.MetricServiceClient()

parser.add_argument('-p', '--project', help="Project for StackDriver Metric", required=True)
parser.add_argument('-c', '--custom', help="Example: custom.googleapis.com/example_top_level/metric1", required=True)

args = parser.parse_args()

project_name = client.project_path(args.project)

series = monitoring_v3.types.TimeSeries()
#series.metric.type = 'custom.googleapis.com/testmetric/metric1'
series.metric.type = args.custom

# Get values from stdin piped value
point = series.points.add()
point.value.double_value = shell_input

now = time.time()
point.interval.end_time.seconds = int(now)
point.interval.end_time.nanos = int(
    (now - point.interval.end_time.seconds) * 10**9)

client.create_time_series(project_name, [series])

print "Successfully wrote time series. %s %d" % (series.metric.type, point.value.double_value)
