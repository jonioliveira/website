.PHONY: help build bash setup-remote-state-init setup-remote-state-plan setup-remote-state-apply setup-remote-state-destroy fmt init plan apply destroy lint full-plan full-apply
.DEFAULT_GOAL := help

COMPOSE=docker-compose -f docker-compose.yaml
COMPOSE-RUN=$(COMPOSE) run --no-deps terraform
COMPOSE-BASH=$(COMPOSE-RUN) bash

# General

# target: help - Display callable targets.
help:
	@egrep "^# target:" [Mm]akefile

# Docker

# target: build - Build the container image.
build:
	${COMPOSE} build

# target: bash - Bash into the terraform container.
bash:
	${COMPOSE-BASH}

# Terraform setup-remote-state

# target: init - Terraform: init the setup-remote-state module - Initialize a Terraform working directory.
setup-remote-state-init:
	${COMPOSE-BASH} -c 'terraform init'

# target: plan - Terraform: plan the setup-remote-state module - Generate and show an execution plan.
setup-remote-state-plan:
	${COMPOSE-BASH} -c 'terraform plan'

# target: apply - Terraform: apply the setup-remote-state module - Builds or changes infrastructure (Skips interactive approval).
setup-remote-state-apply:
	${COMPOSE-BASH} -c 'terraform apply --auto-approve'

# target: destroy - Terraform: destroy the setup-remote-state module - Destroy Terraform-managed infrastructure.
setup-remote-state-destroy:
	${COMPOSE-BASH} -c 'terraform destroy --auto-approve'

# Terraform

# target: fmt - Terraform: fmt - Rewrites config files to canonical format.
fmt:
	${COMPOSE-RUN} terraform fmt

# target: init - Terraform: init - Initialize a Terraform working directory.
init:
	${COMPOSE-RUN} terraform init

# target: plan - Terraform: plan - Generate and show an execution plan.
plan:
	${COMPOSE-RUN} terraform plan

# target: apply - Terraform: apply - Builds or changes infrastructure (Skips interactive approval).
apply:
	${COMPOSE-RUN} terraform apply --auto-approve

# target: destroy - Terraform: destroy - Destroy Terraform-managed infrastructure.
destroy:
	${COMPOSE-RUN} terraform destroy --auto-approve

# target: lint - Terraform: lint - Run linter into Terraform files.
lint:
	${COMPOSE-RUN} tflint

# target: full-plan - Init and plan the GCP terraform remote state bucket and the main terraform script.
full-plan: setup-remote-state-init init setup-remote-state-plan plan

# target: full-apply - Bring up the full infrastructure. Init and apply the GCP terraform remote state bucket and the main terraform script.
full-apply: setup-remote-state-init init setup-remote-state-apply apply
