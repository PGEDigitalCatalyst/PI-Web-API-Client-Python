pipeline {
    agent {
        dockerfile {
            label 'kube'
        }
    }

    environment {
        ARTIFACTORY_CREDS = credentials('artifactory-service-account')
        ARTIFACTORY_URL = "https://jfrog.nonprod.pge.com/artifactory/api/pypi/arad-pypi-combined"
    }

    stages {
        stage('Lint') {
            steps {
                sh 'mkdir -p reports'
                sh 'flake8 --ignore=E,W,F --tee --output-file reports/pep8.log'
            }
        }

        stage('Test') {
            steps {
                sh 'mkdir -p reports'
                sh 'py.test --cov=. --cov-report xml:./reports/coverage.xml'
            }
        }

        stage('Deploy') {
            when { anyOf { tag 'release-*' } }
            steps {
                configFileProvider([configFile(fileId: 'artifactory-ssl-certificate', targetLocation: 'artifactory.pem')]) {
                    sh 'python setup.py sdist'
                    sh 'twine upload --repository-url ${ARTIFACTORY_URL} -p ${ARTIFACTORY_CREDS_PSW} -u ${ARTIFACTORY_CREDS_USR} --cert ./artifactory.pem dist/*'
                }
            }
        }
    }
    post {
        always {
            cobertura coberturaReportFile: '**/coverage.xml'
            recordIssues tool: flake8(pattern: 'reports/pep8.log'), failedTotalAll: 1, enabledForFailure: true
        }
    }
}