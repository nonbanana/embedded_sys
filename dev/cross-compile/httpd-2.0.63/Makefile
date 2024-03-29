top_srcdir   = /home/mbin96/build/src/term/httpd-2.0.63
top_builddir = /home/mbin96/build/src/term/httpd-2.0.63
srcdir       = /home/mbin96/build/src/term/httpd-2.0.63
builddir     = /home/mbin96/build/src/term/httpd-2.0.63
VPATH        = /home/mbin96/build/src/term/httpd-2.0.63

SUBDIRS = srclib os server modules support
CLEAN_SUBDIRS = test

PROGRAM_NAME         = $(progname)
PROGRAM_SOURCES      = modules.c
PROGRAM_LDADD        = $(HTTPD_LDFLAGS) $(PROGRAM_DEPENDENCIES) $(EXTRA_LIBS) $(AP_LIBS) $(LIBS)
PROGRAM_DEPENDENCIES = \
  $(BUILTIN_LIBS) \
  $(MPM_LIB) \
  server/libmain.la \
  os/$(OS_DIR)/libos.la

PROGRAMS        = $(PROGRAM_NAME)
TARGETS         = $(PROGRAMS) $(shared_build) $(other_targets)
PHONY_TARGETS   = $(srcdir)/buildmark.c
INSTALL_TARGETS = install-conf install-htdocs install-error install-icons \
	install-other install-cgi install-include install-suexec install-man \
	install-build

DISTCLEAN_TARGETS  = include/ap_config_auto.h include/ap_config_layout.h \
	modules.c config.cache config.log config.status build/config_vars.mk \
        build/rules.mk docs/conf/httpd-std.conf
EXTRACLEAN_TARGETS = configure include/ap_config_auto.h.in generated_lists

include $(top_builddir)/build/rules.mk
include $(top_srcdir)/build/program.mk

install-conf:
	@echo Installing configuration files ; \
	if [ ! -d $(DESTDIR)$(sysconfdir) ]; then \
	    $(MKINSTALLDIRS) $(DESTDIR)$(sysconfdir) ; \
	fi ; \
	cd $(top_srcdir)/docs/conf; \
	for i in mime.types magic; do \
	    if test ! -f $(DESTDIR)$(sysconfdir)/$$i; then \
	        $(INSTALL_DATA) $$i $(DESTDIR)$(sysconfdir); \
	    fi; \
	done; \
	for j in $(top_srcdir)/docs/conf $(top_builddir)/docs/conf ; do \
	    cd $$j ; \
	    for i in *-std*.conf; do \
	    	( \
	    		n_lm=`awk 'BEGIN {n=0} /@@LoadModule@@/ {n+=1} END {print n}' < $$i`; \
	    		if test $$n_lm -eq 0 -o "x$(DSO_MODULES)" = "x"; then \
	    			sed -e 's#@@ServerRoot@@#$(prefix)#g' \
	    				-e 's#@@Port@@#$(PORT)#g' \
	    				-e '/@@LoadModule@@/d' \
	    				< $$i; \
	    		else \
	    			sed -n -e '/@@LoadModule@@/q' \
	    				-e 's#@@ServerRoot@@#$(prefix)#g' \
	    				-e 's#@@Port@@#$(PORT)#g' \
	    				-e 'p' \
	    				< $$i; \
	    			for j in $(DSO_MODULES) "^EOL^"; do \
	    				if test "x$$j" = "xssl"; then \
	    					echo "<IfDefine SSL>"; \
	    				fi; \
	    				if test $$j != "^EOL^"; then \
	    					echo "LoadModule $${j}_module $(rel_libexecdir)/mod_$${j}.so"; \
	    				fi; \
	    				if test "x$$j" = "xssl"; then \
	    					echo "</IfDefine>"; \
	    				fi; \
	    			done; \
	    			sed -e '1,/@@LoadModule@@/d' \
	    				-e '/@@LoadModule@@/d' \
	    				-e 's#@@ServerRoot@@#$(prefix)#g' \
	    				-e 's#@@Port@@#$(PORT)#g' \
	    				< $$i; \
	    		fi \
	    	) > $(DESTDIR)$(sysconfdir)/$$i; \
	    	chmod 0644 $(DESTDIR)$(sysconfdir)/$$i; \
	    	file=`echo $$i|sed s/-std//`; \
	    	if [ "$$file" = "httpd.conf" ]; then \
	    		file=`echo $$file|sed s/.*.conf/$(PROGRAM_NAME).conf/`; \
	    	fi; \
	    	if test "$$file" != "$$i" && test ! -f $(DESTDIR)$(sysconfdir)/$$file; then \
	    		$(INSTALL_DATA) $(DESTDIR)$(sysconfdir)/$$i $(DESTDIR)$(sysconfdir)/$$file; \
	    	fi; \
	    done ; \
	done ; \
	if test -f "$(builddir)/envvars-std"; then \
	    cp -p envvars-std $(DESTDIR)$(sbindir); \
	    if test ! -f $(DESTDIR)$(sbindir)/envvars; then \
	        cp -p envvars-std $(DESTDIR)$(sbindir)/envvars ; \
	    fi ; \
	fi

