LIB=exit-on-epipe
AUXTARGETS=test_files/test.json

TARGET=$(LIB).js
FLOWTARGET=$(TARGET)
CLOSURE=/usr/local/lib/node_modules/google-closure-compiler/compiler.jar

## Main Targets

.PHONY: all
all: $(TARGET) $(AUXTARGETS) ## Build library and auxiliary scripts

## Testing

.PHONY: test mocha
test mocha: test.js
	mocha -R spec -t 20000

.PHONY: lint
lint: $(TARGET) $(AUXTARGETS) ## Run jshint and jscs checks
	@jshint --show-non-errors $(TARGET) $(AUXTARGETS)
	@jshint --show-non-errors package.json
	@jscs $(TARGET) $(AUXTARGETS)
	if [ -e $(CLOSURE) ]; then java -jar $(CLOSURE) $(REQS) $(FLOWTARGET) --jscomp_warning=reportUnknownTypes >/dev/null; fi


.PHONY: flow
flow: lint ## Run flow checker
	@flow check --all --show-all-errors
