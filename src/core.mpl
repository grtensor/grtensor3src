#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: core.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: Long ago
#
#
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#**********************************************************
# grF_core(objectName)
#
# Parameters:
#       objectName:     name of object
#
# Uses global variables:
#       grG_metricName:     name of the metric
#       grG_fnCode:         operation to be done
#       grG_simpHow:        type of simplification etc. (0=none)
#       grG_preSeq          parms for simpHow which preceed tensor comp
#       grG_postSeq         parms which go after tensor comp in simpHow
#       grG_calc            boolean to calculate components
#       grG_simp            boolean to invoke simplification
#       grG_callComp        boolean to invoke per component display routine
#
# Sets the global variable:
#       grG_useDiffConstraint
#
#  To make expressing formulae in the object records quick and snappy the
#  indices used in tensor objects are global (with a trailing underscore).
#  They take names a1_ ... a4_
#  Sum indices are also like this (see indices.mpl)
#
# (This saves pointlessly long function argument lists. During a particular
#  set of grCore calls the same function, metric and simplfication routines
#  are used. This also implifies calls to the routines which do the per
#  component calculation.)
#
# If dependencies exist this routine is called recursivly, so be careful
# about keeping the appropriate variables local !
#
# Date          Reason
#
# Feb   2, 94    Added diff constraint support.
#
# May   9, 94    Added operator support. Use grF_checkIfAssigned
#                instead of grRecord.
#
# May  16, 94    Allow dependency functions as well as sets.
#
# May  31, 94    Added Aconstraints
#
# June  9, 94    Major changes to allow heirarchical operators.
#
# June 26, 94    Test that auxilary metrics are assigned
# Aug 30,  94    Added objectName. [pm]
# Apr  12, 95    Change printf(`\n`) to lprint() in status messages so
#                they are displayed as we go [pm]
# July  5, 95	 Add profiling option. [pm]
# Aug  22, 95    Add objectNameString [pm]
# Nov  15, 95    Allow multiply-def'ed objects to have different symFn [dp]
# Nov  22, 95    Fix expandOperands call (long lurking bug) [pm]
# Nov  25, 95    Remove junction trace msg. [pm]
# Nov. 27, 95    Pass multiple def'd name to calc/preCalc fns [pm]
# Jul. 11, 96    Moved `Calculating..' prompt to display before calculation[dp]
# Nov. 14, 96    Fix output of `all components zero` for matrices/vectors [dp]
# Sep. 19, 97    Added support for grC_ZERO to accommodate initzero [dp]
# Dec.  5, 96    Added grOptionMessageLevel [dp]
# Feb  14, 97    Switch convert(x,string) to convert(x,name) for R5 [dp]
#**********************************************************

grF_core := proc(objectParm, externalCall)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
#option trace;
#
# objectName:   name of the object to operate on
# externalCall: flag to indicate if called from a user or interface
#               routine or not. If true then want to set up the
#               globals, if false leave them alone.
#
global  grG_displayZero, grG_objectName, grG_metricName, grG_constraint,
        grG_operands, grG_baseObject, grG_fnCode, grG_firstObj,
	      grG_profileList, grG_profileTimer, grG_profileCount, grG_profileSize,
        grG_lastHeader, grG_ObjDef:

local a,  t, toc, root, entry, objectName, objectNameString,
      operandSeq, dependSet, calcFn, preCalcFn, symFn,
      fullName, metricName, oldObjectName, indexed;

