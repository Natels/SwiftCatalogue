@PHONY: test
test:
	@echo "Running tests..."
	@swift test -q

@PHONY: format
format:
	@swift format -ir --configuration swiftFormatConfig.json .
	
@PHONY: lint
lint:
	@swift format lint -r --configuration swiftFormatConfig.json .

@PHONY: precommit
precommit: test lint
