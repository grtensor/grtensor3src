#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: COMMANDS.MPL
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date:
#
#
# Purpose: GRTensor user interface commands
#
# Revisions:
#
# April 30, 1994  Change grF_checkIfDefined to allow cdn, cup.
#
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#------------------------------------------------
# commands.mpl
#
# File contains the main user commands for GRTensorII
#
# grclear
# grcalc
# grdisplay
# grcalcalter
#
# Jan  13, 94    Fixed grmap. grmap(CMW) failed because CMW is compound.
# Jan  18, 94    Added grOptionAlterSize
# Jan  27, 94    Fixed grcomponent so it works for scalars with [] as arg.
# Feb   2, 94    Added differential constraint support.
# Mar   1, 94    Major re-write of parse. Fix Cstar bug.
# May  18, 94    Move support routines to cmd_sup. Add operators.
# July  5, 94    Operator support in grcomponent
# July 30, 94    Added constraints to gralter menu. Cosmetic grmap fix.
# Aug  28, 94    Tidy up grclear() some more. Document (blush) [pm]
# Aug  29, 94    Remove grsave. Change grapply to grmap style parms. [pm]
# Sept. 8, 94    Support for simplification names in gralter [pm]
# Mar  10, 95    Add grOptionTermLength to groptions(). [dp]
# Mar  10, 95    Tidy up grdisplay() so redundant headers are not displayed[dp]
# Mar  10, 95    Add grsaveg().
# May   9, 96    Add grcalcd(). Added grOptionqloadPath to groptions() [pm]
# June 10, 96    Fixed up grcalc1() [dp]
# June 28, 96	 Re-assign grG_metricName in grmetric() [dp]
# July  4, 96    Fixed coordinate assignment in grsaveg() [dp]
# Aug  20, 96    Fixed reading of simp functions in grcalcalter() [dp]
# Feb   5, 97    Add assignment of complexSet_ to grmetric() [dp]
# Dec   5, 97    Added grOptionMessageLevel [dp]
# Aug  18, 99    Switched readstat and grF_my_readstat to grF_readstat [dp]
# Aug  20, 99	 Changed use of " to ` for R4 compatibility [dp]
#------------------------------------------------------------------------------

macro ( grG_g = 1 ):
macro ( grG_ds = 2 ):
macro ( grG_basis = 3 ):
macro ( grG_np = 4 ):
macro ( grG_maxTermLength = grOptionTermSize ):

#-------------------------------------------------------------------
# Some routines (grsaveg in particular) make some use of a structure, G.
# G has the following sub-elements:
#	G.gname := name of metric/basis.
#	G.gdim  := dimension of entry.
#	G.gtype := type of entry = { grG_g, grG_ds, grG_basis, grG_np}
#	G.basisu:= contravariant components of the basis, if they exist; or
#		   0 if they do not.
#	G.basisd:= covariant components of the basis, if they exist; or
#		   0 if they do not.
#	G.metric:= components of metric for gtype = {grG_g or grG_ds}; or
#		   components of basis inner product for gtype = {grG-basis, or
#		   grG_np}.
#
#-------------------------------------------------------------------


#//////////////////////////////////////////////////////////
#
# COMMAND INTERFACE ROUTINES
#
# The defintions for the primary user commands are here.
# For an explanation of a proto-type command see grcalc.
#
#//////////////////////////////////////////////////////////

#********************************************************************
# grapply(objectSeq, funct, fileName, parmList)
#
# Apply the function <funct> to the objects in <objectSeq>
# sending the output to <fileName>. Additional parameters to
# <funct> are held in <parmList>.
#
# It is assumed that the component is to be the first operand
# to <funct> ?
#
#********************************************************************

grapply :=  proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_fnCode, grG_simp, grG_calc, grG_callComp, grG_postSeq,
        grG_preSeq, grG_simpHow;
local i, new_args, lastArg, fileName, funct, parmSeq, last, pStart,k,j;

  #
  # first check the arg list. If C is asked for need
  # to read the library so screenArgs will stop when
  # it hits the function name (otherwise it would be
  # unassigned and treated as a scalar)
  #
  for i to nargs do
    if args[i] = C then
