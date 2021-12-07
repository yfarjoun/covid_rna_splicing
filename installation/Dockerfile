FROM ubuntu:18.04

WORKDIR /app

RUN df -h
#from https://github.com/apache/flink/blob/02d30ace69dc18555a5085eccf70ee884e73a16e/tools/azure-pipelines/free_disk_space.sh
COPY installation/free_disk_space.sh .
RUN free_disk_space.sh

RUN df -h 

WORKDIR /home/
# System packages 

RUN apt-get -qq update && apt-get -qq install -y curl git

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -qq update && apt-get -qq install -y vim less unzip libv8-dev

WORKDIR /app/

COPY installation/00-download-reference.sh .
RUN ./00-download-reference.sh 

COPY installation/01-install-conda.sh .
RUN ./01-install-conda.sh

ENV PATH=/root/miniconda/bin:${PATH}

## a change in the environment.yml __should__ invalidate everything after this point.
COPY installation/02-create-env.sh environment/environment.yml .
RUN ./02-create-env.sh

COPY installation/03-post-conda-step.sh .
RUN ./03-post-conda-step.sh

WORKDIR /app

COPY scripts/entrypoint.sh  .

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["Hello project_template user."]

WORKDIR /app/installation
COPY installation/Dockerfile .

WORKDIR /app
