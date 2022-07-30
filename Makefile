package=node.ipkg
idris2=idris2
codegen=node

.PHONY: build clean repl install test-clean test-build test dev dev-test

build:
	bash -c 'time pack build $(package)'

clean:
	rm -rf build

repl:
	pack --with-ipkg $(package) --rlwrap repl

install:
	$(idris2) --install $(package) --codegen $(codegen)

test-clean:
	make -C tests clean

test-build:
	make -C tests build

test: install test-build
	make -C tests test

dev:
	find src/ -name *.idr | entr make build

dev-test:
	find . -name *.idr | INTERACTIVE="" entr make test

