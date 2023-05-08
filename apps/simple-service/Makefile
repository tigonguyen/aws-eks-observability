build:
	docker build -t tigonguyen/simple-service:latest . && docker push tigonguyen/simple-service:latest
deploy:
	kubectl -- apply -f simple-service.yml
clean:
	kubectl -- delete -f simple-service.yml