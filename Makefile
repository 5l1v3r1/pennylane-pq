PYTHON3 := $(shell which python3 2>/dev/null)

PYTHON := python3
COVERAGE := --cov=pennylane_pq --cov-report term-missing --cov-report=html:coverage_html_report
TESTRUNNER := -m pytest tests --tb=short

.PHONY: help
help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  install            to install PennyLane-PQ"
	@echo "  wheel              to build the PennyLane-PQ wheel"
	@echo "  dist               to package the source distribution"
	@echo "  clean              to delete all temporary, cache, and build files"
	@echo "  clean-docs         to delete all built documentation"
	@echo "  test               to run the test suite for all configured devices"
	@echo "  test-[device]      to run the test suite for the device simulator or ibm"
	@echo "  coverage           to generate a coverage report for all configured devices"
	@echo "  coverage-[device]  to generate a coverage report for the device simulator or ibm"

.PHONY: install
install:
ifndef PYTHON3
	@echo "To install PennyLane-PQ you need to have Python 3 installed"
endif
	$(PYTHON) setup.py install

.PHONY: wheel
wheel:
	$(PYTHON) setup.py bdist_wheel

.PHONY: dist
dist:
	$(PYTHON) setup.py sdist

.PHONY : clean
clean:
	rm -rf pennylane_pq/__pycache__
	rm -rf tests/__pycache__
	rm -rf dist
	rm -rf build
	rm -rf .pytest_cache
	rm -rf .coverage coverage_html_report/

docs:
	make -C doc html

.PHONY : clean-docs
clean-docs:
	make -C doc clean


test: test-all

test-%:
	@echo "Testing device: $(subst test-,,$@)..."
	export DEVICE=$(subst test-,,$@) && $(PYTHON) $(TESTRUNNER)

coverage: coverage-all

coverage-%:
	@echo "Generating coverage report..."
	export DEVICE=$(subst coverage-,,$@) && $(PYTHON) $(TESTRUNNER) $(COVERAGE)
