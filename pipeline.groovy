pipeline {
    agent any
    parameters {
        choice(name: 'Java_version', choices: ['11', '17'], description: 'Choose your Java version')
        string(name: 'USER', defaultValue: 'delivery', description: 'User of the delivery server')
    }

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "M3"
        // Choose Java version
        jdk "jdk${params.Java_version}"
    }

    stages {
        stage('Java_version') {
            steps {
                echo "Choice: ${params.Java_version}"
            }
        }

        stage('Git') {
            steps {
                checkout([
                    $class: 'GitSCM',
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        url: 'git@github.com:matthcol/movieapi2k3.git',
                        credentialsId: '7d7c231c-1f3f-4f36-9ed6-3ef0311ae054'
                    ]]
                ])
                sh "sed -i 's@<java.version>*</java.version>@<java.version>${params.Java_version}</java.version>@' pom.xml"
            }
        }

        stage('Compile') {
            steps {
                sh "mvn clean compile"
            }
        }

        stage('Test') {
            steps {
                sh "mvn test"
            }
            post {
                always {
                    junit '**/target/surefire-reports/TEST-*.xml'
                }
            }
        }

        stage('Package') {
            steps {
                sh "mvn -DskipTests -Dmaven.test.skip package"
            }
            post {
                success {
                    archiveArtifacts 'target/*.jar'
                }
            }
        }

        stage('Delivery') {
            steps {
                script {
                    // Define details of the remote machine
                    def remoteHost = '192.168.121.151'
                    def remoteUser = "${params.USER}"
                    def remotePath = '/home/delivery/stockage/movieapi.jar'

                    // Build the full path of the JAR file
                    def jarFileName = sh(script: 'ls target/*.jar', returnStdout: true).trim()
                    def jarFilePath = "${env.WORKSPACE}/${jarFileName}"

                    // Execute the scp command with the given credentials to transfer the JAR file to the remote machine
                    sh "scp -i /home/projetparis1/.ssh/id_rsa_delivery ${jarFilePath} ${remoteUser}@${remoteHost}:${remotePath}"
                }
            }
        }
    }
}