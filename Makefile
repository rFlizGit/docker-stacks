.PHONY: help

BUILD ?=$(shell git rev-parse --short HEAD)
BRANCH?=${shell git branch | grep \* | cut -d ' ' -f2 | cut -d '(' -f2}
OWNER?=925388419436.dkr.ecr.us-west-1.amazonaws.com

help:
	@echo "$(BRANCH)@$(BUILD)"
	@perl -nle'print $& if m{^[a-zA-Z_-]+:.*?## .*$$}' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build the Docker image
	docker build -t $(OWNER)/$(notdir $(TARGET)):$(BRANCH)-$(BUILD) ./$(notdir $(TARGET))


run: ## Run the app in Docker
	docker run -d
		--name $(TARGET) \
		--network drift_rest_api-network \
		--expose 4040 \
		--rm -it $(OWNER)/$(notdir $(TARGET)):$(BRANCH)-$(BUILD)

push: ## Push to aws ecr
	aws ecr get-login-password --region us-west-1 | docker login --username AWS --password-stdin 925388419436.dkr.ecr.us-west-1.amazonaws.com \
	&& docker push $(OWNER)/$(notdir $(TARGET)):$(BRANCH)-$(BUILD) \
	&& docker tag $(OWNER)/$(notdir $(TARGET)):$(BRANCH)-$(BUILD) $(OWNER)/$(notdir $(TARGET)) \
	&& docker push $(OWNER)/$(notdir $(TARGET))