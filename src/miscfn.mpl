###########################
# MISCFN.MPL
###
# Converted from 5.2 to 5.3
###########################
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: MISCFN.MPL
#
# File Created By: Peter Musgrave
#            Date:
#
# Purpose: Assorted houskeeping routines
#
# Revisions:
#
# April 30, 1994        Changed grF_gen_rootSet to allow cup,cdn.
# Dec    6, 1994	Changed grF_gen_rootSet to allow pup/pdn.
# Aug    5, 1995	Created grF_unassignMetricNames [dp]
# Apr    1, 1996        Add consr [pm]
# June   4, 1996	Added support for cbup, cbdn [dp]
# Sept  16, 1997	Removed R3 type specifiers in proc headers [dp]
# May    6, 1998	Added check to grF_unassignMetrics [dp]
# May   31, 1998	Reassign metrics only if metricstack assigened [dp]
# Jan   24, 1999	Fixed unassignLoopVars for >6 indices [dp]
# Jul   27, 1999        gen_root_set also assigns grG_usedNameList [dp]
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#********************************************************************
# Miscellaneous functions
#
# Definitions for:
# 
# consr
# kdelta
# grF_calcNull
# grF_clearObject
# grCosToSin
# grF_eqn2set           do the conversion
# grF_gen_rootSet
# grF_permSign
# grcomponent
# grF_unassignLoopVars
# grF_unassignMetricNames
# grF_reasignMetrics
# grF_findBaseObject
#
# Due to grF_gen_rootSet this file must be read in LAST when making
# GRTensorII
#********************************************************************

#----------------------------------------------------------
# kdelta
# (exported)
#----------------------------------------------------------
(*
Use in grdef broken for now...
kdelta := proc(i, j)
  if i = j then
     return 1;
  fi:
  return 0;
end proc:
*)

#----------------------------------------------------------
# grF_calcNull
# dummy calculation routine
#----------------------------------------------------------