install-build:
	@echo Installing build system files 
	@test -d $(DESTDIR)$(installbuilddir) || $(MKINSTALLDIRS) $(DESTDIR)$(installbuilddir) 
	@cp $(top_srcdir)/build/*.mk $(DESTDIR)$(installbuilddir); \
	cp build/*.mk $(DESTDIR)$(installbuilddir); \
	sed 's#LIBTOOL = \(.*\)#LIBTOOL = $(SHELL) $(installbuilddir)/libtool $(LTFLAGS)#' \
	    build/config_vars.mk > $(DESTDIR)$(installbuilddir)/config_vars.mk; \
	cp $(top_srcdir)/build/instdso.sh $(DESTDIR)$(installbuilddir); \
	cp $(top_builddir)/config.nice $(DESTDIR)$(installbuilddir);

htdocs-srcdir = $(top_srcdir)/docs/docroot

docs::
	mkdir -p ./docs/api
	srclib/apr/build/scandoc.pl -i./build/default.pl -p./docs/api/ ./include/*.h

dox::
	doxygen $(top_srcdir)/docs/doxygen.conf

install-htdocs:
	-@if [ -d $(DESTDIR)$(htdocsdir) ]; then \
           echo "[PRESERVING EXISTING HTDOCS SUBDIR: $(DESTDIR)$(htdocsdir)]"; \
        else \
	    echo Installing HTML documents ; \
	    $(MKINSTALLDIRS) $(DESTDIR)$(htdocsdir) ; \
	    test -d $(htdocs-srcdir) && (cd $(htdocs-srcdir) && cp -rp * $(DESTDIR)$(htdocsdir)) ; \
	    cd $(DESTDIR)$(htdocsdir) && find . -name ".svn" -type d -print | xargs rm -rf 2>/dev/null || true; \
	fi

install-error:
	-@if [ -d $(DESTDIR)$(errordir) ]; then \
           echo "[PRESERVING EXISTING ERROR SUBDIR: $(DESTDIR)$(errordir)]"; \
        else \
	    echo Installing error documents ; \
	    $(MKINSTALLDIRS) $(DESTDIR)$(errordir) ; \
	    cd $(top_srcdir)/docs/error && cp -rp * $(DESTDIR)$(errordir) ; \
	    test "x$(errordir)" != "x" && cd $(DESTDIR)$(errordir) && find . -name ".svn" -type d -print | xargs rm -rf 2>/dev/null || true; \
	fi

install-icons:
	-@if [ -d $(DESTDIR)$(iconsdir) ]; then \
           echo "[PRESERVING EXISTING ICONS SUBDIR: $(DESTDIR)$(iconsdir)]"; \
        else \
	    echo Installing icons ; \
	    $(MKINSTALLDIRS) $(DESTDIR)$(iconsdir) ; \
	    cd $(top_srcdir)/docs/icons && cp -rp * $(DESTDIR)$(iconsdir) ; \
	    test "x$(iconsdir)" != "x" && cd $(DESTDIR)$(iconsdir) && find . -name ".svn" -type d -print | xargs rm -rf 2>/dev/null || true; \
	fi

install-cgi:
	-@if [ -d $(DESTDIR)$(cgidir) ];then \
	    echo "[PRESERVING EXISTING CGI SUBDIR: $(DESTDIR)$(cgidir)]"; \
	else \
	   echo Installing CGIs ; \
	   $(MKINSTALLDIRS) $(DESTDIR)$(cgidir) ; \
	   cd $(top_srcdir)/docs/cgi-examples && cp -rp * $(DESTDIR)$(cgidir) ; \
	   test "x$(cgidir)" != "x" && cd $(DESTDIR)$(cgidir) && find . -name ".svn" -type d -print | xargs rm -rf 2>/dev/null || true; \
	fi

install-other:
	@test -d $(DESTDIR)$(logfiledir) || $(MKINSTALLDIRS) $(DESTDIR)$(logfiledir)
	@test -d $(DESTDIR)$(runtimedir) || $(MKINSTALLDIRS) $(DESTDIR)$(runtimedir)
	@for ext in dll x; do \
		file=apachecore.$$ext; \
		if test -f $$file; then \
			cp -p $$file $(DESTDIR)$(libdir); \
		fi; \
	done; \
	file=httpd.dll; \
	if test -f $$file; then \
		cp -p $$file $(DESTDIR)$(bindir); \
	fi;

install-include:
	@echo Installing header files
	@test -d $(DESTDIR)$(includedir) || $(MKINSTALLDIRS) $(DESTDIR)$(includedir)
	@cp -p include/*.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/include/*.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/os/$(OS_DIR)/os.h $(DESTDIR)$(includedir)
	@if test -f $(srcdir)/os/$(OS_DIR)/os-inline.c; then \
            cp -p $(srcdir)/os/$(OS_DIR)/os-inline.c $(DESTDIR)$(includedir); \
        fi;
	@cp -p $(srcdir)/server/mpm/$(MPM_SUBDIR_NAME)/*.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/dav/main/mod_dav.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/filters/mod_include.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/generators/mod_cgi.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/generators/mod_status.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/loggers/mod_log_config.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/http/mod_core.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/proxy/mod_proxy.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/modules/ssl/*.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/srclib/pcre/pcre*.h $(DESTDIR)$(includedir)
	@cp -p $(srcdir)/os/$(OS_DIR)/*.h $(DESTDIR)$(includedir)
	@chmod 644 $(DESTDIR)$(includedir)/*.h

install-man:
	@echo Installing man pages and online manual
	@test -d $(DESTDIR)$(mandir)      || $(MKINSTALLDIRS) $(DESTDIR)$(mandir)
	@test -d $(DESTDIR)$(mandir)/man1 || $(MKINSTALLDIRS) $(DESTDIR)$(mandir)/man1
	@test -d $(DESTDIR)$(mandir)/man8 || $(MKINSTALLDIRS) $(DESTDIR)$(mandir)/man8
	@test -d $(DESTDIR)$(manualdir)   || $(MKINSTALLDIRS) $(DESTDIR)$(manualdir)
	@cp -p $(top_srcdir)/docs/man/*.1 $(DESTDIR)$(mandir)/man1
	@cp -p $(top_srcdir)/docs/man/*.8 $(DESTDIR)$(mandir)/man8
	@(cd $(top_srcdir)/docs/manual && cp -rp * $(DESTDIR)$(manualdir))
	@(cd $(DESTDIR)$(manualdir) && find . -name ".svn" -type d -print | xargs rm -rf 2>/dev/null ) || true

install-suexec:
	@if test -f $(builddir)/support/suexec; then \
            test -d $(DESTDIR)$(sbindir) || $(MKINSTALLDIRS) $(DESTDIR)$(sbindir); \
            $(INSTALL_PROGRAM) $(top_builddir)/support/suexec $(DESTDIR)$(sbindir); \
            chmod 4755 $(DESTDIR)$(sbindir)/suexec; \
	fi

suexec:
	cd support && $(MAKE) suexec

x-local-distclean:
	@rm -rf autom4te.cache

include $(top_srcdir)/os/os2/core.mk
