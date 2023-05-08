terraform-apply:
	cd terraform && terraform apply --auto-approve
terraform-destroy:
	cd terraform && terraform destroy --auto-approve
k8s-config:
	cd k8s && $(MAKE) config
k8s-apply:
	cd k8s && $(MAKE) apply
k8s-delete: 
	cd k8s && $(MAKE) delete
apps-build:
	cd apps && $(MAKE) build
	