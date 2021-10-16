pipeline {
    agent any
    parameters {
        string defaultValue: 'https://github.com/SurenPonnusamy/TomcatMaven', name: 'git_url'
        string defaultValue: 'TomcatMaven', name: 'artifactId'
        string defaultValue: 'TomcatMavenApp', name: 'file'
        string defaultValue: '2.0', name: 'version'
        string defaultValue: 'war', name: 'type'
        string defaultValue: 'com/sarav', name: 'groupId'
        string defaultValue: 'localhost:8081', name: 'nexusUrl'
        string defaultValue: 'nexus3', name: 'nexusVersion'
        string defaultValue: 'java-repo', name: 'repository'
        string defaultValue: 'tomcat-image', name: 'image_name'
        string defaultValue: '1.0.0', name: 'tag_name'
        string defaultValue: 'surendharselvakumar', name: 'docker_repo'
        choice(choices: ['kubernetes' , 'ansible'],description: '',name: 'deploymentType')
    }
    
    environment {
      maven = "/usr/bin/mvn"
    }
    

    stages {
        stage('Clean workspace') {
            steps {
                cleanWs()
            }
        }
        stage('GIT') {
            steps {
                git params.git_url   
            }
        }
        stage ('Build') {
            when {
                expression { params.deploymentType == 'ansible' }
            }
            steps {
                sh '''
                    cd $WORKSPACE/TomcatMavenApp
                    ${maven} clean install
                '''
            }
        }
        stage ('Package') {
            when {
                expression { params.deploymentType == 'ansible' }
            }
            steps {
                sh '''
                    cd $WORKSPACE/TomcatMavenApp
                    ${maven} package
                '''
            }
        }
        stage ('Publish') {
            when {
                expression { params.deploymentType == 'ansible' }
            }
            steps {
                nexusArtifactUploader artifacts: [[artifactId: "${artifactId}", classifier: '', file: "TomcatMavenApp/target/${file}-${version}.${type}", type: "${type}"]], credentialsId: 'nexus_creds', groupId: params.groupId, nexusUrl: "${nexusUrl}", nexusVersion: "${nexusVersion}", protocol: 'http', repository: "${repository}", version: "${version}"
            }
        }
        stage ('Ansible Deployment') {
            when {
                expression { params.deploymentType == 'ansible' }
            }
            steps {
                sh '''
					cd $WORKSPACE/TomcatMavenApp/ansible-war-deployment
					ansible-playbook -i hosts playbook.yml -e target_node=deploy_container
				'''
            }
        }
        stage ('Docker Login') {
            when {
                expression { params.deploymentType == 'kubernetes' }
            }
            steps {
                sh '''
					cd $WORKSPACE/					
					docker login -u surendharselvakumar -p Suren2302%
				'''
            }
        }        
        stage ('Docker build Image') {
            when {
                expression { params.deploymentType == 'kubernetes' }
            }
            steps {
                sh '''
					cd $WORKSPACE/
					docker build --network=host -t ${image_name}:${tag_name} .
					docker tag ${image_name}:${tag_name} ${docker_repo}/${image_name}:${tag_name}
				'''
            }
        }
        stage ('Docker Push Image') {
            when {
                expression { params.deploymentType == 'kubernetes' }
            }
            steps {
                sh '''
					cd $WORKSPACE/
					docker push ${docker_repo}/${image_name}:${tag_name}
				'''
            }
        }
	stage ('Replace tag in yaml file') {
	  when {
	     expression { params.deploymentType == 'kubernetes' }
	  }
	  steps {
		sh '''
				cd $WORKSPACE
				sed -i 's/image-version/${image_name:${tag_name}}/g' tomcat-pod.yml 
		'''
	  }
	}
	
	stage('Deploy yaml in kubernetes') {
	
	  when{
	    expression { params.deploymentType == 'kubernetes' }
	  }
	  steps {
		sh '''
		
		  		cd $WORKSPACE
				kubectl apply -f tomcat-image.yml

		'''		
	  }

	}        
    }
}