### WARNING: persistent store makes one-argument readlib obsolete
      readlib(C):
    fi:
  od:

  new_args := grF_screenArgs([args], true, false);
  grG_preSeq := NULL:
  grG_postSeq := NULL:
  #
  # scan arguments for the procedure
  #
  pStart := 0:
  for k from 2 to nargs do
    if type( args[k], procedure) then
       pStart := k:
       funct := args[k]:
       break:
    fi:
  od:
  if pStart = 0 then
    ERROR(`Cannot find a procedure name in parameters to grmap`):
  fi:

  #
  # extract the pre sequence parameters
  #
  for k from pStart+1 to nargs while args[k] <> 'x' do
    grG_preSeq := grG_preSeq, args[k]:
  od:
  if args[k] <> 'x' then
    ERROR(`Did not indicate component argument with 'x'. `);
  fi:
  #
  # fill in the post sequence paramters. Last argument may be
  # a file= statement. If not use `terminal` as the file name.
  #
  last := nargs:
  if type(args[nargs], equation) and lhs(args[nargs]) = file then
    fileName := rhs(args[nargs]):
    last := last -1:
  else
    fileName := `terminal`:
  fi:
  for j from k+1 to last do
     grG_postSeq := grG_postSeq, args[j]:
  od:
  #
  # set the global variables for core.
  #
  grG_fnCode := grC_APPLY:
  grG_simpHow := funct,fileName: # piggy back function/fileName on simpHow
  grG_simp := false: # this must be before simpDecode
  grG_calc := false:
  grG_callComp := true:
  printf("# For the %a metric \n", grG_metricName):
  #
  # pretest the fileName (and clear it out) by a dummy write
  #
  if fileName != `terminal` then
    fd := fopen(fileName, WRITE):
    fprintf (fd, "\n"):
    fclose(fd):
  fi:
  #
  # get to work
  #
  for i to nops(new_args) do # don't use 'in' or 'map' !
    grF_core(new_args[i],true);
  od;

end:

#----------------------------------------------------------
# gralter( objectSeq, howSeq)
#
# Alter each of the objects in <objectSeq> according to the
# simplification choices indicated in howSeq. If howSeq is
# not specified, present a menu.
#
# Relies on gralterGuts() for the simplification menu and
# decoding (since this is also common to grcalcalter() ).
#
#----------------------------------------------------------

gralter := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_calc, grG_simp, grG_callComp, grG_fnCode, grOptionMessageLevel, grOptionAlterSize;
local i, howSeq, lastObj, gname, new_args;
     #
     # allow multiple objects and multiple simplification routines
     # scan backwards from end of the list to determine how many
     # simplification codes were specified
     #
     new_args := grF_screenArgs( [args], true, false);
     gname := grG_metricName:
     howSeq := NULL:
     for i from nargs by -1
         while (type(args[i], {integer,procedure}) 
               or member(args[i], grG_simpHowSet)) do
	howSeq := args[i], howSeq:
     od:
     if grOptionMessageLevel > 0 then
       printf("Component simplification of a GRTensorII object:\n\n"):
     fi:

     # set globals for the core
     grG_calc := false:
     grG_simp := true:
     grG_callComp := grOptionAlterSize:
     grG_fnCode := grC_ALTER:
     gralterGuts(new_args,[howSeq],grC_ALTER):
end:

#----------------------------------------------------------
# grclear(objectSeq)
# - clear the objects named.
# - `metric` triggers clearing of EVERYTHING
# - `results` triggers clearing of everything but the metric
# - yes arg must be an integer
#----------------------------------------------------------

grclear :=  proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_metricName, grG_metricSet, grG_default_metricName,
        gname, grG_fnCode, grG_simpHow, grG_preSeq, grG_postSeq,
        grG_simp, grG_calc, grG_callComp, genObjSet, metricObjSet,
	basisObjSet, grG_calcFlag;
local i, yorn, new_args, mName, newMetricFlag:

  newMetricFlag := false:
  genObjSet := { x(up), dimension, Info, constraint }:
  metricObjSet := { g(dn,dn), ds }:
  basisObjSet := { e(bdn,up), e(bdn,dn), eta(bup,bup), eta(bdn,bdn) }:
  #
  # check for the keywords `results` or `metric`
  #
  if member ( results, {args} ) or member ( metric, {args} ) 
    or member ( spacetime, {args} ) then
    #
    # ask for confirmation (unless given on the command line)
    #
    gname := grG_metricName:
    if not type (args[nargs], integer) then
      if member ( results, {args} ) then
        yorn := grF_input ( 
          `Clear the results derived from the spacetime `||gname||`? (yes=1;)`, 0, `grclear`):
      elif member ( metric, {args} ) then
        yorn := grF_input (
          `Clear the metric `||gname||` and all results? (yes=1;)`, 0, `grclear` ):
      elif member ( spacetime, {args} ) then
        yorn := grF_input (
          `Clear the spacetime `||gname||` and all results? (yes=1;)`, 0, `grclear` ):
      fi:
    else
      yorn := args[nargs]:
    fi:
    if not(yorn = 1) then
      ERROR(` confirmation failed`);
    fi:
  fi:

  #
  # get the metric name manually
  #
  if member(args[1], grG_metricSet) then
    grG_metricName := args[1]:
  else
    grG_metricName := grG_default_metricName:
  fi:

  #
  # build a list of objects to be cleared
  #
  if member( metric, {args}) then
    if not grF_assignedFlag ( eta(bup,bup), test ) then
      new_args := [ op ( { grF_assignedObjects ( grG_metricName ) }
        minus basisObjSet ) ]:
    else
      new_args := [ op ( 
        { grF_assignedObjects ( grG_metricName ) } minus genObjSet
        minus basisObjSet ) ]:
    fi:
    #
    # if a basis has not been defined, choose a new metric name from
    # the list to be the new default metric.
    #
    if not grF_assignedFlag ( eta(bup,bup), test ) then
      newMetricFlag := true:
    fi:
  elif member ( results, {args} ) then
    new_args := [ op ( { grF_assignedObjects ( grG_metricName ) }
      minus basisObjSet minus metricObjSet minus genObjSet ) ]:
  elif member ( spacetime, {args} ) then
    new_args := [ grF_assignedObjects ( grG_metricName ) ]:
    newMetricFlag := true:
  else
    new_args := grF_screenArgs( [args], true, false):
  fi:

  #
  # now do the actual clearing
  # set the globals for clearing
  #
  mName := grG_metricName:
  if new_args <> NULL then
    for i in new_args do
      grF_clear ( i ): # defined in cmd_sup
      if member( i, grG_metricSet ) then
        mName := i:
      else
        printf ( `Cleared %a for the %a metric.\n`, i, mName ):
      fi:
    od:
  fi:
  gc(): # collect garbage
  if newMetricFlag then
    grF_pickNewMetric():
  fi:
end:

grF_pickNewMetric := proc ()
global grG_metricSet, grG_default_metricName:
  grG_metricSet := grG_metricSet minus { grG_metricName }:
  if grG_metricName = grG_default_metricName then
    if grG_metricSet = {} then
      grG_default_metricName := NULL;
    else
      grG_default_metricName := grG_metricSet[1]:
      printf ( "\nThe default spacetime is now %s", grG_default_metricName ):
    fi:
  fi:
end:

#************************************************
# grcalc(objectSeq)
#
# Calculate the objects in <objectSeq>.
#************************************************

grcalcd := proc() 
   grcalc(args); 
   grdisplay(args); 
end:

grcalc :=  proc()
local tic:
global grOptionMemory;
     tic := time(); # time the command
     grF_calcObj ( args ):
     print(`CPU Time ` = time()-tic);
     if assigned( grOptionMemory) then
        print(`Memory Used (K bytes)` = evalf(status[2]*4/1024) );
     fi:
     gc();
end:

#------------------------------------------------------------------------------
# calcObj - calculate object without time header
#------------------------------------------------------------------------------
grF_calcObj := proc ( )
global  grG_fnCode, grG_simp, grG_calc, grG_callComp, grOptionDefaultSimp:
local	i:
     grF_unassignLoopVars(); # do this so aux metric names are cleared
     for i in grF_screenArgs([args], false, true) do
       #
       # set the global variables
       #
       grG_fnCode := grC_CALC:
       grG_simp := true: # this must be before simpDecode
       grG_calc := true:
       grG_callComp := false:
       grF_simpDecode ( grOptionDefaultSimp, grG_metricName ): # returns string
       #
       # The user list may be of the form:
       #   R(dn,dn), R[schw](dn,dn) [ with rw the default metric]
       #
       # screen Args extracts metric names and adds them to the list
       # directly. In the case of objects to be calc'ed it adds the
       # dependencies. The result will be something like:
       #
       #   rw, g(up,up), ... R(dn,dn), schw, g(up,up), ... R(dn,dn)
       #
       grF_core(i, true):
     od:
end:


#------------------------------------------------------------------------------
# grcalc1 (  objectName, indexList ) 
# - calculate only a single component of an object 
#------------------------------------------------------------------------------

grcalc1 := proc()
option trace;
local gname, object, iList, coordNum_seq, a, b, root, calcFn,
	depends, operands, objectName, newArgs:
global gr_data, grOptionDefaultSimp:

  iList := []:
  newArgs := grF_screenArgs( [args[1]], false, false):

  if member(newArgs[ nops(newArgs)], grG_metricSet) then
    object := newArgs[nops( newArgs)-1]:
    gname := newArgs[nops(newArgs)-2]:
  else
    object := newArgs[nops( newArgs)]:
    gname := newArgs[nops(newArgs)-1]:
  fi:

  if nargs = 2 then
    iList := args[2]:
  fi:

  if nops(object) <> nops(iList) then
    ERROR ( `Number of indices in object and indexList do not match.` ):
  fi:

  # check that a calc function exists
  if not assigned(grG_ObjDef[object][grC_calcFn]) then
    ERROR(`No per-component calculation possible. Use grcalc().`):
  else
    calcFn := grG_ObjDef[object][grC_calcFn]:
  fi:
  for a in grG_ObjDef[object][grC_depends] do
      grF_calcObj ( gname, a ):
  od:

  coordNum_seq := grF_coordNumbers ( gname, iList ):

  for a to nops([coordNum_seq]) do
    a||a||_ := coordNum_seq[a]:
  od:

  grF_simpDecode( grOptionDefaultSimp, gname):
  root := grG_ObjDef[object][grC_root]:

  gr_data[root, gname, coordNum_seq ] := 
    grG_simpHow( grG_preSeq, calcFn (object, [coordNum_seq]), grG_postSeq):

  #
  # OPERATOR ?
  #
  # if do then need to build the operand sequence
  #
  grF_expandOperands( object ): # need to assign grG_metricName

  objectName := grF_objectName(object):
  if assigned( grG_ObjDef[objectName][grC_operandSeq]) then
    operands := gname, grF_objectOperands( object):
  else
    operands := gname:
  fi:
  printf ( "Calculated the %a component of %a for %a.\n", iList, object, 
    gname ):
end:

#----------------------------------------------------------
# grcalcalter
#
# Act as grcalc, but allow the user to explicitly indicate
# the simplification
#----------------------------------------------------------

grcalcalter := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_calc, grG_simp, grG_callComp, grG_fnCode;
local i, howSeq, new_args;
  # check for simpHow parameter
  new_args := grF_screenArgs([args], false, true ):
  #
  # if last arg is integer it is a simplification code
  #
  if new_args <> [] then
     howSeq := NULL:
     for i from nargs by -1
         while (type(args[i], {integer,procedure}) 
               or member(args[i], grG_simpHowSet)) do
	howSeq := args[i], howSeq:
     od:
     # set globals for the core
     grG_calc := true:
     grG_simp := true:
     grG_callComp := false:
     grG_fnCode := grC_CALCALTER:

     printf ("Simplification will be applied during calculation.\n\n");
     gralterGuts(new_args, [howSeq], grC_CALCALTER):
  fi:
end:

#----------------------------------------------------------
# grcomponent( object, iList)
#
#    object     generic object name
#    iList      index list
#               may be in coord number of name
#
# Return the value of the component of the object with
# indices as given (numerical or coord Name) in iList.
#
# If the object is a scalar, iList is not required.
#----------------------------------------------------------
grcomponent := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local object, objectName, iList, coordNum_seq,  a, b, operands,
      newArgs, gname:

  iList := []:
  #
  # use screenArgs so that e.g. Ricci -> R(dn,dn)
  #
  newArgs := grF_screenArgs( [args[1]], false, false):

  #
  # if object is not from the default metric screenArgs will
  # return e.g. schw, rw, R(dn,dn), schw
  #
  # if it is from the default metric it will return
  #  e.g. schw, R(dn,dn)
  #
  if member(newArgs[ nops(newArgs)], grG_metricSet) then
     object := newArgs[nops( newArgs)-1]:  # e.g. R[schw](dn,dn)
     gname := newArgs[nops(newArgs)-2]:
  else
     object := newArgs[nops( newArgs)]:  # e.g. R[schw](dn,dn)
     gname := newArgs[nops(newArgs)-1]:
  fi:

  objectName := grF_objectName(object):  # e.g. R(dn,dn)

  #
  # grab the second operand (if present)
  #
  if nargs = 2 then
    iList := args[2]:
  fi:

  coordNum_seq := grF_coordNumbers ( gname, iList ):
  #
  # OPERATOR ?
  #
  # if do then need to build the operand sequence
  #
  grF_expandOperands( object ): # need to assign grG_metricName

  if assigned( grG_ObjDef[objectName][grC_operandSeq]) then
    operands := gname, grF_objectOperands( object):
  else
    operands := gname:
  fi:
  if not assigned(
    gr_data[(grG_ObjDef[objectName][grC_root]),operands, coordNum_seq]) then
      ERROR(`The requested component has not been calculated.`):
  else
    gr_data[(grG_ObjDef[objectName][grC_root]),operands, coordNum_seq];
  fi:

end:

#------------------------------------------------------------------------------
# coordNumbers -  convert from coord name to number if required
#------------------------------------------------------------------------------
grF_coordNumbers := proc ( gname, iList )
global grG_coordStr;
local a, b, coordNumSeq:
  coordNumSeq := NULL:
  for a to nops(iList) do
    if not type( iList[a], integer) then
      for b to Ndim[gname] while iList[a] <> grG_coordStr[gname,b] do od:
      if iList[a] <> grG_coordStr[gname,b] then
        ERROR(`Unknown coord `= iList[a]);
      fi:
      coordNumSeq := coordNumSeq, b:
    else
      coordNumSeq := coordNumSeq, iList[a]:
    fi:
  od:
  RETURN(coordNumSeq):
end:

#********************************************************************
# grdisplay(objectSeq)
#
# Display the objects listed in objectSeq
#
#********************************************************************

grdisplay :=  proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_fnCode, grG_simp, grG_calc, grG_callComp, grG_lastHeader:
local i, new_args;
     new_args := grF_screenArgs([args], true, false):
     # set the global variables
     grG_fnCode := grC_DISP:
     grG_simp := false: # this must be before simpDecode
     grG_calc := false:
     grG_callComp := true:
     grG_lastHeader := NULL:
     for i to nops(new_args) do # don't use 'in' or 'map' !
       grF_core(new_args[i], true);
     od:
end:

#----------------------------------------------------------
# greqn2set()
# user command to convert a tensor equation into a set
#----------------------------------------------------------

greqn2set := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_eqnSet, grG_calc, grG_simp, grG_callComp, grG_fnCode, grG_simpHow, grG_preSeq, grG_postSeq;
local new_arg, i;
  new_arg := grF_screenArgs([args], true, false); # require already calc'd
  #
  # now simplify the object, but use grF_eqn2set to do so, this
  # just copies the set to grG_eqnSet (defined in miscfn.mpl)
  #
  grG_eqnSet := {}:

  # set globals for the core
  grG_calc := false:
  grG_simp := true:
  grG_callComp := false:
  grG_fnCode := grC_ALTER:
  grG_simpHow := grF_eqn2set:
  grG_preSeq := NULL:
  grG_postSeq := NULL:
  for i to nops(new_arg) do
    grF_core(new_arg[i], true);
  od:
  grG_eqnSet;
end:

#********************************************************************
# grmap(objectSeq,function,parm1,.,`x`,..parmN)
#
# Apply <function> to the objects in <objecySeq>. Anything after the
# function name is an argument to <function>
#
#********************************************************************

grmap :=  proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_preSeq, grG_postSeq, grG_simpHow, grG_calc, 
        grG_simp, grG_callComp, grG_fnCode, grOptionAlterSize;
local i, j, funct, k, new_args, argSeq, pStart;

  new_args := grF_screenArgs([args], true, false);
  grG_preSeq := NULL:
  grG_postSeq := NULL:
  #
  # scan arguments for the procedure
  #
  pStart := 0:
  for k from 2 to nargs do
    if type( args[k], procedure) then
       pStart := k:
       funct := args[k]:
       break:
    fi:
  od:
  if pStart = 0 then
    ERROR(`Cannot find a procedure name in parameters to grmap().`):
  fi:

  #
  # extract the pre sequence parameters
  #
  for k from pStart+1 to nargs while args[k] <> 'x' do
    grG_preSeq := grG_preSeq, args[k]:
  od:
  if args[k] <> 'x' then
    ERROR(`Did not indicate component argument with 'x'. `);
  fi:
  #
  # fill in the post sequence paramters
  #
  for j from k+1 to nargs do
     grG_postSeq := grG_postSeq, args[j]:
  od:
  #
  # set globals for the core
  #
  grG_simpHow := funct:
  grG_calc := false:
  grG_simp := true:
  grG_callComp := grOptionAlterSize:
  grG_fnCode := grC_ALTER:
  for i to nops(new_args) do
    if not member(new_args[i], grG_metricSet) then
      printf ("Applying routine %a to %a\n",funct, new_args[i]);
    fi:
    grF_core( new_args[i], true);
  od:

end:

#************************************************
# grmetric()
# - change the default metric
#************************************************
grmetric := proc(gname)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
   if not member(gname,grG_metricSet) then
     printf ("ERROR - metric name unknown.\n"):
   else
     grF_setmetric ( gname ):
     printf ("Default metric is now %a.\n", gname):
   fi:
end:

grF_setmetric := proc ( gname )
global  grG_default_metricName, grG_metricName:
  grG_default_metricName := gname:
  grG_metricName := gname:
  grF_setComplexSet ( gname ):
end:

#----------------------------------------------------------
# groptions(): Display the setting of option variables
#----------------------------------------------------------
groptions := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global
  grOptionDisplayLimit,
  grOptionAlterSize,
  grOptionCoordNames,
  grOptionTrace,
  grOptionVerbose,
  grOptionDefaultSimp,
  grOptionTermSize,
  grOptionTimeStamp,
  grOptionWindows,
  grOptionProfile,
  grOptionLLSC,
  grOptionMessageLevel,
  grOptionMapletInput;

	printf ("grOptionAlterSize     = %a\n", grOptionAlterSize);
	printf ("grOptionCoordNames    = %a\n", grOptionCoordNames);
	printf ("grOptionDefaultSimp   = %a\n", grOptionDefaultSimp);
	printf ("grOptionDisplayLimit  = %a\n", grOptionDisplayLimit);
	printf ("grOptionLLSC          = %a\n", grOptionLLSC);
  printf ("grOptionMapletInput   = %a\n", grOptionMapletInput);
	if assigned ( grOptionMetricPath ) then
  	  printf ("grOptionMetricPath    = %a\n", grOptionMetricPath );
	else
	  printf ("grOptionMetricPath    = (not assigned)\n");
	fi:	
        if assigned( grOptionqloadPath) then
           printf ("grOptionqloadPath     = %a\n", grOptionqloadPath );
        else
           printf ("grOptionqloadPath     = (not assigned)\n");
        fi:
	printf ("grOptionTermSize      = %a\n", grOptionTermSize );
	printf ("grOptionTrace         = %a\n", grOptionTrace);
	printf ("grOptionTimeStamp     = %a\n", grOptionTimeStamp);
	printf ("grOptionVerbose       = %a\n", grOptionVerbose);
	printf ("grOptionWindows       = %a\n", grOptionWindows);
	printf ("\n"):
	printf("grOptionDefaultSimp values: 0=None, 1=simplify, 2=simplify[trig],\n");
	printf("  3=simplify[power] 4=simplify[hypergeom], 5=simplify[radical],\n");
	printf("  6=expand, 7=factor, 8=normal, 9=sort, 10=simplify[sqrt]\n");
	printf("  11=simplify[trigsin]\n"):
end:




#-------------------------------------------------------------------
# grsaveg
#-------------------------------------------------------------------
grsaveg := proc ( )
global gr_data, grOptionMetricPath, grG_complexSet_, grG_metricName;
local 	a, b, G, req, metrictype, bupflag, bdnflag, gname, ndim, metricdir, savename, s,
        G_gname, G_sig, G_constraint, G_info, G_complex, G_coord, G_metric,
        G_basisu, G_basisd, G_gtype;

  if nargs < 1 then
    ERROR ( `Missing metric name parameter.` ):
  else
    savename := args[1]:
  fi:

	if not type ( savename, name ) then
		ERROR ( `Metric name must be of type NAME.` ):
	fi:

	G := evaln ( G ):

  if nargs = 2 then
    metricdir := args[2]:
  else
    metricdir := grOptionMetricPath:
  fi:
	gname := grG_metricName:
	G_gname := savename:
  ndim := Ndim[gname];
	G_gdim := Ndim[gname]:
	if assigned ( grG_constraint[gname] ) then
		G_constraint := grG_constraint[gname]:
	else
		G_constraint := evaln ( G_constraint ):
	fi:
	if assigned ( gr_data[Text_,gname] )  then
		G_info := gr_data[Text_,gname]:
	else
 		G_info := evaln ( G_info ):
	fi:
  if assigned ( grG_complexSet_[gname] ) then
    G_complex := grG_complexSet_[gname]:
  else
    G_complex := evaln ( G_complex ):
  fi:

        G_coord := [gr_data[xup_,gname,1]]:
	for a from 2 to ndim do
		G_coord := [op(G_coord), gr_data[xup_,gname,a]]:
	od:

	if grF_checkIfAssigned ( g(dn,dn) ) and grF_checkIfAssigned (
eta(bup,bup) ) then
		while not assigned ( req ) do
			s := sprintf ("Would you like to save:\n");
      s := cat(s, sprintf("    1) the metric [g(dn,dn)], or\n" )):
      s := cat(s, sprintf("    2) the basis vectors?")):
			req := grF_input (s, [], `grsaveg` ):
 			if not member ( req, { 1, 2 } ) then
				printf ("Invalid input. Please enter a 1 or 2.\n"):
				req := 'req':
			fi:
		od:
		if req = 1 then 
			metrictype := grG_g:
		else
			metrictype := grG_basis:
		fi:
	elif grF_checkIfAssigned ( g(dn,dn) ) then
		metrictype := grG_g:
	elif grF_checkIfAssigned ( eta(bup,bup) ) then
		metrictype := grG_basis:
	else
		ERROR ( `Unable to find a metric or basis vectors associated with`, gname ):
	fi:

	if assigned ( grG_sig_[gname] ) then
		G_sig := grG_sig_[gname]:
	else
		G_sig := evaln ( G_sig ):
	fi:

	if metrictype = grG_g then
		G_metric := array ( 1.. ndim, 1.. ndim ):
		for a to ndim do
			for b to ndim do
				G_metric[a,b] := gr_data[gdndn_,gname,a,b]:
			od:
		od:
	else
		bdnflag := false:
		bupflag := false:
		if grF_checkIfAssigned ( e(bdn,dn) ) and
grF_checkIfAssigned ( e(bdn,up) ) then
			req := 'req':
			while not assigned ( req ) do
				s := sprintf ("Would you like to save:\n"):
        s := cat(s, sprintf ("   1) covariant basis vectors,\n")):
        s := cat(s, sprintf ("   2) contravariant basis vectorsn" )):
        s := cat(s, sprintf ("   3) both?" )):
				req := grF_input ( s, [], `grsaveg` ):
				if not member ( req, { 1, 2, 3 } ) then
					printf ("Invalid input. Please enter 1, 2, or 3.\n"):
					req := 'req':
				fi:
			od:
			if req = 1 then
				bdnflag := true:
			elif req = 2 then
				bupflag := true:
			else
				bupflag := true:
				bdnflag := true:
			fi:
		elif grF_checkIfAssigned ( e(bdn,dn) ) then
			bdnflag := true:
		elif grF_checkIfAssigned ( e(bdn,up) ) then
			bupflag := true:
		else
			ERROR ( `Unable to determine basis vectors.` ):
		fi:

		G_metric := array ( 1..ndim, 1..ndim ):
		for a to ndim do
			for b to ndim do
				G_metric[a,b] := gr_data[etabupbup_,gname,a,b]:
			od:
		od:

		if bdnflag = true then
			G_basisd := array ( 1..ndim, 1..ndim ):
			for a to ndim do
				for b to ndim do
					G_basisd[a,b] := gr_data[ebdndn_,gname,a,b]:
				od:
			od:
		else
			G_basisd := 0:
		fi:

		if bupflag = true then
			G_basisu := array ( 1..ndim, 1..ndim ):
			for a to ndim do
				for b to ndim do
					G_basisu[a,b] := gr_data[ebdnup_,gname,a,b]:
				od:
			od:
		else
			G_basisu := 0:
		fi:
	fi:
	G_gtype := metrictype:
  grF_saveEntry ( metricdir,
            G_gdim, 
          G_gname, 
          G_gtype, 
          G_coord,
          G_constraint, 
          G_complex,
          G_info,
          G_metric,
          G_sig, 
          G_basisd,
          G_basisu):
end:
				
