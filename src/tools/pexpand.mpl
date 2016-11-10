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
@#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: pexpand
#
# (C) 1992-1994 Peter Musgrave, Denis Pollney and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: October 14, 1994
#
#
# Purpose: Perturbation expansion and truncation
#
# Revisions:
#
# Oct  14, 1994   Creation [pm]
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#-------------------------------------------------
# pexpand()
#
# - expand an expression and determine the order of
#   each term in the expansion (using the information
#   contained in the array pexpandArray).
#
# - truncate those terms whose order exceeds pOrder
#
#-------------------------------------------------

pexpand := proc(expr)

local newExpr, retVal, a;
# can't use remember, since pOrder could change
  
  if not assigned(pOrder) then
    ERROR(`Please assign pOrder before using pexpand`);
  elif not assigned(pexpandArray) then
    ERROR(`Please use pdefine before using pexpand.`);
  fi:

  newExpr := expand(expr);
  retVal := 0:

  if type(newExpr,`+`) then
    for a to nops(newExpr) do
      if pCost(op(a,newExpr)) <= pOrder then
         retVal := retVal + op(a,newExpr):
      fi: 
    od:
  elif pCost(newExpr) <= pOrder then
    retVal := newExpr:
  fi:
  retVal;
end:

#-------------------------------------------------
# pCost()
#
# - determine the cost of the expression. 
#
# - return an integer indicating the "order" of the
#   expression
#-------------------------------------------------

pCost := proc(expr)

local a, cost;
option remember;

  cost := 0:

  if type(expr,`*`) then
    #
    # for a product, add up the cost of each entry
    #
    for a to nops(expr) do
      cost := cost + pCost(op(a,expr)):
    od:

  #
  # (note that this case also handles 1/x etc.)
  #
  elif type(expr,`^`) then
    if type(op(2,expr),numeric) then
       cost := op(2,expr)*pCost(op(1,expr)):
    else
       pWarning(`Order of term ignores exponent`,expr);
       cost := cost(op(1,expr)):
    fi:
  
  elif type(expr,`+`) then
    #
    # can encounter such terms e.g. 1/(2m-r) in kerr expansion
    # Assign a cost based on the minumum cost of all ops
    #
    cost := min(seq( pCost(op(a,expr)), a=1..nops(expr))): 
  
  elif type(expr,numeric) then
    cost := 0:

  elif op(0,expr) = diff or op(0,expr) = Diff then
    #
    # can explicitly indicate order of derivative variables
    # Find the order of the expr being diff'ed and add to
    # it the order of the derivative variable
    #
    if assigned(pexpandArray[diffBy_.(op(2,expr))]) then
       cost := pCost(op(1,expr)) + pexpandArray[diffBy_.(op(2,expr))]
    fi:

  elif type(expr,{name,function,procedure}) then
    #
    # check to see if we have this name in our array of costs
    # (includes diff(r(t),t) etc.)
    #
    if assigned(pexpandArray[expr]) then
       cost := pexpandArray[expr]:
    fi:
   fi:
   cost;
end:

#-------------------------------------------------
# pdefine
#
# define the order of variables in an expression.
#
# Indicate these by lists in which the first entry
# indicates the order and remainder is variables of
# that order.
#
# diff/Diff order indicated by diffBy_.name (i.e. diffBy_t)
#
# Using pdefine(clear) clears out all old entries and 
# resets the remember tables.
#
# pdefine(display) shows the perturbation info.
#-------------------------------------------------

pdefine := proc()

local a,b,order:

global pexpandArray:

  if nargs = 1 and not type(args[1],list) then
    if args[1] = 'clear' then
       pexpandArray := 'pexpandArray':
       forget(pCost);
       forget(pexpand);
    elif args[1] = 'display' then
       if assigned(pexpandArray) then 
          print(pexpandArray);
          print(`pOrder ` = pOrder);
       else
          print(`Nothing defined`);
       fi:
    else
       ERROR(`Paramater must be clear, display or a list.`);
    fi:
    RETURN(`Done.`);
  fi:
  #
  # for parameters which are lists set up the
  # appropriate entries in pexpandArray
  #
  for a to nargs do
    if type(args[a],list) then
       if not type(args[a][1],numeric) then
         ERROR(`First entry in a list must numeric`):
       fi:
       order := args[a][1]:
       for b from 2 to nops(args[a]) do
         pexpandArray[args[a][b]] := order:
       od:

    else
       lprint(`Argument `,args[a],` is not a list - ignoring.`);
    fi:
  od:
  lprint(`Done`);
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
@a82 1
### WARNING: note that `I` is no longer of type `^`
d88 1
a88 1
       cost := codegen[cost](op(1,expr)):
d107 2
a108 2
    if assigned(pexpandArray[diffBy_||(op(2,expr))]) then
       cost := pCost(op(1,expr)) + pexpandArray[diffBy_||(op(2,expr))]
@


1.1.1.1.2.1.2.1
log
@Removed warning messages that were put in by updtsrc on R5->R6 conversion.
@
text
@d83 1
@


