#!/bin/bash

sed -i 's/image-version/$1/g' tomcat-pod.yml

cat tomcat-pod.yml
