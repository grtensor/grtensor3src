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
        grG_||newRoot||newISeq||_[grG_default_metricName,b] := expr[b]:
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
	   grG_||(grG_ObjDef[name_lhs][grC_root])[grG_metricName,b]
	   = grG_||(grG_ObjDef[name_rhs][grC_root])[grG_metricName,b]:
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

#----------------------------------------------------------
# grloaddef
# - load the definition of object(s) from a file
#----------------------------------------------------------

grloaddef := proc( fileName )
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grF_DIFF, grF_INT, grG_newObjects:
local a:
	grF_DIFF := 'grF_DIFF':
	grF_INT := 'grF_INT':
	grF_unassignForDef();
	read fileName:
	printf ( `New objects: %a\n`, grG_newObjects ):
	for a in grG_newObjects do
	  if assigned (grG_ObjDef[a][grC_defineStr]) then
	    printf ( `Definition: %a\n`, grG_ObjDef[a][grC_defineStr] ):
          fi:
        od:
	grF_DIFF := diff:
	grF_INT := int:
        grG_newObjects := `grG_newObjects`:
end:

#----------------------------------------------------------
# grloadobj( objects)
#
# - load an object (and maybe it's definition)
#
# Key problem solved here is that saveobj only saves the
# principle components (i.e. ones reached by symmetry are not
# saved. To make these assignments, we need to do a fake
# calc and then shift in the correct principle value). We do
# this by using a fake calc function which references the
# principle value.
#
#----------------------------------------------------------

grloadobj := proc(metricName, fileName)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local a, iSeq, object, baseObjects, root, i:

global  grG_fnCode, grG_simp, grG_calc, grG_callComp, grG_temp,
        grG_metricName, grG_operands, grG_ObjDef:

  #
  # set globals, so they get the correct metric and operand parms
  #
  grG_metricName := metricName:
  grG_operands := NULL:
  read fileName:
  #
  # now for each object, check a definition exists, then
  # "calculate" it.
  #
  grG_fnCode := grC_CALC:
  grG_simp := true: # this must be before simpDecode
  grG_calc := true:
  grG_callComp := false;
  grF_simpDecode(grOptionDefaultSimp,grG_metricName): # returns string and
                                                      # sets some globals

  for a to nops(grG_savedObjects) do
    object := grG_savedObjects[a];
    if assigned( grG_ObjDef[object][grC_root]) then
     #
     # if the object is a scalar there are no symmetry
     # assignments to get right
     #
     if grG_ObjDef[object][grC_indexList] <> [] then
      root := grG_ObjDef[object][grC_root]:
      #
      # need to unassign the base objects, so that the symmetry
      # assignments point to the base object (and not its value)
      # in order for the simplfication to work.
      #
      if assigned ( grG_||(grG_ObjDef[object][grC_root] ) ) then
        baseObjects := indices( grG_||(grG_ObjDef[object][grC_root]) );
      else
        baseObjects := NULL:
      fi:
      #
      # may have picked up the same object for other metrics, screen
      # those entries out.
      #
      for i in {baseObjects} do # (recall baseObjects is a seq of lists)
        if i[1] = grG_metricName then
          #
          # move the root values into temporary storage and
          # unassign the root object.
          #
          grG_temp[op(i)] := grG_||root[op(i)];
          grG_||root[op(i)] :=  parse( cat(`'`, convert(grG_||root,name),
                               convert(i,name),`'`) ):
        fi:
      od:
      #
      # now invoke the symmetry routine directly
      # to "calculate" this object (which will
      # transfer in it's values from grG_temp)
      #
      if NULL <>
         grG_ObjDef[object][grC_symmetry](object, root, grF_loadObj) then
            ERROR(`Internal error-symmetry function did not return NULL`,
               grG_ObjDef[object][grC_symmetry] ):
      fi:
      #
      # now set the assigned flag, so we know it's been calculated
      #
      grF_assignedFlag(object, set):

     fi: # (not scalar)
    else
      printf(`Could not assign values for %a. No definition found.\n`,
                    object):
    fi:
    printf ( `Components of %a loaded.\n`, object ):
  od:
  grG_temp := 'grG_temp':
  printf(`Done.\n`):

