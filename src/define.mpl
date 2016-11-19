#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: define.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: Long ago
#
#
# Purpose: Use routines for defining, saving and loading new objects.
#
#
# Revisions:
#
# Dec 31 1993   Add calls to allow string definitions.
# Feb 20 1994   Change to use Tensor_ internals
# Jun 20 1994   Add loadobj/saveobj
# Jun 25 1994   Support new style aux metrics
# Sep 18 1994   Code inspection changes [pm]
# Dec 14 1994   Check to see if auto-object creation can create the
#               required object [pm]
# Jun  7 1996	Added grundef and grundefine wrapper. [dp]
# Jul 29 1996	grsaveobj now saves sym-functions; also cleaned up output. [dp]
# Sep 16 1997	removed R3 type specifiers in proc headers [dp]
# Feb 14 1997   Switch convert(x,string) to convert(x,name) for R5 [dp]
# Feb 14 1997	Fixed parse of scalars on LHS of grdef expr [dp]
# Feb 24 1997	Fixed grundef() to clear calced obj, remove all indices [dp]
# Oct 18 1998	Changed savedef/loaddef to save grdef statements [dp]
#
#**********************************************************

#----------------------------------------------------------
# grdefine( newObject, symm, expr, subranges)
#
#           newObject   - name of new object (with listing indices)
#
#           symm        - object name (to get symmetries from)
#                         or {}
#                         [Eventually a perm list allowed also]
#
#           expr        - (optional) formula for the new object
#                         or a string definition
#
#           subRanges   - (optional) set of subranges for dummy
#                         indices ( e.g. { a=1..n[1]-1 )
#
# e.g.
#   grdefine( `T{^a ^b c}`, {}, `R{^a ^b ^c ^d} Chr{c d e}` );
#
# - expressions may also be in the form of Maple expressions
#   which make reference to Tensor_
#
# define a new tensorial object in terms of existing ones
# and functions of them.
#----------------------------------------------------------
(*
grdefine := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local   newObject, symm, expr, subRanges, # command args
	b, i,  newRoot, newObj, newISeq, objRoot, obj_lhs,
	obj_rhs, subList, indexList, newTensor,
        name_lhs, name_rhs:

global  grG_metricName, grG_metricName1, grG_metricName2, grG_metricName3,
        grG_metricName4, grF_DIFF, grF_INT, grG_ObjDef, grG_rootSet,
        grG_parseAuxMetrics;
  #
  # screen the arguments
  #
  if nargs < 2 then
	ERROR(`grdefine requires two or more arguments`):


  elif nargs = 4 then
	if not type( args[4], set) then
	  ERROR(`grdefine: argument 4 must be of type set`):
	fi:
	subRanges := args[4]:
  else
	subRanges := {}:
  fi:

  if type( args[1], name) then
     newTensor := grF_strToDef( args[1], true):
  else
     #
     # allow Tensor_ function also (used when equations formed)
     #
     if op(0,args[1]) = Tensor_ then
       newTensor := args[1]:
     else
       ERROR(`First argument must be of type name`):
     fi:
  fi:

  #
  # expand out the defining formula
  #
  if nargs > 2 then
	if type(args[3], name) then
	    expr := grF_strToDef( args[3], false ):
        else
            expr := args[3]:
	fi:
  fi:


  if nops(newTensor) > 1 then
	 #
	 # got back a tensor
	 #
	 newObject := op(1,newTensor)( op( op( 2,newTensor) ) ):
	 # put the listing indices somewhere safe
	 indexList := op(3, newTensor):
  else
	 newObject := newTensor:
	 indexList := []:
  fi:
  symm := args[2]: # extract the symmetry info
  if symm <> {} then
    grF_checkIfDefined (symm, check):
  fi:
  #
  # do type checking of args etc.
  #
  if symm <> {} then
	if not assigned( grG_ObjDef[symm][grC_symmetry]) then
	  ERROR(`second argument to grdefine must be an empty set or object name`);
	fi:
  else
	# no symmetry
  fi:

  # do this so that assignments work properly
  grF_unassignLoopVars();
  grF_unassignMetricNames():
  grG_parseAuxMetrics := {}:

  #
  # diff presents a problem with evaluation at the wrong time, so
  # use our own dummy function DIFF which we turn off during
  # definitions
  #
  grF_DIFF := 'grF_DIFF':
  grF_INT := 'grF_INT':

  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Step 1:
  # first get the listing indices
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  #
  # new object could be either a tensor or scalar
  #
  if type(newObject, function) then
	 newRoot := op(1,newTensor);
	 newObj := op(1,newTensor)( op( op(2,newTensor))): # want the generic name
							   # (i.e. with up,dn as args)
	 newISeq := op( op(2,newTensor)); # get a seq of e.g: u,d,d
  else
	 newRoot := newObject;
	 newObj := newObject:
	 newISeq := NULL:
  fi:
  #
  # Could we create this object automatically ?? If so do it.
  # 
  if not (traperror(grF_checkIfDefined(newObj, create)) = lasterror) then
	 printf(`This object has been created automatically, Definition (if any) was ignored\n`);
         RETURN():
  fi:

  #
  # build a list of equations which can substitute the
  # standard listing indices used by core (a1_, a2_ etc.) for the
  # arbitrary user indices. (e.g. alpha = a1_ etc.)
  # Important to assign them in order because
  # the symmetries imposed must match the permList.
  #
  subList := [];
  for b to nops(indexList) do
	 subList := [op(subList), indexList[b] = a||b||_ ];
  od:
 #
 # FILL IN THE REST OF THE DEFINITION
 #
 grG_ObjDef[newObj][grC_attributes] := {user_defined_}:
 grG_ObjDef[newObj][grC_header] := convert(newObj,name):
 grG_ObjDef[newObj][grC_root] := cat(newRoot,newISeq,_);
 grG_ObjDef[newObj][grC_rootStr] := convert(newRoot, name):
 grG_ObjDef[newObj][grC_indexList] := [newISeq]:

  #+++++++++++++++++++++++++++++++++++++++++++++++++++
  # Step 2: Examine expression
  #+++++++++++++++++++++++++++++++++++++++++++++++++++
  # is the formula an equation, or a basic object ??

  if nargs = 2 then
	# basic object, user will provide components
	grG_ObjDef[newObj][grC_preCalcFn] := grF_preEnterComp:
	grG_ObjDef[newObj][grC_calcFn] := grF_enterComp:
	grG_ObjDef[newObj][grC_depends] := {}:

  elif type( expr, list) then
     #
     # for vectors, allow the third argument to be the
     # component values of the vector for the default
     # metric
     #
     if nops(newISeq) > 1 then
        ERROR(`Only direct definition of vectors is allowed at present.`);
     fi:
     if not assigned(grG_default_metricName) then
        ERROR(`Load a metric first.`);
     fi:
     grG_ObjDef[newObj][grC_preCalcFn] := grF_preEnterComp:
     grG_ObjDef[newObj][grC_calcFn] := grF_enterComp:
     grG_ObjDef[newObj][grC_depends] := {}:  
     #
     # assign the components
     #
     grG_metricName := grG_default_metricName:
     if nops(expr) <> Ndim[grG_metricName] then
        ERROR(`Dimension of default metric and number of components are not equal`);
     fi:
     for b to nops(expr) do
        gr_data[newRoot||newISeq||_,grG_default_metricName,b] := expr[b]:
     od:
     grF_assignedFlag( newObj, set); # indicate this object has been calc'd
     printf(`Components assigned for metric: %a\n`,grG_metricName);
  
  elif type( expr, equation) then
	#
	# object is an equation. grdefine() the lhs and rhs seperatly
	# (since they may involve different numbers of summations)
	#
	# can we get into trouble with out of order indices ??
	# No, because subList refers to them by name.
	#

        b := NULL:
	b := seq( a||i||_, i=1..nops(indexList) );

	obj_lhs := subs( newRoot = lhs_||newRoot, newTensor):
	obj_rhs := subs( newRoot = rhs_||newRoot, newTensor):

        name_lhs := subs( newRoot = lhs_||newRoot, newObject):
        name_rhs := subs( newRoot = rhs_||newRoot, newObject):

	grdefine( obj_lhs, symm, lhs(expr) );
	grdefine( obj_rhs, symm, rhs(expr) );

	grG_ObjDef[newObj][grC_calcFn] := grF_calc_scalar:
	grG_ObjDef[newObj][grC_calcFnParms] :=
	   gr_data[(grG_ObjDef[name_lhs][grC_root]),grG_metricName,b]
	   = gr_data[(grG_ObjDef[name_rhs][grC_root]),grG_metricName,b]:
	grG_ObjDef[newObj][grC_depends] := {name_lhs, name_rhs}:

  else
	#+++++++++++++++++++++++++++++++++++++++++++++++++++++
	#
	# THE GUTS!
	# have some expression we must build a procedure for. This next statement
	# builds the required calcFn and adds the necessary terms to the
	# depends list
	#
	#+++++++++++++++++++++++++++++++++++++++++++++++++++++
	grF_calc_||newRoot||op(newISeq) :=
	  grF_buildCalcFn( expr, newObj, indexList, subList, subRanges):
	grG_ObjDef[newObj][grC_calcFn] := grF_calc_||newRoot||op(newISeq):
  fi:


 if grG_parseAuxMetrics <> {} then
   grG_ObjDef[newObj][grC_auxMetrics] := grG_parseAuxMetrics:
 fi:

 if symm = {} then
	 grG_ObjDef[newObj][grC_symmetry] := grF_findSymmetry (newObj, 
	   symm,nops([newISeq])):
 else
	 grG_ObjDef[newObj][grC_symmetry] := grG_ObjDef[symm][grC_symmetry]:
 fi:
 #
 # add to the root set (so we can raise & lower its indices automagically)
 #
 if newISeq = NULL then
   grG_rootSet := grG_rootSet union {cat(grG_,newRoot)}:
 else
   grG_rootSet := grG_rootSet union {cat(grG_,newRoot,_,nops([newISeq]))}:
 fi:

 printf(`Created definition for %a\n` ,newObj);
 #
 # turn on grF_DIFF
 #
 grF_DIFF := diff:
 grF_INT := int:

 NULL;

end:
*)



