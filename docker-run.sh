#!/bin/bash

docker run -di -P -p 0.0.0.0:5672:5672 -p 0.0.0.0:8161:8161 -t activemq-5.12.0