end:

#----------------------------------------------------------
# grF_loadObj
#
# - calc function to recover the value from temporary storage,
#   and unassign the temporary storage
#----------------------------------------------------------

grF_loadObj := proc( object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 if assigned ( grG_temp[grG_metricName,grG_operands,op(iList)] ) then
   RETURN ( grG_temp[grG_metricName, grG_operands, op(iList)] );
 else
   RETURN ( 0 ):
 fi:
end:

#----------------------------------------------------------
# grsavedef( <objectSeq>, fileName)
# - save definition of a GRTensor object to a file
#----------------------------------------------------------

grsavedef := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grF_DIFF, grF_INT;
local a, b, argList, argSeq, fileName, object, objName,
      entries, entry;
 #
 # extract the last arg as the filename, then copy the others to
 # an array for passing in to screenArgs
 #
 if not type( args[nargs], name) then
   ERROR(`The last argument must be a name (the filename)`);
 fi:
 if nargs < 2 then
   ERROR(`Requires two or more arguments`);
 fi:
 fileName := args[nargs]:
 argSeq := NULL:
 for a to nargs-1 do
   object := args[a]: # cat has trouble with .args[a]
   grF_checkIfDefined (object, create);
   #
   # if it's an equation then add rhs_ and lhs_ to the list, but
   # better check some moron hasn't deleted them
   #
   if type( grG_ObjDef[object][grC_calcFnParms], equation) then
	 if type(object, name) then
	    grF_checkIfDefined (lhs_||object, create);
	    grF_checkIfDefined (rhs_||object, create);
	    argSeq := argSeq, lhs_||object, rhs_||object:
	 else
	#
	# cat makes lhs_.object -> lhs_.(Test(dn,dn,dn) ) which
	# checkIfDefined gags on
	#
	    objName := op(0,object);
	    grF_checkIfDefined (lhs_||objName(op(object)), create):
	    grF_checkIfDefined (rhs_||objName(op(object)), create):
	    argSeq := argSeq, lhs_||objName(op(object)),
			      rhs_||objName(op(object)):
	 fi:
   fi:
   argSeq := argSeq, object:
 od:
 argList := [argSeq]:
 writeto(fileName):
 grF_saveDef( argList):
 writeto(`terminal`);
 for a to nops(argList) do
   printf(`Saved definition of %a\n`, argList[a]):
 od:
 printf ("Done.\n");

end:

#----------------------------------------------------------
# grF_saveDef
#
# - write out the object definition.
# - called by grsavedef and grsaveobj
# - file already opened by the caller
# - arguments screened by the caller
#----------------------------------------------------------

grF_saveDef := proc(argList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

global  grF_DIFF, grF_INT;

local a, b, object, objName, entries, entry, symFnSet, oldverboseproc,
  gen_root_set;

 printf ( `#\n#--- Object definitions for GRTensorII ---\n#\n` ):
 printf ( `grG_newObjects := %a:\n \n`, {op(argList)} ):
 #
 # now change output to the file, and print assignment statements
 #
 grF_unassignForDef();

 # first, change DIFF, INT to inert form

 grF_DIFF := 'grF_DIFF':
 grF_INT := 'grF_INT':
 symFnSet := {}:
 oldverboseproc := interface ( verboseproc ):
 interface ( verboseproc = 2 ):
 gen_root_set := false:

 for a to nops(argList) do
   if assigned (grG_ObjDef[argList[a]][grC_grdefArgs]) then
     printf (`grdef(%a):\n`, op(grG_ObjDef[argList[a]][grC_grdefArgs])):
   else
     gen_root_set := true:
     printf ( `#\n#--- %a ---\n#\n`, argList[a] ):
     entries := indices( grG_ObjDef[ argList[a] ] ):
     for b in entries do
       entry := op(b): # strip off []
       if entry <> grC_calcFn and entry <> grC_symmetry then
          if not type ( grG_ObjDef[argList[a]][entry], name ) then
            printf ( `grG_ObjDef[%a][%a] := %a:\n`, argList[a], entry,
              grG_ObjDef[argList[a]][entry] ):
          else
            printf ( `grG_ObjDef[%a][%a] := ``%s``:\n`, argList[a], entry,
              grG_ObjDef[argList[a]][entry] ):
          fi:
       fi:
     od:
     #
     # handle the calcFn seperatly
     #
     printf(`\ngrG_ObjDef[%a][%a] := `, argList[a], grC_calcFn ):
     if member ( grG_ObjDef[argList[a]][grC_calcFn], grG_calcFnSet ) then
       printf ( `%a`, grG_ObjDef[argList[a]][grC_calcFn] ):
     else
       print (  grG_ObjDef[argList[a]][grC_calcFn] ):
     fi:
     printf ( `:\n` ):
     printf(`grG_ObjDef[%a][%a] := %a:\n`, argList[a], grC_symmetry,
       grG_ObjDef[argList[a]][grC_symmetry] ):
     if not member ( grG_ObjDef[argList[a]][grC_symmetry], symFnSet ) then
       symFnSet := symFnSet union { grG_ObjDef[argList[a]][grC_symmetry] }:
       printf ( `\n%a := `, grG_ObjDef[argList[a]][grC_symmetry] ):
       print ( grG_ObjDef[argList[a]][grC_symmetry] ):
       printf(`:\n`):
     fi:
     printf ( `\n` ):
   fi:  
 od:
 #
 # when file is read in, need to ensure that the new object is added
 # to the root set (what if there is a conflict ?)
 #
 if gen_root_set then
   printf (`grF_gen_rootSet():\n`):
 fi:
 grF_DIFF := diff:
 grF_INT := int:
 interface ( verboseproc = oldverboseproc ):
end:


#----------------------------------------------------------
# grsaveobj( objects, fileName)
#
# - save the component values of the objects indicated.
#
# - if the objects are user defined then save the definition as well
#
#----------------------------------------------------------

grsaveobj := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local oldArgs, newArgs, objects, i, a, fileName, defSeq:

 newArgs := seq(args[i], i=1..nargs-1):
 objects := NULL:
 for a in grF_screenArgs( [newArgs], true, false) do
   if not member(a, grG_metricSet) then
      objects := objects, a:
   fi:
 od:
 
 fileName := args[nargs]:
 #
 # for each object, set the metric name and any operands
 # grF_saveObj is a dummy function. Check for this fn name
 # in grcomponent.
 #
 grapply( newArgs, grF_saveObj, 'x', `[grG_metricName`, file=fileName);

 #
 # for each object, check if it's user defined. If so then save
 # the definition
 #
 defSeq := NULL:
 for a in [objects] do
   if assigned(grG_ObjDef[a][grC_attributes]) then
     if member( user_defined_,
                grG_ObjDef[a][grC_attributes]) then
       defSeq := defSeq, a:
     fi:
   fi:
 od:

 appendto(fileName):
 grF_saveDef([defSeq]):

 #
 # save the name of these objects, so that loadobj knows what's
 # in this file. (Need to save raw object names and remove any
 # metric references in square brackets)
 #
 printf(`grG_savedObjects := \n`):
 #
 # remove any metric names from newArgs
 #
 printf (cat(convert([objects],name),`:`)):
 writeto(`terminal`):
 printf ("Saved to %a\n", fileName):

end:

# dummy function for grapply. grcomp looks for this value

grF_saveObj := proc() 
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
end:

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









