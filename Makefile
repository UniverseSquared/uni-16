all: love

clean:
	@echo "Cleaning..."
	rm -f build/*

love: clean
	@echo "Generating .love file..."
	mkdir -p build
	zip -rq build/uni-16.love .

win32: love
	@echo "Generating windows executable..."
	mkdir -p build/win32
	cat windows/love.exe build/uni-16.love > build/win32/uni-16.exe
	cp windows/*.dll build/win32
