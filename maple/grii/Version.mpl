#==============================================================================
# GRTensor
#
# Peter Musgrave, Denis Pollney, Kayll Lake.
# Copyright 1993-1997.
#
# THIS FILE IS DEFUNCT.
# Version information should rather be specified in the Version file
# at the root of the source directory. See the Makefile and grii.mpl in
# the build directory.
# THIS FILE IS DEFUNCT
#------------------------------------------------------------------------------

# grG_Version := `GRTensorII Version 1.75pre1`:
# grG_Date    := `18 August 1999`:

#------------------------------------------------------------------------------
# Build history
#
# 1.34  Fix C(dn,dn,dn,dn) dependancy
# 1.35  Add grOptionMemory to grcalc and gralterGuts
# 1.36  Add grcalcd(), grOptionqloadPath and allow makeg to not save a metric
# 1.37  Fix grdef symmetry bug
# 1.38  Fix bWeylSq dependency
#
# 156 [13 Mar 97] dp  Fix greqn2set bug discovered by Jim McClune.
# 162 [16 Sep 97] dp  Comment out `For the xxx metric' in output of grsaveoj()
#                     Fix LieD[] operator.
# 163 [18 Sep 97] dp  Fix 1-term line-element entry in makeg(), output of
#                     grsaveobj() in R3, added initFn.mpl.
# 164 [04 Nov 97] dp  Fix assignment of grG_metric name in automatic creation
#                     of the calc function by grdef().
# 165 [05 Dec 97] dp  Added grOptionMessageLevel.
# 166 [14 Feb 98] dp  Switch reference to `string' data-type to `name'
#                     for compatibility with R5.
# 167 [24 Feb 98] dp  Add index consistency check in grdef().
#                     Fix grundef() to clear assigned objects and all index
#                     combinations.
#                     Added CMB.
# 168 [15 Mar 98] dp  Added version 5 specific extra arg to `&proc`
# 169 [ 6 May 98] dp  Added recognition of derivative and basis
#                     indices in grdef consistency checks.
#                     Replaced kdelta function with a standard object
#                     definition.
# 170 [31 May 98] dp  Fixed indices on lhs of grdisplay output so that
#                     square brackets don't show up in R5 output.
# 171 [19 Oct 98] dp  Fixed parse errors (for operators and tensors as
#                     arguments of functions) in grdef().
#                     Modified grsavedef() so save grdef() statements.
# 172b[10 Feb 99] dp  Fixed index ordering problem in dispStr3.
#                     Fixed support for >6 indices (grF_unassignLoopVars)
#                     Fixed grdef() index parser for cbdn, pbdn
#                     Fixed autoAlias for R5 & alias 0th order terms
# 173 [27 May 99] dp  Added feature to enter basis vectors as differentials
#                     in makeg()
# 174 [27 Jul 99] dp  Added check for name conflicts in autoAlias().
#                     Fixed grtransform() based on [Edward Huff 1999.06.26]
# 175 [18 Aug 99] dp  Switched readstat and grF_my_readstat to grF_readstat
#	              Fixed index ordering problem in dispStr3
#
#==============================================================================


