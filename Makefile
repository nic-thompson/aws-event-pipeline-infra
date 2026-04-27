.PHONY: replay

replay:
	ENV=$(ENV) START=$(START) END=$(END) TYPE=$(TYPE) ./scripts/replay.sh