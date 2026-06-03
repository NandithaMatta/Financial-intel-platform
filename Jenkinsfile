pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = 'us-east-1'
        VENV_PATH = '/var/jenkins_home/dbt-venv'
        WORKSPACE_DIR = '/var/jenkins_home/workspace/Financial-intel-platform'
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        stage('Install Dependencies') {
            steps {
                sh '''
                    python3 -m venv $VENV_PATH
                    $VENV_PATH/bin/pip install --upgrade pip --quiet
                    $VENV_PATH/bin/pip install dbt-athena-community --quiet
                    $VENV_PATH/bin/dbt --version
                '''
            }
        }
        stage('Configure DBT Profile') {
            steps {
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
                sh '$VENV_PATH/bin/dbt debug --project-dir $WORKSPACE_DIR/workforce_intel_platform --profiles-dir ~/.dbt'
            }
        }
        stage('DBT Build') {
            steps {
                sh '$VENV_PATH/bin/dbt build --project-dir $WORKSPACE_DIR/workforce_intel_platform --profiles-dir ~/.dbt'
            }
        }
        stage('DBT Test') {
            steps {
                sh '$VENV_PATH/bin/dbt test --project-dir $WORKSPACE_DIR/workforce_intel_platform --profiles-dir ~/.dbt'
            }
        }
        stage('DBT Docs Generate') {
            steps {
                sh '$VENV_PATH/bin/dbt docs generate --project-dir $WORKSPACE_DIR/workforce_intel_platform --profiles-dir ~/.dbt'
            }
        }
    }
    post {
        success { echo '✅ Pipeline completed successfully!' }
        failure { echo '❌ Pipeline failed!' }
    }
}
