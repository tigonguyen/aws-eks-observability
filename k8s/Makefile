ENV ?= DEV

config:
	aws eks update-kubeconfig --region ap-southeast-1 --name ${ENV}-eksCluster
	kubectl apply -f namespaces.yml
	kubectl apply -f aws-console-role.yml
apply:
	kubectl apply -f simple-service.yml
	kubectl apply -f postgresql.yml
delete:
	kubectl delete -f simple-service.yml
	kubectl delete -f postgresql.yml