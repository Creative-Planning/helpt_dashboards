FROM public.ecr.aws/docker/library/python:3.12.0

WORKDIR /helpt-dbt
ADD . /helpt-dbt

RUN apt-get update -y
RUN apt-get install -y jq awscli

# Setup DBT & Dependencies
RUN pip install -U pip && \
    pip install --no-cache-dir -r requirements.txt

ENTRYPOINT ["./dbt-runner.sh"]