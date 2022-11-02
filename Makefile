NAME := docker-host-dns
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
RPM_TOPDIR := $(ROOT_DIR)/dist/rpmbuild
HELPERS_DIR := $(ROOT_DIR)/build/helpers
TAG != git describe --exact-match --tags HEAD 2>/dev/null
VERSION != $(HELPERS_DIR)/process_tag.sh -v '$(TAG)'
RELEASE != $(HELPERS_DIR)/process_tag.sh -r '$(TAG)'

dist:
	mkdir -p $(ROOT_DIR)/dist/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
	tar --transform 's,^,$(NAME)-$(VERSION)/,' -cvzf $(ROOT_DIR)/dist/rpmbuild/SOURCES/$(NAME)-$(VERSION).tar.gz -C $(ROOT_DIR) {$(NAME),LICENSE,Makefile} -C $(ROOT_DIR)/init/systemd $(NAME).service
	cp $(ROOT_DIR)/build/rpm/$(NAME).spec $(RPM_TOPDIR)/SPECS/$(NAME).spec
	rpmbuild --define "_topdir $(RPM_TOPDIR)" --define "name_ $(NAME)" --define "version_ $(VERSION)" --define "release_ $(RELEASE)" -v -ba $(RPM_TOPDIR)/SPECS/$(NAME).spec
	rpmsign --addsign $(RPM_TOPDIR)/RPMS/noarch/$(NAME)-$(VERSION)-$(RELEASE).noarch.rpm