#==============================================================================
# Makefile for GRTensorIII
#
# This file is not required for normal operation, only for building
# with code changes. See http://gitlab.com/grtensor/GRTensorIII/wikis/home
# for setup instructions.
#
# make grtensor is functional but currently relies on a hard-coded path in 
#   build/griii.mpl for the library save destination 
#
#  make grtensor:  load all source code and updates lib/griii.mla
#
#  make help: compiles the help files into lib/maple.help
#
#  make distrib: copies lib/* into the grtensor distribution git projects lib/
#     - in general distribution content (worksheets, metrics etc) is
#       managed inside the grtensor git project and not here (GRTensorIII project)
#
#
# Update Nov 2016 for Module based grtensor package
# - all file includes/savelib are now in griii.mpl
# - no sub-libraries for invars etc. all objects now in griii
# - assumes there is a lib/ directory with a Maple library 
#   created from within Maple:
# >march('create',"lib/grii.mla",100);
# (assuming maple was started in top level dir)
# TODO: Detect and automate this
#
#
#------------------------------------------------------------------------------
# Orignal makefile by:
# Denis Pollney <dp@maths.soton.ac.uk>
# August 1999
#
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
#   MapleV Command line version via MAPLECMD (usually "maple")
#
# Optional tools: (required by `make distrib')
#   sed         (Set version information)
#   cvs2cl      (Create a changelog for CVS version)
#==============================================================================


# MapleV command: 
# Specify the command used to invoke maple on your system. Note that
# only the command corresponding to your MapleV release needs to be
# specified. The command should be the terminal version, not the
# X-version, eg. xmaple.

MAPLECMD = maple

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

# GRTGITLIB 
# Directory of lib/ in the ditribution gitlab project
# Typically in a directory parallel to the GRTensorIII git
# project.
GRTGITLIB = "../grtensor/lib"
GRTGITDOC = "../grtensor/doc"
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

SRCDIR = src
BUILDDIR = build
METRICDIR = metrics
DOCDIR = doc
DISTRIBDIR = distrib
HELPDIR = $(SRCDIR)/help
WORKSHEETDIR = worksheets
LIBDIR = lib

MAPLEOPTS = -s

GRIIDIR = $(SRCDIR)

#grtensor: grii basis dinvar grtools invars trigsin help
grtensor: griii

griii:     $(LIBDIR)/griii.m

# TODO: griii.m has a hard baked path in it! Need to edit this
# for your system (move to a command cat-ed into session)
#
# This plays the contents of griii.mpl into command line Maple
# the result is a library saved into lib/. 
$(LIBDIR)/griii.m: 
	$(CATCMD) $(BUILDDIR)/griii.mpl | $(MAPLECMD) $(MAPLEOPTS)

.PHONY: help
install-help:
	$(RMCMD) $(LIBDIR)/maple.help
	$(CATCMD) $(BUILDDIR)/help_griii.mpl | $(MAPLECMD) $(MAPLEOPTS)


.PHONY: distrib
# *** sun specific ***
# distrib := INSTALLDIR = $(GRDIR)
# *** gmake specific ***
distrib: 
	$(CPCMD) $(LIBDIR)/* $(GRTGITLIB)/.
	$(CPCMD) $(DOCDIR)/grIntro.pdf $(GRTGITDOC)/.
	$(CPCMD) $(DOCDIR)/grMakeg.pdf $(GRTGITDOC)/.
	$(CPCMD) $(DOCDIR)/grCalc.pdf $(GRTGITDOC)/.
	$(CPCMD) $(DOCDIR)/grDef.pdf $(GRTGITDOC)/.
	$(CPCMD) $(DOCDIR)/grBasis.pdf $(GRTGITDOC)/.







