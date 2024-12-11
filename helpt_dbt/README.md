Helpt DBT ETL Workflow

### Run Locally

- Add connection details in your profiles.yml file
Project Example: `
helpt_dbt:
  outputs:
    dev:
      dbname: helpt_dw
      host: AWS RDS endpoint
      pass: password
      port: 5432
      schema: target_schema
      threads: 4
      type: postgres
      user: dbt_user
  target: dev`

- Run the following cmd to test the connection `dbt debug`

### Set up Docker image

1. Create dbt_user on DB and set AWS Secret with credentials
2. Write/Copy bash script to pull secret, generate profile.yml file and run DBT
    - Make sure to use encodings for the target OS
    - Ej. Transform Windows CRLF to Unix style line terminations
    - SKIPPING can result in the prcoess failing to run the script
    - Alternatively, a python script can handle the secret handling
3. Create Dockerfile to pull dbt code and set entrypoint as bash script
    - Only copy required files or use .dockerignore config to skip env, target and log folders
    - Ensure a correct architecture and minimal base image are used
    - Install req dependencies
    - Separate build and run artifacts if possible
4. Test the build!

### Set up AWS Batch Job

1. Create Elastic Container Registry
- Create ECR and push built Docker image

1. Create IAM Policy with the following permissions (constrain resource access if required):
For Execution:
- Elastic Container Registry : Full List and Read
For Run:
- CloudWatch Logs : Full Access
- Secrets Manager : Full List and Read

2. Create IAM Role for Execution:
- Trusted entity type as "AWS Service" (Allows EC2, Lambda and other services to perform actions)
- Use Case as "Elastic Container Service" with the "Elastic Container Service Task" type selected (Allows ECS tasks to call AWS services on your behalf)
- Attached previously created IAM Policy for execution

Note: optionally, execution and run can be separated roles

3. Create Job components
- Create a Compute Environment
- Create a Job Queue
- Create a Job Definition
    - Make sure to use the previously created ECR repository
    - Use the same cpu architecture as the image
- Test a run! [Why is it stuck in "Runnable"? Check cpu architecture also!](https://stackoverflow.com/a/48706035)

4. Schedule Job run
- Create an Amazon EventBridge Schedule
- Cron for daily at 4am: `0 4 ? * * *`
- Set Target as AWS Batch -> SubmitJob
- Fill in with the target Job arn details, name is custom
- The associated role must have Execution permissions on the target and the AmazonEventBridgeScheduler allowed to assume the role 
The following needs to be addded to the Trust Relationships policy `{
            "Effect": "Allow",
            "Principal": {
                "Service": "scheduler.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }`
