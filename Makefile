# Tutorial on Make's assignment operators:
# = lazy set, := immediate set, ?= lazy set If absent, += append, != shell assignment

# locations for sources, := **/*.py # does not work on nested folders
LOCATIONS       := src tests docs/conf.py
OUTPUT_DIR      := output
PACKAGE_NAME 	:= "package_name"


# phony targets that do not produce artifact, remaining targets produce artifact using target-name $@
.PHONY: clean format safety_check typecheck unit integration automated_tests quality e2e


format: # Run the code formatter and import sorter
	black $(LOCATIONS)
	isort $(LOCATIONS)
	@echo "Ignore, Created by Makefile, `date`" > $@


safety_check: # Run safety check
	safety check --full-report


lint: $(PY_FILES:%=.lint/%)


.lint/%.py: %.py
	flake8 --show-source --statistics --benchmark $<
	mkdir -p $(shell dirname $@)
	touch $@


typecheck: # Run type checker
	pytype --jobs 4 --keep-going $(LOCATIONS)
	@echo "Ignore, Created by Makefile, `date`" > $@


unit: # Run unit tests
	COVERAGE_FILE=.coverage.unit PYTHONPATH=$(PYTHONPATH):src/. pytest --durations 10 --cov --cov-config=pyproject.toml --xdoctest --junit-xml=$(OUTPUT_DIR)/unit-test-report.xml -m unit
	COVERAGE_FILE=.coverage.unit coverage html --title="$(PACKAGE_NAME) - Unit Test Coverage" -d $(OUTPUT_DIR)/coverage-unittest
	@echo "Ignore, Created by Makefile, `date`" > $@


integration:  # Run integration tests
	COVERAGE_FILE=.coverage.integration PYTHONPATH=$(PYTHONPATH):src/. pytest --cov --cov-config=pyproject.toml --xdoctest --junit-xml=$(OUTPUT_DIR)/test-report.xml -m "integration"
	COVERAGE_FILE=.coverage.integration coverage html --title="$(PACKAGE_NAME) - Test Coverage" -d $(OUTPUT_DIR)/coverage-test


# automated_tests should include everything that isn't long-running or in need of special resources.
automated_tests: # Run all the tests that can be run "in automation" (i.e. on Jenkins).
	COVERAGE_FILE=.coverage.ui PYTHONPATH=$(PYTHONPATH):src/. pytest --cov --cov-config=pyproject.toml --xdoctest --junit-xml=$(OUTPUT_DIR)/test-report.xml -m "not e2e"
	COVERAGE_FILE=.coverage.ui coverage html --title="$(PACKAGE_NAME) - Test Coverage" -d $(OUTPUT_DIR)/coverage-test


e2e: # Run only e2e tests, works only on cluster
	COVERAGE_FILE=.coverage.e2e PYTHONPATH=$(PYTHONPATH):src/. pytest --cov --cov-config=pyproject.toml --xdoctest --junit-xml=$(OUTPUT_DIR)/e2e-test-report.xml -m "e2e"
	COVERAGE_FILE=.coverage.e2e coverage html --title="$(PACKAGE_NAME) - End-to-End Test Coverage" -d $(OUTPUT_DIR)/coverage-e2e-test


# sphinx-build does not return proper error code on failure
doc:  docs/ */*.rst # Build docs using sphinx
	PYTHONPATH=$(PYTHONPATH):src/. sphinx-build -W docs $(OUTPUT_DIR)/doc_build
	@echo "Ignore, Created by Makefile, `date`" > $@


quality: lint typecheck automated_tests


clean:             # Clean up files/services produced by make system
	@echo "Cleaning..."
	@rm -rf $(OUTPUT_DIR)
	@rm -rf format lint typecheck unit .pytest_cache .pytype .coverage* .lint
	@rm -rf __pycache__ */__pycache__ */*/__pycache__ */*/*/__pycache__
