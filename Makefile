infra:
	minikube start
	minikube kubectl
build:
	cd apps && $(MAKE) build
deploy:
	cd apps && $(MAKE) deploy
clean: 
	cd apps && $(MAKE) clean
	