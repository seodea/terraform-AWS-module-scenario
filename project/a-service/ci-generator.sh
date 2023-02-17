#!/bin/bash
dir=$(find . -maxdepth 2 -type d)

for folder in $dir
do
if [ -e "$(find $folder -name '*.tfvars')" ]
then

cat << EOF > $folder/.gitlab-ci.yml
.terraform-init: &terraform-init-module
  - cd \${TF_DIR}
  - terraform init -reconfigure -get=true -upgrade

.common-feature: &common-feature
  # only:
  #   refs:
  #     - main
  allow_failure: false
  tags :
   - sdh-test-runner

.use-cache: &global_cache
  cache:
    - key: terraform
      paths:
        - \${TF_DIR}.terraform
      policy: pull-push


# For Example

before-script: &before-script
  - echo "Execute this script first"
  - sleep 5

.main-script: &main-script
  - echo "Execute this script second"
  - echo "Execute this script too"

.after-script: &after-script
  - echo "Execute this script last"
  - sleep 5
    

###############
# 공통 변수 값 설정
###############

variables:
  TF_DIR : "$folder"
  TAGS   : "sdh-test-runner"

###############
# CI Pipeline
###############

stages:
  - refresh
  - validate
  - plan
  - apply
  - destroy-plan
  - destroy

.refresh:
  stage: refresh
  <<: *common-feature
  <<: *global_cache
  
  before_script:
    - *terraform-init-module
  script:
    - terraform refresh
  when: manual
  
  # allow_failure: false
  # only:
  #   refs:
  #     - main
  # tags:
  #   - '${TAGS}'

validate:
  stage: validate
  <<: *common-feature
  <<: *global_cache

  before_script:
    - *terraform-init-module
    - env
    - pwd
  script:
    - echo "$folder terraform validate"
    - terraform validate
  after_script:
    - ls \${TF_DIR}/.terraform
  
  # tags:
  #   - '${TAGS}'

plan:
  stage: plan
  <<: *common-feature
  <<: *global_cache

  before_script:
    - *terraform-init-module
    - terraform version
  script :
   - |
    echo "$folder terraform plan"
    terraform plan -refresh=false -out=planfile 
  after_script:
    - ls \${TF_DIR}/.terraform
    - pwd
  dependencies:
    - validate
  artifacts:
    paths:
      - \${TF_DIR}/planfile
  
  # tags:
  # - '${TAGS}'

.apply:
  stage: apply
  <<: *common-feature
  <<: *global_cache
  before_script:
    - *terraform-init-module
  script:
    - terraform apply planfile
  dependencies:
    - plan
  when: manual

.destroy-plan:
  stage: destroy-plan
  <<: *common-feature
  <<: *global_cache
  before_script:
    - *terraform-init-module
  script:
    - terraform plan -destroy

.destroy:
  stage: destroy
  <<: *common-feature
  <<: *global_cache
  before_script:
    - *terraform-init-module
  script:
    - terraform destroy -auto-approve
  needs:
    - destroy-plan
  when: manual
EOF

fi
done