
SHELL = /bin/sh
.SUFFIXES: .sh .desktop

DEPS = wget git notify-send gzip

all: checkdep manpage

# Check dependencies
checkdep:
	echo
	echo "Checking dependencies:"
	$(foreach dep, $(DEPS), if ! which $(dep) ; then \
		echo; echo "$(dep) not installed"; exit 1; fi; )
	echo "OK"

# Make the manpage
manpage:
	cp ./manpage.man ./bitsnet.1
	gzip --force ./bitsnet.1


# Install all of this
install: all
	echo
	echo "Creating directories"
	mkdir -p $(DESTDIR)/usr/local/lib/bitsnet
	mkdir -p $(DESTDIR)/usr/local/etc
	mkdir -p $(DESTDIR)/usr/local/bin
	mkdir -p $(DESTDIR)/usr/local/man/man1
	mkdir -p $(DESTDIR)/usr/local/share/applications
	mkdir -p $(DESTDIR)$(HOME)/.config/autostart
	echo "OK"
	echo
	echo "Copying files"
	cp ./util.sh $(DESTDIR)/usr/local/lib/bitsnet/util.sh
	cp ./rc.config $(DESTDIR)/usr/local/etc/bitsnetrc
	cp ./bitsnet $(DESTDIR)/usr/local/bin/bitsnet
	cp ./bitsnet.1.gz $(DESTDIR)/usr/local/man/man1/
	cp ./app.desktop $(DESTDIR)/usr/local/share/applications/bitsnet.desktop
	echo "OK"


# Clean the working directory
.PHONY: clean
.SILENT:
clean:
	rm -rf bitsnet.1*