#
# WARNING: The order of chunks of code in here is critical
# THINK BEFORE YOU MOVE STUFF AROUND!
#

  #*** setup variables for the symmetry routine
  #
  # METRIC NAME ??
  #
  # metric names are present in the object list to indicate
  # which metric we should be working in. On encountering one
  # just change the metric name and return.
  #
  if member( objectParm, grG_metricSet) then
    grG_metricName := objectParm:
    grG_lastHeader := NULL:
    RETURN():
  fi:

  toc := time(): # start the timer

  #
  # if the name is indexed (i.e. W1I[schw], R[schw](dn,dn) )
  # then form a plain name (i.e. W1I, R(dn,dn)
  #
  indexed := false:
  if grF_isIndexed( objectParm) then
      #
      # Pull apart the name
      #
      indexed := true:
      if type( objectParm, function) then
          objectName := op(0, op(0,objectParm))(op(objectParm)):
      else
          objectName := op(0,objectParm):
      fi:

  else
      objectName := objectParm:
  fi:

  # init the profiling vars
  grG_profileList := [];
  grG_profileTimer := 0:
  grG_profileCount := 0:
  grG_profileSize := 0:

  grG_displayZero := true:    # global flag set by grF_components
                              # (I KNOW it's ugly)
  #
  # MULTIPLE DEFS ??
  #
  # check if an objectName is assigned.
  # (this comes into play if there are multiple defintions
  #  for an algorithm and ensures that this is hidden from
  #  the user. i.e. R2(dn,dn) is displayed as R(dn,dn) )
  #
  grF_expandOperands(objectParm):
  oldObjectName := objectName:
  if assigned(grG_ObjDef[objectName][grC_displayName]) then
      objectName := grG_ObjDef[objectName][grC_displayName]:
  fi:
  objectNameString := convert(objectName, name):

  root := grG_ObjDef[objectName][grC_root]:

  # Assign calcFn based on calcFn attached to original object name.
  # Assign preCalcFn based on preCalcFn attached to original object name.
  # Assign symFn based on original object name if an alternate symmetry 
  # has been specified, otherwise use the standard sym for that object.
  #
  if grG_fnCode=grC_ZERO then
    calcFn := grF_zeroCalcFn:
  else
    calcFn := grG_ObjDef[oldObjectName][grC_calcFn]:

    if assigned ( grG_ObjDef[oldObjectName][grC_preCalcFn] ) then
      preCalcFn := grG_ObjDef[oldObjectName][grC_preCalcFn]:
    fi:
  fi:

  if assigned ( grG_ObjDef[oldObjectName][grC_symmetry] ) then
    symFn := grG_ObjDef[oldObjectName][grC_symmetry]:
  else
    symFn := grG_ObjDef[objectName][grC_symmetry]:
  fi:

  #
  # set the name of the object being calced for grF_clearObject
  # (Yes, this is ugly)
  #
  grG_objectName := objectName:

  #
  # SET THE GLOBALS
  #
  fullName := grF_expandOperands(objectParm):

  #
  # BUILD THE OPERAND SEQUENCE FOR OPERATORS
  #
  grG_operands := NULL:
  if assigned( grG_ObjDef[objectName][grC_operandSeq]) then
    for a in grG_ObjDef[objectName][grC_operandSeq] do
      grG_operands := grG_operands, grG_||a:
    od:
    #
    # for operators include the operands in the objectNameString
    #
    objectNameString := convert( cat( objectName,  
              convert([grG_operands], name)), name):
  fi:

  #
  # DISPLAY THE HEADER
  # (if this is a grdisplay call)
  #
  if grG_fnCode = grC_DISP and
     assigned(grG_ObjDef[objectName][grC_header]) then
       grF_displayHeaders ( objectName ):
  fi:

  # IF A ONE OR TWO INDEX OBJECT IS BEING DISPLAYED, 
  # SEE IF IT CAN BE DISPLAYED AS AN ARRAY.
  # (if so, then grG_fnCode is set to grC_tmpNoDISP so that
  # no further action is taken on it this time through.
  # grG_fnCode is then reset at the end of core.
  #
  if grG_fnCode = grC_DISP
	and type ( objectName, function )
	and not assigned ( grG_ObjDef[objectName][grC_displayFn] )
	and ( nops(objectName)=1 or nops(objectName)=2 ) then
	    grG_fnCode := grF_slickdisplay ( objectName ):
  fi:

  #
  # TEST AUXILARY METRIC ARE ASSIGNED
  #
  if grG_calc and assigned( grG_ObjDef[objectName][grC_auxMetrics]) then
    for a in grG_ObjDef[objectName][grC_auxMetrics] do
      if not assigned( grG_metricName||a) then
        printf ("Auxillary metric name not assigned.\n"):
        printf (" Use e.g 1=rw as an argument in grcalc.\n"):
        ERROR("No Auxillary metric"):
      fi:
    od:
  fi:

  #
  # PRECALC
  #
  # if there is a pre-calc function assigned and calc then run preCalcFn
  # (some functions use this as a more efficent way to calculate the
  # tensor components. In general nicer not to use these)
  if grG_calc and type( preCalcFn, procedure) then
       preCalcFn(oldObjectName);
 fi:

