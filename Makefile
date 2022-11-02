NAME := docker-host-dns
TAG :=  sed -n 's/^\([^^~]\{1,\}\)\(\^0\)\{0,1\}$$/\1/p' <(git name-rev --name-only --tags --no-undefined HEAD 2>/dev/null)
VERSION != [[ -z $$($(TAG)) ]] && date  +"%Y%m%d" || echo "$(TAG)"
RELEASE != git rev-parse --short HEAD
ROOT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))
RPM_TOPDIR := $(ROOT_DIR)/dist/rpmbuild

dist:
	mkdir -p $(ROOT_DIR)/dist/rpmbuild/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
	tar --transform 's,^,$(NAME)-$(VERSION)/,' -cvzf $(ROOT_DIR)/dist/rpmbuild/SOURCES/$(NAME)-$(VERSION).tar.gz -C $(ROOT_DIR) {$(NAME),LICENSE,Makefile} -C $(ROOT_DIR)/init/systemd $(NAME).service
	cp $(ROOT_DIR)/build/rpm/$(NAME).spec $(RPM_TOPDIR)/SPECS/$(NAME).spec
	rpmbuild --define "_topdir $(RPM_TOPDIR)" --define "name_ $(NAME)" --define "version_ $(VERSION)" --define "release_ $(RELEASE)" -v -ba $(RPM_TOPDIR)/SPECS/$(NAME).spec
	rpmsign --addsign $(RPM_TOPDIR)/RPMS/noarch/$(NAME)-$(VERSION)-git$(RELEASE).noarch.rpm