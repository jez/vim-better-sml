all: install

MLTON = mlton

support/vbs-util: support/*.sml support/vbs-util.mlb
	$(MLTON) -show-def-use support/vbs-util.du -prefer-abs-paths true support/vbs-util.mlb

.PHONY: install
install: support/vbs-util
	mkdir -p bin
	mv support/vbs-util bin

.PHONY: clean
clean:
	rm -rf bin
	rm -f support/vbs-util
