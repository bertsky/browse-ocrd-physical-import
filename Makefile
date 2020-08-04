export

SHELL = /bin/bash
PYTHON = python3
PIP = pip3
LOG_LEVEL = INFO
PYTHONIOENCODING=utf8

deps-ubuntu:
	apt install -y libgtksourceview-3.0-dev

deps:
	$(PIP) install -r requirements.txt

install:
	$(PIP) install .

clean-build: pyclean
	rm -Rf build dist *.egg-info

pyclean:
	rm -f **/*.pyc
	rm -rf .pytest_cache

build: clean-build
	$(PYTHON) setup.py sdist bdist_wheel

testpypi: clean-build build
	twine upload --repository testpypi ./dist/browse[_-]ocrd*.{tar.gz,whl}

pypi: clean-build build
	twine upload ./dist/browse[_-]ocrd*.{tar.gz,whl}


test: tests/assets
	$(PYTHON) -m unittest discover -s tests


# Clone OCR-D/assets to ./repo/assets
repo/assets:
	mkdir -p $(dir $@)
	git clone https://github.com/OCR-D/assets "$@"


# Setup test assets
tests/assets: repo/assets
	mkdir -p $@
	cp -r -t $@ repo/assets/data/*


.PHONY: assets-clean
# Remove symlinks in test/assets
assets-clean:
	rm -rf test/assets
