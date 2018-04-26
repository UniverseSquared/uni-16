all: love

clean:
	@echo "Cleaning..."
	rm -f build/*

love: clean
	mkdir -p build
	zip -rq build/uni-16.love .
