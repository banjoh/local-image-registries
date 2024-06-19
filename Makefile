certs:
	@bash gen-certs.sh

.PHONY: clean
clean: stop
	@bash -c "test -d certs && rm -r certs || :"
	@bash -c "test -d data && rm -r data || :"
	@bash -c "rm -f *tgz; test -d mychart && rm -r mychart || :"

.PHONY: start
start: mychart certs
	docker compose up -d

.PHONY: restart
restart: stop start

.PHONY: run
run: start logs

.PHONY: logs
logs:
	docker compose logs -f

.PHONY: stop
stop:
	docker compose down

.PHONY: build
build:
	docker compose build

mychart:
	helm create mychart
	helm package mychart
