FROM ubuntu:18.04

WORKDIR /home/
# System packages 
RUN apt-get -qq update && apt-get -qq install -y curl git 

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get -qq update && apt-get -qq install -y vim less unzip libv8-dev

WORKDIR /app/

COPY installation/01-install-conda.sh .
RUN ./01-install-conda.sh

ENV PATH=/root/miniconda/bin:${PATH}

COPY installation/02-create-env.sh environment/environment.yml .

RUN ./02-create-env.sh

# RUN conda init bash

COPY installation/03-post-conda-step.sh .
RUN ./03-post-conda-step.sh

WORKDIR /app

COPY scripts/entrypoint.sh  .

ENTRYPOINT ["/app/entrypoint.sh"]

CMD ["Hello project_template user."]

WORKDIR /app/installation
COPY installation/Dockerfile .

WORKDIR /app
