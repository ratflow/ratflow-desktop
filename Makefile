install: 
	(cd system && find . -type f -exec install -v -Dm 755 "{}" "/{}" \;)
	bash deb/common/postinstall-pak
	@echo "Installation complete"