#----------------------------------------------------------
# grundef - set object definition to null
#----------------------------------------------------------
grundef := proc(object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_ObjDef;
local a, b, ilist, idxn, oname, cleared, gname:
  if grF_checkIfDefined (object, check) <> NULL then
    ERROR(`This object is not defined`);
  fi:
  #
  # make sure all instances of this object in any loaded
  # metrics have been deleted
  #
  gname := grG_metricName:
  
  if type ( object, function ) then
    ilist := NULL:
    idxn := nops ( object ):
    oname := op(0,object):
    for a to idxn do
      ilist := ilist, dn, up, bdn, bup:
    od:
    for a in combinat[permute] ( [ilist], idxn ) do
      if (traperror (grF_checkIfDefined (oname (op(a)), check)) <>
        lasterror) then
	cleared := false:
        for b in grG_metricSet do
          if grF_checkIfAssigned ( oname(op(a)), b ) then
            grclear(b, oname(op(a))):
	    cleared := true:
          fi:
        od:
        if cleared then
          grG_ObjDef[oname(op(a))] := grG_deleted:
          printf ( `Removed definition of object %a\n`, oname(op(a)) ):
	fi:
      fi:
    od:
  else
    for a in grG_metricSet do
      if grF_checkIfAssigned (object, a) then
        grclear(a, object);
      fi:
    od:
    grG_ObjDef[object] := grG_deleted:
    printf( `Removed definition of object %a\n`, object);
  fi:

  grF_setmetric (gname):
  grF_gen_rootSet(); # regenerate root set
end:

grundefine := proc(object)
  grundef(object):
end:









