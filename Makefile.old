#==============================================================================
# Makefile for GRTensorII
#
# Denis Pollney <dp@maths.soton.ac.uk>
# August 1999
#
#------------------------------------------------------------------------------
# This file provides the following targets:
#
#   make grtensor   (builds all of the GRTensor libraries)
#   make install    (install the libraries and metrics)
#   make clean      (remove built libraries)
#   make uninstall  (remove installed libraries)
#   make distrib    (build a package suitable for distribution)
#
# Individual GRTensor libraries can be built using the commands:
#   make grii
#   make basis
#   make dinvar
#   make invars
#   make trigsin
#   make help
#
# If the source code has been checked out of the CVS repository, a changelog
# can be generated using the target:
#   make ChangeLog
#
#------------------------------------------------------------------------------
# This file works with GNU make (gmake). For Solaris systems, the
# distrib target does not work until you replace the line
#   distrib: INSTALLDIR = $(GRDIR)
# with
#   distrib := INSTALLDIR = $(GRDIR)
# Search for the string *** gmake specific *** to find it.
#------------------------------------------------------------------------------
# Required tools:
#   make, rm, rmdir, cat, mv, cd
#   MapleV Release 4 or 5
#
# Optional tools: (required by `make distrib')
#   sed         (Set version information)
#   cvs2cl      (Create a changelog for CVS version)
#   tar, gzip   (Package the release for distribution)
# If the user does not wish to use the `make distrib' target, the variables
# referencing these tools can be commented out.
#
# *** Note *** If sed is not available in the build environment, you will
#              also have to make modifications to the build/grii.mpl script.
#              See the Readme file and comments within build/grii.mpl.
#==============================================================================

# Maple version information:
# Uncomment the release of MapleV which you are using.

MAPLERELEASE = 5
#MAPLERELEASE = 4

# MapleV command: 
# Specify the command used to invoke maple on your system. Note that
# only the command corresponding to your MapleV release needs to be
# specified. The command should be the terminal version, not the
# X-version, eg. xmaple.

MAPLECMD = maple

# Binary format: 
# Uncomment the appropriate format for MapleV binaries (32-bit or
# 64-bit) according to CPU type (eg. for Pentium use 32, for Alpha use
# 64). This variable only used by the `make distrib' target and only
# if MAPLERELEASE=4.

MAPLEBIN = bin32
#MAPLEBIN = bin64

# Installation directory:
# Directory into which to install the finished package. Use the full path
# name. You must have permission to write to the specified directory.
# Required only by the `make install' target.

INSTALLDIR = /usr/local/grii

# GRTensorII version:
# The version which you would like to give to the built GRTensorII
# libraries. This information is only necessary if you intend to use
# the `make distrib' target.
# The sed command is used to read the version information from the
# file Version in the current directory. 
#
# *** Only modify this variable if sed does not exist on the system ***
# *** or you would rather set the version information manually.     ***

GRIIVERSION = "`sed -n '/Version:/s/Version:[ ]*//p' Version`"
# GRIIVERSION = 

# Install command:
# Indicates the GNU install command which the `make install' target is
# to use. If this command does not exist on the standard path, you may
# wish to specify a full pathname for INSTALLCMD.
#
# This variable is only important if you intend to use the `make
# install' target.

INSTALLCMD = install

# Packaging commands:
# Indicate the tar and gzip commands which the `make distrib' target
# is to use. Again, if these do not exist on the standard path,
# specify a full pathname.
#
# These variables are only important if you intend to use the `make
# distrib' target.

TARCMD = tar
GZIPCMD = gzip

# ChangeLog script:
# The following script specifies the cvs2cl command  which is run by
# the `make distrib' target in order to generate a changelog.
#
# This variable is only important if you intend to use the `make
# distrib' target.

CVS2CLCMD = cvs2cl

# Operating system commands:

# Commands which the operating system uses for various file and
# directory operations. Unix versions are assumed. (If these do not
# exist with the given names on your operating system, your
# environment may not be appropriate for running this makefile and
# building by hand as described in the Readme file is recommended.)
RMCMD = rm
RMDIRCMD = rmdir
MKDIRCMD = mkdir
CATCMD = cat
MVCMD = mv
CDCMD = cd
CPCMD = cp

#==============================================================================
# Variables below this line should not require modification.
#==============================================================================
prefix = .

GRDIR = grii

SRCDIR = maple
BUILDDIR = build
METRICDIR = metrics
DISTRIBDIR = distrib
HELPDIR = $(SRCDIR)/help
WORKSHEETDIR = worksheets
LIBDIR = lib

MAPLEOPTS = -s

GRIIDIR = $(SRCDIR)/grii
OBJECTDIR = $(GRIIDIR)/objects

