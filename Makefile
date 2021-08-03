.PHONY: all install update clean lint docker-restart docker-cleanup
#################################################################################
# GLOBALS                                                                       #
#################################################################################

PROJECT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
PYTHON_INTERPRETER = python3
#################################################################################
# COMMANDS                                                                      #
#################################################################################
all:
	echo $(AWS_PROFILE)

## Install dependencies in pyproject.toml (poetry.lock)
install:
	./scripts/setup_env.sh

## Update dependencies in pyproject.toml 
update:
	poetry lock --no-update
	poetry export -f requirements.txt --output requirements.txt 
	poetry export -f requirements.txt --output airflow-docker/requirements.txt
	peodd -o airflow-docker/requirements-dev.txt

## Delete all compiled Python files
clean:
	find . -type f -name "*.py[co]" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -delete

## Lint using flake8
lint:
	flake8 src
	flake8 stack

## Restart Docker
docker-restart:
	docker-compose -f $(DOCKER_FPATH) down && docker-compose -f $(DOCKER_FPATH) up 

## Cleanup containers, images, and volumes
docker-cleanup: 
	docker-compose -f $(DOCKER_FPATH) down --volumes
	docker kill $(docker ps -q) 
	docker rmi $(docker images -q) -f    
	docker volume rm $(docker volume ls -q)

## Building DockerOperator test image
docker-build-dockeroperator:
	cd airflow-docker && docker build -f dags/docker_jobs/Dockerfile -t docker_image_task .           

## Building Encoding Task images
docker-build-encoding:
	cd tasks/encoding_task && poetry lock --no-update && poetry export -f requirements.txt --output requirements.txt
	cd tasks/encoding_task  && docker build -f Dockerfile -t encoding_task .           


#################################################################################
# PROJECT RULES                                                                 #
#################################################################################



#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
