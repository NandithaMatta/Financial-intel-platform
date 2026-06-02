pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        DBT_PROJECT_DIR = 'workforce_intel_platform'
        VENV_PATH = '/var/jenkins_home/dbt-venv'
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                echo 'Setting up Python virtual environment and installing DBT...'
                sh '''
                    python3 -m venv $VENV_PATH
                    $VENV_PATH/bin/pip install --upgrade pip
                    $VENV_PATH/bin/pip install dbt-athena-community
                    $VENV_PATH/bin/dbt --version
                '''
            }
        }

        stage('Configure DBT Profile') {
            steps {
                echo 'Setting up DBT profile...'
                sh '''
                    mkdir -p ~/.dbt
                    cat > ~/.dbt/profiles.yml << PROFILE
workforce_intel_platform:
  outputs:
    dev:
      type: athena
      database: awsdatacatalog
      region_name: us-east-1
      s3_staging_dir: s3://workforce-intel-platform-wip01/athena-results/
      s3_data_dir: s3://workforce-intel-platform-wip01/curated/
      schema: wip_analytics
      work_group: workforce-intel-platform
      threads: 1
  target: dev
PROFILE
                '''
            }
        }

        stage('DBT Debug') {
            steps {
                echo 'Validating DBT connection...'
                sh '''
                    cd ${DBT_PROJECT_DIR}
                    $VENV_PATH/bin/dbt debug
                '''
            }
        }

        stage('DBT Build') {
            steps {
                echo 'Building DBT models...'
                sh '''
                    cd ${DBT_PROJECT_DIR}
                    $VENV_PATH/bin/dbt build
                '''
            }
        }

        stage('DBT Test') {
            steps {
                echo 'Running DBT tests...'
                sh '''
                    cd ${DBT_PROJECT_DIR}
                    $VENV_PATH/bin/dbt test
                '''
            }
        }

        stage('DBT Docs Generate') {
            steps {
                echo 'Generating DBT documentation...'
                sh '''
                    cd ${DBT_PROJECT_DIR}
                    $VENV_PATH/bin/dbt docs generate
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed! Check the logs above for errors.'
        }
        always {
            echo 'Pipeline finished - workforce-intel-platform'
        }
    }
}