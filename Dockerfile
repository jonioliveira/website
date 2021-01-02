FROM debian:stretch-slim

RUN apt-get update && \
  apt-get install wget unzip -y && \
  wget https://releases.hashicorp.com/terraform/0.14.2/terraform_0.14.2_linux_amd64.zip -O /tmp/terraform.zip && \
  unzip /tmp/terraform.zip -d /usr/local/bin/ && \
  rm /tmp/terraform.zip && \
  wget https://github.com/terraform-linters/tflint/releases/download/v0.22.0/tflint_linux_amd64.zip -O /tmp/tflint.zip &&\
  unzip /tmp/tflint.zip -d /usr/local/bin/ && \
  rm /tmp/tflint.zip && \
  apt-get remove --purge unzip -y && \
  apt-get remove --purge wget -y && \
  apt-get autoremove -y

COPY terraform /terraform
WORKDIR /terraform