grF_calcNull := proc(object,iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local root;
  # just return value of the object
  root := grG_ObjDef[object][grC_root]:
  gr_data[root,grG_metricName, op(iList)];
end:

#----------------------------------------------------------
# consr
# - apply constraints up to 5 times or until expression stops
#   changing
#----------------------------------------------------------
consr := proc(expr, subList)
  option `Copyright 1994-1996 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  local numTimes, newExpr, lastExpr:

  numTimes := 0:
  newExpr := expr:
  lastExpr := 0: # different from newExpr

  while ( (numTimes < 5) and (lastExpr <> newExpr)) do

      numTimes := numTimes + 1;
      lastExpr := newExpr:
      newExpr := expand(subs( op(subList), newExpr)):
  od:

  normal(newExpr);

end:

#----------------------------------------------------------
# grF_eqn2set
# - copy the arg into the set and return the arg
#----------------------------------------------------------
grF_eqn2set := proc(value)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global  grG_eqnSet;
  if value <> ( 0=0 ) then
     grG_eqnSet := grG_eqnSet union {value}:
  fi:
  value;
end:

#----------------------------------------------------------
# grF_gen_rootSet
# scan through all objects defined and builds a set of the function names
# concated with the number of indices. This is used by checkIfDefined to
# determine if an object can be created by altering indices of an existing
# one.
#
# The root set consists of two types of entries:
#   R(dn,dn) -> grG_R_2  (since it has two indices)
#   R(dn,dn,cdn) -> grG_R_2_1 (since it has 2 "normal" indices, and
#                   one CoD index.
#
# Called during the "make" and as part of grlib or grloadobj.
#----------------------------------------------------------

grF_gen_rootSet := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_rootSet, grG_usedNameSet, grG_ObjDef:
local a,b,c,cb,pb,p,objSeq, i:

  objSeq := indices(grG_ObjDef):
  grG_rootSet := {}:
  grG_usedNameSet := {}:
  for a in objSeq do
    b := op(a): # elements of a are lists, shed their listness
    if grG_ObjDef[b] <> grG_deleted then
      if type(b, function) then
         if has(b, {cup,cdn,pup,pdn,cbup,cbdn,pbup,pbdn}) then
           #
           # need to count the number of coD indices present
           #
  	   c := 0:
	   p := 0:
           cb:= 0:
           pb:= 0:
           for i to nops(b) do
             if   member ( op(i,b),   {cup,cdn} ) then
               c := c + 1:
             elif member ( op(i,b),   {pup,pdn} ) then
               p := p + 1:
             elif member ( op(i,b), {cbup,cbdn} ) then
               cb := cb + 1:
             elif member ( op(i,b), {pbup,pbdn} ) then
               pb := pb + 1:
             fi:
           od:
           i := nops(b) - c - p - cb:
           grG_rootSet := grG_rootSet union {cat(grG_,op(0,b),_,i,_,c,_,p,_,cb)}:
         else
           grG_rootSet := grG_rootSet union {cat(grG_,op(0,b),_,nops(b))}:
         fi:
	 grG_usedNameSet := grG_usedNameSet union {op(0,b)}:
      else # must be a scalar with no indices
         grG_rootSet := grG_rootSet union {cat(grG_,b)}:
	 grG_usedNameSet := grG_usedNameSet union {b}:
      fi:
    fi:

  od:
  RETURN():
end:

#----------------------------------------------------------
# grF_gen_calcFnSet
# - build a set of the built in calc functions so that when we
# run a grsavedef we only save the procedure bodies for functions
# which are not built in.
#----------------------------------------------------------

grF_gen_calcFnSet := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_calcFnSet, grG_ObjDef;
local a,b,objSeq;
  objSeq := indices(grG_ObjDef);
  grG_calcFnSet := {grF_enterComp, grF_calc_NULL};
  for a in objSeq do
    b := op(a): # elements of a are lists, shed their listness
    grG_calcFnSet := grG_calcFnSet union {grG_ObjDef[b][grC_calcFn]}:
  od:
end:

#----------------------------------------------------------
# grF_permSign
# - shuffle indices in permList by interchange of adjacent
# pairs until it matched the master list. Count the number
# of such shuffles and return 1 if there was an even number
# and -1 if not.
#----------------------------------------------------------

grF_permSign := proc( master, permList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, c, goal, permV, count, tmp:

goal := convert(master, array, 1..nops(master)):
permV := convert(permList, array, 1..nops(master)):

count := 0:

for a to nops(master) do
# for each entry in goal, find the entry in permV and
# shuffle it into place
  if goal[a] <> permV[a] then
     # find this entry in permV
     for b from a to nops(master) while (goal[a] <> permV[b]) do od:
     # now shuffle it back into place
     for c from b by -1 to a+1 do
       tmp := permV[c]:
       permV[c] := permV[c-1]:
       permV[c-1] := tmp:
       count := count + 1:
     od:
  fi:
od:

if type(count, even) then
	1;
else
	-1;
fi:
end:


#----------------------------------------------------------
# grF_unassignLoopVars
#
# Unassign the variables used as listing and dummy indices
# by the core routines. Used when want to define new entries
# in an ObjRecord
#----------------------------------------------------------

grF_unassignLoopVars := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global  a1_, a2_, a3_, a4_, a5_, a6_, a7_, a8_, a9_, a10_,
    a11_, a12_, a13_, a14_, a15_, a16_, a17_, a18_, a19_, a20_, a21_,
    a22_, a23_, a24_, a25_, a26_, a27_, a28_, a29_, a30_, a31_, a32_,
    s1_, s2_, s3_, s4_, s5_, s6_, s7_, s8_;
  a1_ := 'a1_':
  a2_ := 'a2_':
  a3_ := 'a3_':
  a4_ := 'a4_':
  a5_ := 'a5_':
  a6_ := 'a6_':
  a7_ := 'a7_':
  a8_ := 'a8_':
  a9_ := 'a9_':
  a10_ := 'a10_':
  a11_ := 'a11_':
  a12_ := 'a12_':
  a13_ := 'a13_':
  a14_ := 'a14_':
  a15_ := 'a15_':
  a16_ := 'a16_':
  a17_ := 'a17_':
  a18_ := 'a18_':
  a19_ := 'a19_':
  a20_ := 'a20_':
  a21_ := 'a21_':
  a22_ := 'a22_':
  a23_ := 'a23_':
  a24_ := 'a24_':
  a25_ := 'a25_':
  a26_ := 'a26_':
  a27_ := 'a27_':
  a28_ := 'a28_':
  a29_ := 'a29_':
  a30_ := 'a30_':
  a31_ := 'a31_':
  a32_ := 'a32_':

  s1_ := 's1_':
  s2_ := 's2_':
  s3_ := 's3_':
  s4_ := 's4_':
  s5_ := 's5_':
  s6_ := 's6_':
  s7_ := 's7_':
  s8_ := 's8_':
end:

#------------------------------------------------------------
# grF_unassignMetricNames
# - unassignLoopVars used to do this job too but in grF_makeD (create.mpl)
# we need to unassign the loopvars without unassigning the metric.
#------------------------------------------------------------
grF_unassignMetricNames := proc()
global	grG_metricName, grG_metricName1, grG_metricName2,
  grG_metricStack, grG_default_metricName:
  if assigned ( grG_metricName ) then
    grG_default_metricName := grG_metricName:
    grG_metricStack := grG_metricName, grG_metricName1, grG_metricName2;
    grG_metricName := 'grG_metricName':
    grG_metricName1 := 'grG_metricName1':
    grG_metricName2 := 'grG_metricName2':
  fi:
end:

#----------------------------------------------------------
# grF_reassignMetrics()
#
# recover metric names cleared with grF_unassignLoopVars()
#----------------------------------------------------------

grF_reassignMetrics := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global grG_metricName, grG_metricName1,
       grG_metricName2, grG_metricStack:

  if assigned( grG_metricStack) then
    grG_metricName := grG_metricStack[1]:
    grG_metricName1 := grG_metricStack[2]:
    grG_metricName2 := grG_metricStack[3]:
  fi
end:

