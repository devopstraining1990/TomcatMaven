# TomcatMavenApp
Sample Tomcat Maven App


ssh-keygen -t rsa -> Ansible server
Press enter for file location
Press enter for passphrase
The files have been created under ~/.ssh/id_rsa and ~/.ssh/id_rsa.pub -> Both the files are for the ansible server
Copy the id_rsa.pub file content and place it as the ~/.ssh/authorized_keys file to the remote server
Once the file has been placed to the targeted server. Try ssh with ip alone. Eg ssh 192.168.1.3. This will take u straight into the server/machine which denotes the ssh auth key is set and working fine!
