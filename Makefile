ACCOUNT_ID=$(AWS_ACCOUNT_ID)

hello:
	@echo "Hello, World $(ACCOUNT_ID)"

init:
	@terraform -chdir="terraform/ecr" init
	@terraform -chdir="terraform/ecs" init

build:
	@printf "Building the application!\n"
	@./mvnw clean package
	@if [ $$? -ne 0 ]; then \
	printf "Java application build failed! No new Lambda Function will be deployed!!!i\n"; \
	exit -1;\
	fi;

build-local: build
	@docker build -t hello-world:latest ./hello-world

run-local:
	@docker run -p 8080:8080 hello-world:latest

push:
	@printf "Push the application to repository!\n"
	@aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin $(ACCOUNT_ID).dkr.ecr.ap-southeast-1.amazonaws.com

	@terraform -chdir="terraform/ecr" apply -auto-approve
	@docker buildx build --platform=linux/amd64 -t $(ACCOUNT_ID).dkr.ecr.ap-southeast-1.amazonaws.com/huypva-hello-world-repo:latest ./hello-world
	@docker push $(ACCOUNT_ID).dkr.ecr.ap-southeast-1.amazonaws.com/huypva-hello-world-repo:latest

deploy:
	@echo "Deploying the Terraform!"
	@terraform -chdir="terraform/ecs" apply -auto-approve -var="app_image=$(ACCOUNT_ID).dkr.ecr.ap-southeast-1.amazonaws.com/huypva-hello-world-repo"

destroy:
	@echo "Destroying the resource!"
	@terraform -chdir="terraform/ecs" destroy -auto-approve -var="app_image=$(ACCOUNT_ID).dkr.ecr.ap-southeast-1.amazonaws.com/huypva-hello-world-repo"

destroy-ecr:
	@echo "Destroying erc!"
	@#aws ecr batch-delete-image --repository-name huypva-hello-world-repo --image-ids imageTag=latest --region ap-southeast-1
	@terraform -chdir="terraform/ecr" destroy -auto-approve

clean:
	@./mvnw clean
	@rm -rf terraform/*/.terraform
	@rm -rf terraform/*/.terraform.lock.hcl
	@rm -rf terraform/*/*.tfplan
	@rm -rf terraform/*/terraform.tfstate
	@rm -rf terraform/*/terraform.tfstate.backup