#printf ("precalc done\n"):
  #
  # MAIN ROUTINE
  #
  #** now call the symmetry routine which does the work
  # (it should return NULL)

  if NULL <> symFn(oldObjectName, root, calcFn) then
    ERROR("Internal error-symmetry function did not return NULL", symFn ):
  fi:
   
  # ASSIGNED FLAG
  #
  # if calc then set the assignedFlag
  #
  if grG_calc then
     if indexed then
	#
	# this is BOGUS. Need to ensure that default
	# operands get placed in here!
	# temporary kludge.
	#
	grF_assignedFlag(objectParm,set):
     else
	grF_assignedFlag(objectName,set):
     fi:
  fi:

  #
  # DISPLAY ALL ZERO ?
  #
  # if all components are zero and displaying then say this
  # (this is tensor dependent at present!)
  #
  if grG_fnCode = grC_DISP and grG_displayZero then
    if grG_ObjDef[objectName][grC_symmetry] = grF_sym_scalar then
       print(grG_ObjDef[objectName][grC_rootStr] = 0):
    else
       if assigned ( grG_ObjDef[objectName][grC_displayFn] ) then
          objectNameString := grG_ObjDef[objectName][grC_displayFn]
		( objectName, [] ):
       elif member ( nops ( grG_ObjDef[objectName][grC_indexList]), {1,2} )
	  then
          objectNameString := grF_symbTensorName ( objectName ):
       fi:
       print(objectNameString = `All components are zero`):
    fi:
  fi:

  #
  # STATUS MESSAGE
  #
  #
  if grOptionTrace then
    if grG_fnCode = grC_CLEAR then
        printf ("Cleared  %a for the %a metric.\n", objectNameString, 
           grG_metricName):
    elif grG_calc then
	t := time()-toc;
        if grOptionTimeStamp and grOptionMessageLevel > 0 then
	  printf ("Calculated %s for %a (%f sec.)\n",
	    objectNameString, grG_metricName, t):
        fi:
	if grOptionProfile then
	  if grG_profileCount > 0 and t > 0.00000001 then
             printf ("\n profile: %d non-zero, avg. size. %6.1f, simp. = %4.1f percent. \n",
		grG_profileCount, evalf(grG_profileSize/grG_profileCount),
		evalf(100*grG_profileTimer/t) );
	     printf ("Non-zero size list: \n",grG_profileList);
	  else
	    printf (" no non-zero components or time=0.\n");
	  fi:
	fi:
	#
        # check if object used additional metrics, if so then
        # mention them explicitly
        #
        # Obsolete clause ???
        #
        if has( grG_ObjDef[objectName][grC_depends], grG_reqMetric) then
          # scan through the list and print them out
          printf("using:\n");
          for a to nops( grG_ObjDef[objectName][grC_depends]) do
            entry := grG_ObjDef[objectName][grC_depends][a]:
            if type (entry, indexed) then
               printf("  metric[%d] = %a", op(entry),
                         grG_metricName||(op(entry)) ):
            fi:
          od:
        fi:
    fi:
  fi:
  if grG_fnCode = grC_tmpNoDISP then
	grG_fnCode := grC_DISP:
  fi:

NULL;
end: # tensorCore()

