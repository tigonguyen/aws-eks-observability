terraform-apply:
	cd terraform && terraform apply --auto-approve
terraform-destroy:
	cd terraform && terraform destroy --auto-approve
apps-build:
	cd apps && $(MAKE) build
apps-deploy:
	cd apps && $(MAKE) deploy
apps-clean: 
	cd apps && $(MAKE) clean
	