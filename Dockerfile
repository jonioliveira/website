FROM debian:stretch-20190708-slim

RUN apt-get update && \
  apt-get install wget unzip -y && \
  wget https://releases.hashicorp.com/terraform/0.12.5/terraform_0.12.5_linux_amd64.zip -O /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/local/bin/ && \
  rm /tmp/terraform.zip && \
  wget https://github.com/terraform-linters/tflint/releases/download/v0.17.0/tflint_linux_amd64.zip -O /tmp/tflint.zip &&\
  unzip /tmp/tflint.zip -d /usr/local/bin/ && \
  rm /tmp/tflint.zip && \
  apt-get remove --purge unzip -y && \
  apt-get remove --purge wget -y && \
  apt-get autoremove -y

COPY terraform /terraform
WORKDIR /terraform