GRIIFILES = Version \
	$(GRIIDIR)/array.mpl \
	$(GRIIDIR)/autoAlias.mpl \
	$(GRIIDIR)/autoload.mpl \
	$(GRIIDIR)/cmd_sup.mpl \
	$(GRIIDIR)/commands.mpl \
	$(GRIIDIR)/constrai.mpl \
	$(GRIIDIR)/contract.mpl \
	$(GRIIDIR)/core.mpl \
	$(GRIIDIR)/create.mpl \
	$(GRIIDIR)/dalias.mpl \
	$(GRIIDIR)/def_fns.mpl \
	$(GRIIDIR)/define.mpl \
	$(GRIIDIR)/diffAlias.mpl \
	$(GRIIDIR)/expandsqrt.mpl \
	$(GRIIDIR)/globals.mpl \
	$(GRIIDIR)/grcomp.mpl \
	$(GRIIDIR)/grdef.mpl \
	$(GRIIDIR)/grload.mpl \
	$(GRIIDIR)/grtensor.mpl \
	$(GRIIDIR)/grtransform.mpl \
	$(GRIIDIR)/initFn.mpl \
	$(GRIIDIR)/killing.mpl \
	$(GRIIDIR)/makeg.mpl \
	$(GRIIDIR)/miscfn.mpl \
	$(GRIIDIR)/newmetric.mpl \
	$(GRIIDIR)/normalize.mpl \
	$(GRIIDIR)/nptetrad.mpl \
	$(GRIIDIR)/op_sup.mpl \
	$(GRIIDIR)/parse.mpl \
	$(GRIIDIR)/rdependent.mpl \
	$(GRIIDIR)/str2def.mpl \
	$(GRIIDIR)/symfn.mpl \
	$(GRIIDIR)/symmetry.mpl

OBJECTFILES = $(OBJECTDIR)/basis.mpl $(OBJECTDIR)/cmdef.mpl \
	$(OBJECTDIR)/diffop.mpl $(OBJECTDIR)/dual.mpl \
	$(OBJECTDIR)/extras.mpl $(OBJECTDIR)/gcalc.mpl \
	$(OBJECTDIR)/grvector.mpl $(OBJECTDIR)/killing.mpl \
	$(OBJECTDIR)/ricci.mpl $(OBJECTDIR)/tensors.mpl \
	$(OBJECTDIR)/Vectors.mpl

BASISDIR = $(SRCDIR)/basis

BASISFILES = $(BASISDIR)/Version.mpl \
	$(BASISDIR)/CCurve.mpl \
	$(BASISDIR)/CSpinlib.mpl \
	$(BASISDIR)/JMSpin.mpl \
	$(BASISDIR)/NPSpin.mpl \
	$(BASISDIR)/Petrov.mpl \
	$(BASISDIR)/RicciSc.mpl \
	$(BASISDIR)/WeylSc.mpl

DINVARDIR = $(SRCDIR)/dinvar

DINVARFILES = $(DINVARDIR)/Version.mpl \
	$(DINVARDIR)/dinvar.mpl

GRTOOLSDIR = $(SRCDIR)/grtools

GRTOOLSFILES = $(GRTOOLSDIR)/Version.mpl \
	$(GRTOOLSDIR)/difftool.mpl \
	$(GRTOOLSDIR)/limit.mpl \
	$(GRTOOLSDIR)/mixpar.mpl \
	$(GRTOOLSDIR)/pexpand.mpl

INVARDIR = $(SRCDIR)/invar

INVARFILES = $(INVARDIR)/r1.mpl \
	$(INVARDIR)/r2.mpl \
	$(INVARDIR)/r3.mpl \
	$(INVARDIR)/w1.mpl \
	$(INVARDIR)/w2.mpl \
	$(INVARDIR)/m1.mpl \
	$(INVARDIR)/m2.mpl \
	$(INVARDIR)/m3.mpl \
	$(INVARDIR)/m4.mpl \
	$(INVARDIR)/m5.mpl \
	$(INVARDIR)/m6.mpl

TRIGSINDIR = $(SRCDIR)/trigsin

TRIGSINFILES = $(TRIGSINDIR)/Version.mpl \
	$(TRIGSINDIR)/trigsin.mpl

GRIILIBS = grii.m basislib.m dinvar.m grtools.m invar.m trigsin.m maple.hdb

TARFILE-4 = "grii$(MAPLERELEASE)-$(GRIIVERSION).$(MAPLEBIN).tar"
TARFILE-5 = "grii$(MAPLERELEASE)-$(GRIIVERSION).tar"

TARFILE = $(TARFILE-$(MAPLERELEASE))

TARLIBS = $(foreach file,$(GRIILIBS),$(GRDIR)/$(LIBDIR)/$(file))

CHANGELOGFILE = ChangeLog
NEWSFILE = News

grtensor: grii basis dinvar grtools invars trigsin help

grii:     $(LIBDIR)/grii.m
basis:    $(LIBDIR)/basislib.m
dinvar:   $(LIBDIR)/dinvar.m
grtools:  $(LIBDIR)/grtools.m
invars:   $(LIBDIR)/invar.m
trigsin:  $(LIBDIR)/trigsin.m
help:     $(LIBDIR)/maple.hdb

$(LIBDIR)/grii.m: $(GRIIFILES) $(OBJECTFILES) $(BUILDDIR)/grii.mpl
	$(CATCMD) $(BUILDDIR)/grii.mpl | $(MAPLECMD) $(MAPLEOPTS)
	$(MVCMD) grii.m $(LIBDIR)

$(LIBDIR)/basislib.m: $(BASISFILES) $(BUILDDIR)/basislib.mpl
	$(CATCMD) $(BUILDDIR)/basislib.mpl | $(MAPLECMD) $(MAPLEOPTS)
	$(MVCMD) basislib.m $(LIBDIR)

$(LIBDIR)/dinvar.m: $(DINVARFILES) $(BUILDDIR)/dinvar.mpl
	$(CATCMD) $(BUILDDIR)/dinvar.mpl | $(MAPLECMD) $(MAPLEOPTS)
	$(MVCMD) dinvar.m $(LIBDIR)

$(LIBDIR)/grtools.m: $(GRTOOLSFILES) $(BUILDDIR)/grtools.mpl
	$(CATCMD) $(BUILDDIR)/grtools.mpl | $(MAPLECMD) $(MAPLEOPTS)
	$(MVCMD) grtools.m $(LIBDIR)

$(LIBDIR)/invar.m: $(INVARFILES) $(BUILDDIR)/invars.mpl
	$(CATCMD) $(BUILDDIR)/invars.mpl | $(MAPLECMD) $(MAPLEOPTS)
	$(MVCMD) invar.m $(LIBDIR)

$(LIBDIR)/trigsin.m: $(TRIGSINFILES) $(BUILDDIR)/trigsin.mpl
	$(CATCMD) $(BUILDDIR)/trigsin.mpl | $(MAPLECMD) $(MAPLEOPTS)
	$(MVCMD) trigsin.m $(LIBDIR)

$(LIBDIR)/maple.hdb: $(BUILDDIR)/help4.mpl
	$(CATCMD) $(BUILDDIR)/help4.mpl | $(MAPLECMD) $(MAPLEOPTS)
	$(MVCMD) maple.hdb $(LIBDIR)

.PHONY: ChangeLog
ChangeLog:
	$(CVS2CLCMD) --prune --header $(BUILDDIR)/ChangeLog.header \
	  --usermap $(BUILDDIR)/ChangeLog.maintainers \
	  --log-opts -r1.1: --file $(CHANGELOGFILE)

.PHONY: clean
clean:
	@griilibs="$(GRIILIBS)" ; \
	for griilib in $$griilibs ; do \
	  $(RMCMD) -f $(LIBDIR)/$$griilib ; \
	done ; \
	$(RMCMD) -f $(DISTRIBDIR)/$(TARFILE).gz

.PHONY: install-libs
install-libs: grtensor
	@griilibs="$(GRIILIBS)" ; \
	if [ ! -d $(INSTALLDIR) ] ; then \
	  $(INSTALLCMD) -m 775 -d $(INSTALLDIR) ; \
	fi ; \
	$(INSTALLCMD) -m 775 -d $(INSTALLDIR)/lib ; \
	for griilib in $$griilibs ; do \
	  $(INSTALLCMD) -m 664 $(LIBDIR)/$$griilib \
	    $(INSTALLDIR)/lib/$$griilib ; \
	done

.PHONY: install-metrics
install-metrics:
	if [ ! -d $(INSTALLDIR) ] ; then \
	  $(INSTALLCMD) -m 775 -d $(INSTALLDIR) ; \
	fi ; \
	$(INSTALLCMD) -m 775 -d $(INSTALLDIR)/metrics ; \
	$(INSTALLCMD) -m 664 $(METRICDIR)/*.mpl $(INSTALLDIR)/metrics

.PHONY: install-help
install-help:
	if [ ! -d $(INSTALLDIR) ] ; then \
	  $(INSTALLCMD) -m 775 -d $(INSTALLDIR) ; \
	fi ; \
	$(INSTALLCMD) -m 775 -d $(INSTALLDIR)/help ; \
	if [ -d $(HELPDIR) ] ; then \
	  $(INSTALLCMD) -m 664 $(HELPDIR)/*.html $(INSTALLDIR)/help ; \
	  $(INSTALLCMD) -m 664 $(HELPDIR)/*.help $(INSTALLDIR)/help ; \
	else \
	  $(INSTALLCMD) -m 664 help/*.html $(INSTALLDIR)/help ; \
	  $(INSTALLCMD) -m 664 help/*.help $(INSTALLDIR)/help ; \
	fi

.PHONY: install-worksheets
install-worksheets:
	if [ -d $(WORKSHEETDIR) ] ; then \
	  if [ ! -d $(INSTALLDIR) ] ; then \
	    $(INSTALLCMD) -m 775 -d $(INSTALLDIR) ; \
	  fi ; \
	  $(INSTALLCMD) -m 775 -d $(INSTALLDIR)/worksheets ; \
	  $(INSTALLCMD) -m 664 $(WORKSHEETDIR)/*.mws $(INSTALLDIR)/worksheets ; \
	fi ;

.PHONY: install-etc
install-etc:
	if [ ! -d $(INSTALLDIR) ] ; then \
	  $(INSTALLCMD) -m 775 -d $(INSTALLDIR) ; \
	fi ; \
	$(INSTALLCMD) -m 664 $(BUILDDIR)/Readme.distrib $(INSTALLDIR)/Readme ; \
	$(INSTALLCMD) -m 664 License $(INSTALLDIR)/License ; \
	$(INSTALLCMD) -m 664 News $(INSTALLDIR)/News ; \
	$(INSTALLCMD) -m 664 Version $(INSTALLDIR)/Version ; \
	$(INSTALLCMD) -m 775 $(BUILDDIR)/Install.unix $(INSTALLDIR)/Install.unix

.PHONY: install-mapleinit
install-mapleinit:
	if [ ! -d $(INSTALLDIR) ] ; then \
	  $(INSTALLCMD) -m 775 -d $(INSTALLDIR) ; \
	fi ; \
	sed 's|<grii_dir>|`$(INSTALLDIR)`|;s|<metric_dir>|`'$(INSTALLDIR)'/metrics`|' build/mapleinit.sample > $(INSTALLDIR)/mapleinit.sample

install: install-libs install-metrics install-help install-worksheets install-etc install-mapleinit

.PHONY: uninstall-libs 
uninstall-libs:
	@griilibs="$(GRIILIBS)" ; \
	if [ -d $(INSTALLDIR)/lib ] ; then \
	  for griilib in $$griilibs ; do \
	    $(RMCMD) -f $(INSTALLDIR)/lib/$$griilib ; \
	  done ; \
	  $(RMDIRCMD) $(INSTALLDIR)/lib ; \
	fi

.PHONY: uninstall-metrics
uninstall-metrics:
	if [ -d $(INSTALLDIR)/metrics ] ; then \
	  $(RMCMD) -f $(INSTALLDIR)/metrics/*.mpl ; \
	  $(RMDIRCMD) $(INSTALLDIR)/metrics ; \
	fi

.PHONY: uninstall-help
uninstall-help:
	if [ -d $(INSTALLDIR)/help ] ; then \
	  $(RMCMD) -f $(INSTALLDIR)/help/*.help ; \
	  $(RMCMD) -f $(INSTALLDIR)/help/*.html ; \
	  $(RMDIRCMD) $(INSTALLDIR)/help ; \
	fi

.PHONY: uninstall-worksheets
uninstall-worksheets:
	if [ -d $(INSTALLDIR)/worksheets ] ; then \
	  $(RMCMD) -f $(INSTALLDIR)/worksheets/*.mws ; \
	  $(RMDIRCMD) $(INSTALLDIR)/worksheets ; \
	fi

.PHONY: uninstall-worksheets
uninstall-etc:
	if [ -d $(INSTALLDIR) ] ; then \
	  $(RMCMD) -f $(INSTALLDIR)/Readme ; \
	  $(RMCMD) -f $(INSTALLDIR)/License ; \
	  $(RMCMD) -f $(INSTALLDIR)/News ; \
	  $(RMCMD) -f $(INSTALLDIR)/mapleinit.sample ; \
	fi

.PHONY: uninstall-mapleinit
uninstall-mapleinit:
	$(RMCMD) -f $(INSTALLDIR)/mapleinit.sample

uninstall: uninstall-libs uninstall-metrics uninstall-help uninstall-worksheets uninstall-etc uninstall-mapleinit
	if [ -d $(INSTALLDIR) ] ; then \
	  $(RMDIRCMD) $(INSTALLDIR) ; \
	fi

.PHONY: distrib
# *** sun specific ***
# distrib := INSTALLDIR = $(GRDIR)
# *** gmake specific ***
distrib: INSTALLDIR = $(GRDIR)
distrib: install-libs install-metrics install-help install-worksheets install-etc
	cp $(BUILDDIR)/mapleinit.sample $(GRDIR)
	tar cf $(TARFILE) $(GRDIR) ; \
	$(RMCMD) -rf $(GRDIR)
	$(GZIPCMD) $(TARFILE); \
	$(MVCMD) $(TARFILE).gz $(DISTRIBDIR)







