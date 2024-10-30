test:
	@echo "Running tests..."
	@swift test -q

format:
	@swift format -ir --configuration swiftFormatConfig.json .

