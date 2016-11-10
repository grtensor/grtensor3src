head	1.1;
branch	1.1.1;
access;
symbols
	Rel-1-80-pre2-R6:1.1.1.1.2.1.2.1
	Rel-1-80-pre1-R6:1.1.1.1.2.1.2.1
	Rel-1-79:1.1.1.1
	Rel-1-79-R6:1.1.1.1.2.1.2.1
	Rel-1-79-pre5-R6:1.1.1.1.2.1.2.1
	Rel-1-79-pre4-R6:1.1.1.1.2.1.2.1
	Rel-1-79-pre3-R6:1.1.1.1.2.1.2.1
	Rel-1-79-pre3:1.1.1.1
	Rel-1-78:1.1.1.1
	Rel-1-78-R6:1.1.1.1.2.1.2.1
	Rel-1-79-pre1:1.1.1.1
	Rel-1-78-pre5-R6:1.1.1.1.2.1.2.1
	Rel-1-78-pre5:1.1.1.1
	Rel-1-78-pre4-R6:1.1.1.1.2.1.2.1
	Rel-1-78-pre4:1.1.1.1
	Rel-1-78-pre2-R6:1.1.1.1.2.1.2.1
	Rel-1-78-pre2:1.1.1.1
	Rel-1-78-pre1-R6:1.1.1.1.2.1
	Rel-1-78-pre1:1.1.1.1
	Rel-1-77:1.1.1.1
	R6:1.1.1.1.2.1.0.2
	Rel-1-77-R6:1.1.1.1.2.1
	Rel-1-77-pre1-R6:1.1.1.1.2.1
	Rel-1-77-pre1-R5:1.1.1.1
	Rel-1-76-R6:1.1.1.1.0.2
	Rel-1-75:1.1.1.1
	Rel-1-76:1.1.1.1
	Rel-1-76pre2:1.1.1.1
	Rel-1-74:1.1.1.1
	GRTensorII:1.1.1;
locks; strict;
comment	@# @;


1.1
date	99.08.17.12.49.42;	author dp;	state Exp;
branches
	1.1.1.1;
next	;

1.1.1.1
date	99.08.17.12.49.42;	author dp;	state Exp;
branches
	1.1.1.1.2.1;
next	;

1.1.1.1.2.1
date	2000.03.09.17.04.11;	author pollney;	state Exp;
branches
	1.1.1.1.2.1.2.1;
next	;

1.1.1.1.2.1.2.1
date	2000.09.12.14.30.18;	author pollney;	state Exp;
branches;
next	;


desc
@@


1.1
log
@Initial revision
@
text
@

#
# difftool
#
# Developed By: Peter Musgrave
#
# July 21, 1994
#
# Allow the first derivatives of some arbitrary
# function to be set to zero while keeping
# higher order derivatives intact.
#
# The idea:
#
# Maple distinguishes between Diff and diff. Scan the
# expression and convert and terms with diff(diff(..)..)
# to Diff(Diff(..)..)
#

difftool := proc(expr)

local retVal:

 retVal := expr:
 if type( expr, {`*`,`+`,`^`} ) then
   retVal := map( difftool, expr);

 elif type(expr,function) then
   if op(0,expr) = diff then
     #
     # found an instance of diff, is it a diff(diff ?
     # If so then convert to Diff
     #
     if type( op(1,expr), function) then
       if op(0,op(1,expr)) = diff then
         retVal := subs( diff=Diff, expr):
       fi:
     fi:
   else
     retVal := op(0,expr)(op(map(difftool,[op(expr)]))):

   fi:
 fi:

 retVal;

end:

@


1.1.1.1
log
@Initial import to CVS repository
@
text
@@


1.1.1.1.2.1
log
@Initial R6 conversion using updtsrc
@
text
@a25 1
### WARNING: note that `I` is no longer of type `^`
@


1.1.1.1.2.1.2.1
log
@Removed warning messages that were put in by updtsrc on R5->R6 conversion.
@
text
@d26 1
@


