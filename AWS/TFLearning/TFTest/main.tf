pipeline{
  agent any
  tools {
    terraform 'TerraFormV14'
}

stages {
  stage('Checkout external proj') {
steps {
git branch: 'master',
credentialsId: 'godfrey-git-cred',
url: 'https://github.com/godfreym1978/TerraForm/'
}
}
stage('Run Terraform') {
steps {

dir("AWS\\TFLearning\\SingleInstance"){
powershell label: '', script: 'terraform init '
powershell label: '', script: 'terraform plan '
powershell label: '', script: 'terraform apply -auto-approve'

}
}
}

}
}
