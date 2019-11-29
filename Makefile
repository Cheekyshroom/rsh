install_dir = ~/bin

install:
	pip install --user hy
	chmod +x $(shell pwd)/runic.hy
	chmod +x $(shell pwd)/rune-shell
	cp -f $(shell pwd)/runic.hy $(install_dir)/runic.hy
	cp -f $(shell pwd)/rune-shell $(install_dir)/rune-shell
