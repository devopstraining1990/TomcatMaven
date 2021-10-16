#!bin/bash

sed -i 's/image-version/$1:$2/g' tomcat-pod.yml

cat tomcat-pod.yml
