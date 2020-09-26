#!/usr/bin/env groovy

env.KIBANA_APPLICATION_NAME    = 'kibana'
env.KIBANA_APPLICATION_LABEL   = 'kibana'
env.ELASTIC_APPLICATION_NAME   = 'elasticsearch'
env.ELASTIC_APPLICATION_LABEL  = 'elasticsearch'
env.ELASTIC_APPLICATION_CLUSTER = 'es-cluster'
env.FLUENTD_APPLICATION_NAME   = 'fluentd'
env.FLUENTD_APPLICATION_LABEL  = 'fluentd'

env.GIT_BRANCH          = 'master'
env.GIT_REPOSITORY_PATH = "github.com/andyjk15/custom-crypto-${env.KIBANA_APPLICATION_NAME}.git"
env.GIT_REPOSITORY_URL  = "https://${env.GIT_REPOSITORY_PATH}"
env.GITHUB_CREDENTIALS_ID = 'Github'
env.DIGITAL_OCEAN = 'registry.digitalocean.com'
env.DIGITAL_OCEAN_REPO = 'cryptosky-image-registry'
env.DOCKER_BUILDER = 'registry.cryptosky.me'
env.DOCKER_REPOSITORY   = "${env.DIGITAL_OCEAN}/${env.DIGITAL_OCEAN_REPO}"
env.DOCKER_REPOSITORY_TCP = "tcp://${env.DOCKER_BUILDER}:4243"

env.NAMESPACE           = 'kube-logging'
env.SLAVE_LABEL         = "cryptosky-aio-build"

String get_application_version() {
    "1.0.0-b${env.BUILD_NUMBER}"
}

String executeShellScript( String shellPath, String arg1 = '', String arg2 = '', String arg3 = '', String arg4 = '' ) {
    sh "./${shellPath} ${arg1} ${arg2} ${arg3} ${arg4}"
}

try {
    timestamps {
        node ("${env.SLAVE_LABEL}") {
            stage('Initialise') {
                checkout([$class: 'GitSCM', branches: [[name: 'master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'Github', url: env.GIT_REPOSITORY_URL]]])

                env.APPLICATION_VERSION = get_application_version()

                withCredentials(
                        [usernamePassword(
                                credentialsId: 'doctl',
                                passwordVariable: 'DOCTL_TOKEN',
                                usernameVariable: 'DOCTL_USERNAME'
                        )]
                ) {
                    sh "doctl auth init --access-token ${DOCTL_TOKEN}"
                    sh "doctl registry login"
                    sh "doctl kubernetes cluster kubeconfig save cryptosky-cluster"
                }
            }

            stage('Configure Configs') {

                executeShellScript("configuration/scripts/mapVarsToConfigs.sh",
                        env.KIBANA_APPLICATION_NAME,
                        env.KIBANA_APPLICATION_LABEL,
                        env.ELASTIC_APPLICATION_NAME,
                        env.ELASTIC_APPLICATION_LABEL,
                        env.ELASTIC_APPLICATION_CLUSTER,
                        env.FLUENTD_APPLICATION_NAME,
                        env.FLUENTD_APPLICATION_LABEL
                )
            }

            stage('Deploy') {
                executeShellScript("configuration/scripts/deployToKubernetes.sh",
                        env.KIBANA_APPLICATION_NAME,
                        env.ELASTIC_APPLICATION_CLUSTER
                )
            }
        }
    }
} catch ( exception ) {
    currentBuild.result = 'FAILURE'
    throw exception
} finally {
    currentBuild.result = 'SUCCESS'
}
