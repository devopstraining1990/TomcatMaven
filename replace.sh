#!/bin/bash

sed -i 's/image-version/$1/g' tomcat-pod.yml

sed -i 's/tag-version/$2/g' tomcat-pod.yml

cat tomcat-pod.yml
