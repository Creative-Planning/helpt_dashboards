#!/bin/bash

TARGET=${TARGET:-prod}
SECRET=${SECRET:-"psql/helpt-dw/dbt_user"}

PROCESS_TO_RUN=${PROCESS_TO_RUN:-"BUILD"}

function print_info {
    echo "
    Job ID: $AWS_BATCH_JOB_ID
    Job Queue: $AWS_BATCH_JQ_NAME
    Target: $TARGET
    "
}

function create_settings_file {
    echo "Creating config file"
    SECRET=$(aws secretsmanager get-secret-value --secret-id ${SECRET} | jq --raw-output ".SecretString")
    mkdir -p ~/.dbt/
    cat << EOF > ~/.dbt/profiles.yml
helpt_dbt:
  outputs:
    prod:
      dbname: $(echo $SECRET | jq ".db")
      schema: $(echo $SECRET | jq ".schema")
      type: postgres
      host: $(echo $SECRET | jq ".host")
      user: $(echo $SECRET | jq ".user")
      password: $(echo $SECRET | jq ".password")
      port: $(echo $SECRET | jq ".port" | tr -d '"')
  target: prod
EOF
}

function run_dbt_build {
    echo "Running BUILD process"
    dbt seed --target $TARGET
    dbt build --target $TARGET
}

function run_process {
  echo "Running DBT RUN"
  dbt run --target $TARGET
}


print_info
create_settings_file

if [ ${PROCESS_TO_RUN} == "BUILD" ]; then
  run_dbt_build
elif [ ${PROCESS_TO_RUN} == "RUN" ]; then
  run_process
else
  echo "No process to run."
fi
