#
# Copyright (c) 2003-2006 University of Chicago and Fellowship
# for Interpretations of Genomes. All Rights Reserved.
#
# This file is part of the SEED Toolkit.
# 
# The SEED Toolkit is free software. You can redistribute
# it and/or modify it under the terms of the SEED Toolkit
# Public License. 
#
# You should have received a copy of the SEED Toolkit Public License
# along with this program; if not write to the University of Chicago
# at info@ci.uchicago.edu or the Fellowship for Interpretation of
# Genomes at veronika@thefig.info or download a copy from
# http://www.theseed.org/LICENSE.TXT.
#

#
# seed_running_perl.fragement is the piece of perl code that
# checks to see if the seed server is up, and prints a message and returns
# if it is not.
#
SEED_RUNNING_PERL = seed_running_perl.fragment 
PKGNAME=MGRAST
PERLCGISCRIPTS := $(wildcard cgi/*.cgi)

PERL_LIB = $(wildcard lib/*.pm) \
	$(wildcard lib/WebPage/*.pm) \
	$(wildcard lib/OntologyOnDemand/*.pm) \
	$(wildcard lib/JobDB/*.pm) \
	$(wildcard lib/resources/*.pm)

WEBPAGES := $(wildcard html/*.tmpl) \
	$(wildcard html/images/*.png) \
	$(wildcard html/images/*.gif) \
	$(wildcard html/images/*.jpg) \
	$(wildcard html/images/*.ico) \
	$(wildcard html/*.html) \
        $(wildcard html/js/*.js) \
	$(wildcard html/css/*.css)

INST_PERL_LIB = $(foreach var, $(PERL_LIB), $(libdir)/$(PKGNAME)/$(var))

INST_CGI = $(foreach var, $(PERLCGISCRIPTS), $(cgidir)/$(var))

PERL_BIN_SRC := $(wildcard *.pl)
PERL_BIN = $(subst .pl,, $(PERL_BIN_SRC))

R_SCRIPTS_SRC := $(wildcard r/*.r)
R_SCRIPTS = $(subst r/,, $(R_SCRIPTS_SRC))

all: bin

show:
	@echo cgis $(foreach var, $(PERLCGISCRIPTS), $(cgidir)/$(var))
	@echo top $(TOPDIR)
	@echo pkg $(PKGNAME)
	@echo toolhdr $(TOOL_HDR)
	
bin: $(foreach var, $(R_SCRIPTS), $(bindir)/$(var)) $(foreach var, $(PERL_BIN), $(bindir)/$(var)) 
	@echo R $(foreach var, $(R_SCRIPTS), $(bindir)/$(var))
	
lib: $(INST_CGI) $(INST_PERL_LIB) bin $(foreach var, $(WEBPAGES), $(cgidir)/Html/$(var))

htaccess_src = $(RTROOT)/config/all.htaccess
htaccess_dst = $(cgidir)/.htaccess

copy_htaccess: force
	if test -f $(htaccess_src); then \
		 cp $(htaccess_src) $(htaccess_dst) ; \
	fi

force:

schematools:
stDeclFiles:
stGeneratedFiles:
test:
clean:

$(cgidir)/%: $(TOPDIR)/src/$(PKGNAME)/% $(TOOL_HDR)
	( cat $(TOOL_HDR) $< > $(subst cgi/,, $@); chmod +x $(subst cgi/,, $@) )

$(cgidir)/Html/%: $(TOPDIR)/src/$(PKGNAME)/%
	cp $< $(cgidir)/Html/.

$(bindir)/%: $(TOPDIR)/src/$(PKGNAME)/%.pl $(TOOL_HDR)
	( cat $(TOOL_HDR) $< > $(subt $@); chmod +x $@ )

$(bindir)/%.r: $(TOPDIR)/src/$(PKGNAME)/r/%.r
	cp $< $@

$(libdir)/$(PKGNAME)/%.pm: %.pm
	tgt_dir=`dirname $(subst MGRAST/lib/,MGRAST/, $@)`;  \
	if [ ! -d $$tgt_dir ] ; then \
		mkdir $$tgt_dir; \
	fi
	cp $< $(subst MGRAST/lib/,MGRAST/, $@)