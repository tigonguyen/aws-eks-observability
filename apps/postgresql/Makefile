build:
	docker build -t tigonguyen/postgresql:latest . && docker push tigonguyen/postgresql:latest
	
deploy:
	kubectl apply -f postgresql.yml
clean:
	kubectl delete -f postgresql.yml