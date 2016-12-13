#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: cmd_sup.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: May 7, 1994
#
#
# Purpose: COMMAND SUPPORT ROUTINES
#
# Revisions:
#
# May 10, 94    Moved code from command.mpl to here
#               Added grF_checkIfDefined and [] in object names.
# May 17, 94    Allow multiple default operands in grF_checkIfDefined
# June 15,94    MAJOR restructuring. Dependencies are now added to
#               the object list and not done in grF_core.
#               Added grF_checkObjects
# June 25, 94   Added auxillary metric names.
# July  4, 94   Fixed RiemSq(cdn,cdn) bug.
# Aug  18, 94   Revert to grCosToSin for now.
#               Fix checkObjects bug
#               Added grF_assignedObjects [pm]
# Aug  20, 94   Tidy up grF_screenArgs (redundant clauses)
# Aug  28, 94   Move gralterGuts here. Tidy up. [pm]
# Aug  29, 94   Use _ as a history mechanism in screenArgs. [pm]
#               Multiple calc functions in checkObjects
# Sept  1, 94   Fixed compound object bug. Added grF_clear. [pm]
# Sept  8, 94   Add simplification name support.
#               Fix grclear for operators typo [pm]
# Sept 16, 94   Fix R1[schw] when default=schw bug [pm]
# Dec   6, 94   Add pup/pdn support to chechIfDefined [pm]
# May  15, 95   Allow checkIfDefined to swallow metric names [pm]
# Sept. 1, 95   Allow simpHow code to be a procedure name 
#               Improve checking dependency efficency [pm]
# Feb  28, 96   Pass argList to useWhen functions in checkObjects [pm]
# Apr   1, 96   Add consr to simpDecode [pm]
# June  4, 96	Add support for cbup, cbdn, pbup, pbdn [dp]
# Feb   4, 97   Modify assignedFlag to check grG_calcFlag [dp]
# Feb  24, 97	checkIfAssigned accepts optional 2nd argument, gname [dp]
# Sept 16, 97	removed R3 type specifiers in proc arguments [dp]
# Dec   5, 97	added grOptionMessageLevel [dp]
# Feb  14, 97   Switch convert(x,string) to convert(x,name) for R5 [dp]
# Aug  18, 99   Switched readstat and grF_my_readstat to grF_readstat [dp]
# Aug  20, 99	Changed use of " to ` for R4 compatibility [dp]
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#
# set of all possible simplification routines
# (these correspond to menu entries below)
#
grG_simpHowSet := {none, simplify, trig, power, hypergeom,
### WARNING: note that `I` is no longer of type `radical`
   radical, expand, factor, normal, sort, sqrt, trigsin,
   cons}:

#------------------------------------------------------------
# gralterGuts
#
# Called by gralter() and grcalcalter()
#
# Decode the menu choices in how list and alter/calcalter
# the objects accordingly.
#
# If howList is empty present a menu of simplification routines
# and allow the user to choose.
#------------------------------------------------------------

gralterGuts:= proc(objectList, howList, fnCode)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_preSeq, grG_postSeq, howSize2, grG_simpHow;
local i, j, k, how, tic, howList2, userSeq, lastMenu, s;

# if simplification code(s) not given then promp for it

if howList = [] then
  s := printf("(use ?name for help on a particular simplification routine)\n\n"):
  s := cat(s, sprintf("Choose which routine to apply:\n")):
  s := cat(s, sprintf(" 0)  none\n")):
  s := cat(s, sprintf(" 1)  simplify()          try all simplification techniques\n")):
  s := cat(s, sprintf(" 2)  simplify[trig]      apply trig simplification\n")):
  s := cat(s, sprintf(" 3)  simplify[power]     simplify powers, exp and ln\n")):
  s := cat(s, sprintf(" 4)  simplify[hypergeom] simplify hypergeometric functions\n")):
  s := cat(s, sprintf(" 5)  simplify[radical]   convert radicals,log,exp to canonical form\n")):
  s := cat(s, sprintf(" 6)  expand()\n")):
  s := cat(s, sprintf(" 7)  factor()\n")):
  s := cat(s, sprintf(" 8)  normal()\n")):
  s := cat(s, sprintf(" 9)  sort()\n")):
  s := cat(s, sprintf("10)  simplify[sqrt,symbolic] allows sqrt(r^2) = r\n")):
  s := cat(s, sprintf("11)  simplify[trigsin]       trig simp biased to sin\n")):
  s := cat(s, sprintf("12)  Apply constraint equations\n")):
  s := cat(s, sprintf("13)  Apply constraints repeatedly\n"));
  s := cat(s, sprintf("14)  other user specified routine\n")):
  s := cat(s, sprintf("Number of routine to apply (followed by ;) >")):

  lastMenu := 14:
  how := grF_input(s, [], `gralter`);
  if nops([how]) = 1 then
      if (how < 0 or how > lastMenu) then 
         ERROR(`aborted`); 
      fi:
      if type(how,integer) and how = lastMenu then
         # user specified routine
         s := sprintf("\nEnter function name and arguments as a sequence (seperated by commas)\n");
         s := cat(s, sprintf("and indicate position of tensor component in argument list by 'x' (forward quotes).\n"));
         s := cat(s, sprintf("e.g. for collect(Riemann,r) enter >collect,'x',r;\n\n"));
         s := cat(s, sprintf(`Enter sequence (followed by ;) >`)):
         userSeq := grF_input (s, [], `gralter`);
         userSeq := [userSeq];
         DEBUG();
         # check input makes sense
         if nops(userSeq) < 2 then 
            ERROR(`two or more arguments required`);
         fi:
         if not ( type(userSeq[1],procedure) or type(userSeq[1],function) ) then
    	      ERROR(`first argument must be a procedure or function`);
         fi:
         # scan arguments for the procedure
         grG_preSeq := NULL;
         grG_postSeq := NULL;
         for k from 2 to nops(userSeq) while userSeq[k] <> 'x' do
            grG_preSeq := grG_preSeq, userSeq[k]:
         od:
         if userSeq[k] <> 'x' then
            ERROR(`Did not indicate component argument with 'x'. `);
         fi:
         for j from k+1 to nops(userSeq) do
    	      grG_postSeq := grG_postSeq, userSeq[j]:
         od:
     fi:

     howList2 := [how];
     howSize2 := 1;
  else
     howList2 := [how];
     howSize2 := nops(howList2):
  fi:
 
else # howlist empty
  # can't modify arguments of function, so resort to this
  howList2 := howList;
fi:

 tic := time();

  for i in howList2 do
   for j to nops(objectList) do
     if i <> lastMenu then
        #
	      # only decode if not user specified
        #
	      how := grF_simpDecode(i,grG_metricName): # this sets up the functions
        if not member( objectList[j], grG_metricSet) and
          grOptionMessageLevel>0 then
	           printf("Applying routine %a to object %a\n", how, objectList[j]);
        fi:
	      grF_core(objectList[j], true);
      else
        grG_simpHow := userSeq[1];
        if not member( objectList[j], grG_metricSet) and
            grOptionMessageLevel>0 then
            printf("Applying routine %a to %a\n",userSeq[1],objectList[j]);
        fi:
        grF_core(objectList[j], true);
      fi:
    od:
  od:

 if grOptionMessageLevel > 0 then
   print(`CPU Time ` = time()-tic);
   if assigned( grOptionMemory) then
      print(`Memory Used (K bytes)` = evalf(status[2]*4/1024) );
    fi:
 fi:
end:

#------------------------------------------------------------
# grF_simpDecode: decode simplifaction code and set global
# variables for grF_core. Return text message indicating the
# simplification routine.
#------------------------------------------------------------

grF_simpDecode := proc(how,gname)
	global  grG_preSeq, grG_postSeq, grG_simpHow, grG_simp, grG_constraint;
	grG_preSeq := NULL:
	grG_postSeq := NULL:
	if how = 8 or how = normal then 
                # most common default choice, put it a top of list.
		grG_simpHow := normal:
		`normal`;
	elif how = 0 or how = none then
		grG_simpHow := eval;
		`none`;
	elif how = 1 or how = simplify then
		grG_simpHow := simplify:
		`simplify`;
	elif how = 2 or how = trig then
		grG_simpHow := simplify:
		grG_postSeq := trig:
		`simplify[trig]`;
	elif how =  3 or how = power then
		grG_simpHow := simplify:
		grG_postSeq := power:
		`simplify[power]`;
	elif how = 4 or how = hypergeom then
		grG_simpHow := simplify:
		grG_postSeq := hypergeom:
		`simplify[hypergeom]`;
### WARNING: note that `I` is no longer of type `radical`
	elif how = 5 or how = radical then
		grG_simpHow := simplify:
### WARNING: note that `I` is no longer of type `radical`
		grG_postSeq := radical:
		`simplify[radical]`;
	elif how = 6 or how = expand then
		grG_simpHow := expand:
		`expand`;
	elif how =  7 or how = factor then
		grG_simpHow := factor:
		`factor`;
	elif how = 9 or how = sort then
		grG_simpHow := sort:
		`sort`;
	elif how = 10 or how = sqrt then
		grG_simpHow := simplify:
		grG_postSeq := sqrt,symbolic:
		`simplify[sqrt]`;
	elif how = 11 or how = trigsin then
### WARNING: persistent store makes one-argument readlib obsolete
    readlib(trigsin):
		grG_simpHow := simplify:
		grG_postSeq := trigsin:
		`simplify[trigsin]`;
	elif how = 12 or how = cons then
		grG_simpHow := subs:
		grG_preSeq := grG_constraint[gname]: # this is a list
		`Apply constraints`;
	elif how = 13 or how = consr then
		grG_simpHow := consr:
		grG_postSeq := grG_constraint[gname]: # this is a list
		`Apply constraints repeatedly`;
        elif type( how, name) then
                grG_simpHow := how:
	else
	       ERROR(`Cannot decode function`);
	fi:
end:


#----------------------------------------------------------
# grF_screenArgs
# extract metric name, check if objects are defined and
# perform substitutions for oldNames and compound names
# (i.e. CM -> R1, R2 etc.)
#----------------------------------------------------------

grF_screenArgs := proc(argParm, reqCalced, reqUncalced)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_metricName, object, grG_lastObjectSeq, grG_checkObjects_Cache:

#
# argParm: list of object names
# reqCalced: if true, also check if calc'd
# reqUncalced: if true, ensure not calc'd yet
#
local a, b, i, actual, actual2, start, calced,
      subMe, argList, subList, indexStuff,
      compound, operands, item, dependSet, objectName, returnSeq,
      metric, metricSeq, dummy:

  if not assigned(grG_default_metricName) then
     ERROR(`Please load a metric.`);
  fi:
  #
  # The use of _ as an object name indicates that the
  # object sequence used previously is to be used again.
  #
  # Handle this here.
  #
  if has(argParm,_) then
    if assigned(grG_lastObjectSeq) then
      argList := subs(_=grG_lastObjectSeq,argParm):
    else
      ERROR(`No previous object sequence to recall with _`):
    fi:
  else
    argList := argParm:
  fi:

  #
  # if the index names get assigned then BAD things will happen
  #
  if assigned(up) then
    ERROR(`GRTensor reserved function up has been assigned!`):
  fi:
  if assigned(dn) then
    ERROR(`GRTensor reserved function dn has been assigned!`):
  fi:
  #
  # BUILD A LIST TO BE CHECKED
  #
  # now build a list of the actual objects to be checked, stop
  # at the first occurance of an integer or an assigned name
  # (which is a grmap function)
  #
  actual := NULL:
  for a to nops(argList)
   while not type(argList[a], integer) do # integers are simpHow codes

     if member( argList[a], grG_simpHowSet) then
        #
        # if a member of simpHowSet then it's a simplification
        # instruction and the list of objects is over
        #
        break;
     elif type( argList[a], procedure) then
	#
	# check for a grmap procedure call. (this will also be a
	# name so do this first).
	#
	break;

     elif type(argList[a], equation) then
        #
        # AUXILARY METRIC NAMES
        #
        # handle user defintions which use multiple metrics.
        # Metrics can be specified via e.g. 1=rw as a parameter
        #
        if not member( rhs(argList[a]), grG_metricSet) then
          ERROR(rhs(argList[a]),` has not been specified.`):
        else
          grG_metricName||(lhs(argList[a])) := rhs(argList[a]):
        fi:

     elif assigned(grG_subList[argList[a]]) then
        #
	# old style substitution (obsolete unless tetrads has some)
	#
	actual := actual, grG_subList[argList[a]]:

     elif assigned(grG_ObjDef[argList[a]][grC_alias]) then
        #
        # SIMPLE ALIAS (e.g. CM)
	#
	# do name substitutions like Riemann -> R(dn,dn,dn,dn)
        #
        # Alias in indexed root names or args
        # are handled in the indexed clause.
	#
        actual := actual, grG_ObjDef[argList[a]][grC_alias]:

     elif type( argList[a], indexed) then
        #
        # INDEXED
        #
        # - check for compound object inside or outside the
        # index (i.e. Dsq[CM], or CM[schw] )
        #

        operands := [grF_objectOperands(argList[a])]:
        #
        # Case 1: Are the args of the operator compound ?
        #
        #   Look for compound objects, if found then
        #   add to a compound list (assumes only one
        #   compound item
        #
        compound := NULL:
        for i to nops(operands) do
          item := operands[i]:
          if type( item, equation) then
            if lhs(item) = object and
               (assigned(grG_subList[rhs(item)]) or
                assigned(grG_ObjDef[rhs(item)][grC_alias])) then
              compound := rhs(item):
              break:
            fi:
          elif assigned( grG_subList[item]) or
               assigned(grG_ObjDef[item][grC_alias]) then
              compound := item:
              break:
          fi:
        od:
        #
        # Case 2: Is the root of the indexed object compound ?
        #
        item := op(0,argList[a]):
        if assigned( grG_subList[item]) or
           assigned(grG_ObjDef[item][grC_alias]) then
             compound := item:
        fi:
        #
        # expand out the compound objects
        #
        if compound <> NULL then
          #
          # add to argList once for each entry in subList
          # (for now support both grC_alias and old style sublist)
          #
          if assigned(grG_subList[compound]) then
            subList := [grG_subList[compound]]:
          else
            subList := [grG_ObjDef[compound][grC_alias]]:
          fi:
          for i to nops( subList) do
            actual := actual, subs( compound = subList[i], argList[a]);
          od:
        else
          #
          # so the parameter is either a garden variety object with
          # a metric name as a parameter, or it's an operator. In
          # the first case we need to add the new metric name, and follow
          # it with the default metric name
          # (can't check indices field because we may be auto-creating this
          #  object for a non-default metric and it's ObjDef record won't
          #  exist).
          #  
	  # If the metric name IS the default metric, then don't bother
	  #
          if nops(operands) = 1 and member(operands[1], grG_metricSet) 
	     and operands[1] <> grG_default_metricName then
             actual := actual, operands[1], grF_objectName(argList[a]),
                       grG_default_metricName:
          else
             actual := actual, argList[a]:
          fi:
        fi:

     elif type( argList[a], function) then
	#
	# if it's a name or has e.g. up or dn as an argument then assume
	# it is a tensor name
	#
	actual := actual, argList[a]:

     #
     # want to distinguish between strings and names
     # (but Maple thinks `X{a b}` is a name and that
     # W1R is a string. Feed the expression to parse
     # if parse cacks then it might be a string
     #
     elif traperror(parse(argList[a])) = lasterror then
	actual := actual, grF_strToObject(argList[a]):

     elif type( argList[a], name) then
	#
	# if it's a name or has e.g. up or dn as an argument then assume
	# it is a tensor name
	#
	actual := actual, argList[a]:

     else # must be a function name or expression
	actual := actual, argList[a]:

     fi:
  od:
  #
  # record objectSeq for recall next time
  #
  grG_lastObjectSeq := actual:
  grG_metricName := grG_default_metricName:

  #
  # Check the objects.
  #
  # If dependencies are required (and we're calcing) then they're
  # added here.
  #
  # start the seq with the default metric name.
  #
  grG_checkObjects_Cache := {}: # clear the checkObjects cache
  actual2 := grG_default_metricName,
             grF_checkObjects([actual], reqCalced, reqUncalced):
  #
  # NOW CULL DUPLICATES FROM THE LIST
  # (unless they are metric names or objects for different metrics)
  #
  # start the list with the default metric
  # embedded. Object names are added to the
  # sequence, if they're from a different metric the
  # new metric name is added in.
  #
  # build a seq which holds [metric,object] pairs, adding only
  # new ones (order IS important which is why a simple set
  # solution doesn't work)
  #
  metric := grG_default_metricName:
  metricSeq := NULL:
  dummy := 0:
  for a in [actual2] do
    if member(a, grG_metricSet) then
      metric := a:
      metricSeq := metricSeq,[dummy,metric]:
      dummy := dummy + 1: # just a counter to ensure all metric name
                          # entries are unique
    else
      if not member([metric,a], {metricSeq}) then
        metricSeq := metricSeq, [metric,a]:
      fi:
    fi:
  od:
  #
  # now build a new sequence, striping out the metric names
  #
  returnSeq := NULL:
  for a in [metricSeq] do
    returnSeq := returnSeq, op(2,a):
  od:

  RETURN([returnSeq]):

end:

#----------------------------------------------------------
# grF_checkObject
#
# check a list of objects according to the flags reqCalced
# and reqUncalced.
#
# - when used for screening grcalc calls this routine adds the
#   dependencies to the list (and may force the creation of new
#   object definitions)
#
# - expanding every definition all the way back makes for
#   very long lists of objects (e.g. if doing CM) so we
#   keep a cache in grG_checkObject_Cache and return NULL
#   on a cache hit - since that object has appeared earlier
#   in the list and does not need to be repeated.
#
#  Note that we need to clear the cache when the metric name
#  switches.
#   
#----------------------------------------------------------

grF_checkObjects := proc( objList, reqCalced, reqUncalced)
local a, b, i, x, actual, actual2, start, calced,
      subMe, indexStuff,
      compound, operands, item, dependSet, objectName, returnSeq,
      oldMetric, object, newMetric, s:

global grG_metricName, grG_operands, grG_checkObjects_Cache, grG_multipleDef:

  #
  # CHECK THE OBJECTS IN THE LIST
  #
  # now check that each of these objects is defined, if checking for
  # display, then remove from actual any which havn't been calc'd.
  #
  # May encounter metric names. If so just change to the new
  # metric and add it to the list.
  #
  actual2 := NULL:
  for x in objList do
    if member( x, grG_metricSet) then
      actual2 := actual2, x:
      grG_metricName := x:
      grG_checkObjects_Cache := {}:
    else
      a := x:
      oldMetric := grG_metricName:
      #
      # allow dependencies to indicate a metric explicitly
      # by including [metric, object] pairs. If such an entry
      # is encountered then
      #
      if type(x, list) then
        a := x[2]:
        grG_metricName := x[1]:
      fi:
      #
      # force creation of new object if required (grG_operands may get
      # cleared here)
      #
      grF_checkIfDefined (a, create):
      #
      # set the operand globals (which are necessary since
      # checkIfAssigned may need to make reference to them)
      #
      object := grF_expandOperands(a): # this may set grG_metricName
      if oldMetric <> grG_metricName then
        #
        # the indexed object changed to a new metric. Insert this
        # in the list ahead of all of this objects dependencies
        # plus note that we need to change back after this object
        # by adding oldMetric to the object sequence following this
        # object
        #
        newMetric := grG_metricName:
        grG_checkObjects_Cache := {}:
      else
        oldMetric := NULL: # this is added after this object in the seq
        newMetric := NULL:
      fi:
      #
      # check if assigned and set the globals
      #
      calced := grF_checkIfAssigned ( object ):

      if reqCalced and not calced then
         for b in grG_multipleDef[objectname] while not calced do
           calced := calced or grF_checkIfAssigned ( object ):
         od:
         if not calced then
           printf(`%a has not been calculated.\n`,a):
         else
           actual2 := actual2, newMetric, object, oldMetric:
         fi:
      elif reqUncalced and calced then
         NULL:
         # do nothing

      elif reqUncalced and not calced then
        #
        # DEPENDENCIES (grcalc or grcalcalter call)
        #
        # add dependencies to the list ahead of the object to be
        # calculated.
        #
        objectName := grF_objectName(a): # get a base name for operators
	
        #
        # MULTIPLE DEFINITIONS
        #
        # are multiple objects with this name defined ?
        # If so which calc function should be used ? Determine
        # this by steping through the multipleDef list and
        # stopping at the first true result.
        #
        # Multiple defintions for operators will not work!
        #
        if assigned(grG_multipleDef[objectName]) then
          s := sprintf("Multiple definitions for %a: ", objectName);
          for b in grG_multipleDef[objectName] do
            if assigned(grG_ObjDef[b][grC_useWhen]) and
               grG_ObjDef[b][grC_useWhen]( [actual2,op(grG_checkObjects_Cache)]) then
               s := cat(s, sprintf("Using definition %s for %a\n", b, objectName));
               printf("%s", s);
              break;
            fi:
          od:
          # will end up using last entry in list if none of the calcWhen functions match
          objectName := b:
          object := b:
        fi:
        #
        # EXPAND DEPENDENCIES
        # expand the dependencies only if this object is not
        # in the cache
        #
        if not member( objectName, grG_checkObjects_Cache) then

          if type( grG_ObjDef[objectName][grC_depends], procedure) then
             dependSet := grG_ObjDef[objectName][grC_depends]():

          elif type( grG_ObjDef[objectName][grC_depends], set) then
             dependSet := grG_ObjDef[objectName][grC_depends]:

          else
             ERROR(`Bogus definition for `||objectName||` depends must be set or proc.`):
          fi:

          actual2 := actual2, newMetric,
                   grF_checkObjects( [op(dependSet)], reqCalced, reqUncalced),
                   object, oldMetric:
          #
          # update the cache - but do not add operators since they
          # will depend on operands
          #
          if not assigned( grG_ObjDef[ objectName][grC_operandSeq]) then
             grG_checkObjects_Cache := grG_checkObjects_Cache union {objectName}:
          fi:
 
       fi:

    else
        actual2 := actual2, newMetric, object, oldMetric:
    fi:
    if oldMetric <> NULL then
        grG_metricName := oldMetric:      
        grG_checkObjects_Cache := {}:

    fi:
   fi:
  od:

  RETURN( actual2):

end:

#----------------------------------------------------------
# grF_checkIfAssigned
#
# - check if the object passed in has been assigned
#
#
# Determine if the object is assigned by testing
# that the entry with all 1's as indices has been assigned.
# The operands must appear in the indexed name in the same
# order as in the grC_operandSeq list.
#
# Object assignment is done by setting the object entry
# with all zeros to true. This entry is 
#----------------------------------------------------------


grF_assignedFlag := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
#
# mode is either set or test
#
global grG_calcFlag, grG_metricName:
local a, objOperands, objectName, iName, operandSeq, mode, fullName:

 objOperands := NULL:
 objectName := args[1]:
 mode := args[2]:

 if nargs=3 then
   iName := args[3]:
 else
   iName := grG_metricName:
 fi:

 if grF_isIndexed(objectName) then
   #
   # Pull apart the name
   #
   fullName := objectName:
   objectName := grF_objectName( objectName ):
   objOperands := grF_objectOperands( fullName ):
 fi:

# if assigned( grG_ObjDef[objectName][grC_operandSeq] ) then
    #
    # have to get the full name of the object
    #
#    iName := iName, grF_objectOperands( grF_expandOperands(objectName) ):
# else
#    iName := iName:
# fi:

 if mode = set then
   # 
   # only want to set this if it's not already assigned.
   # (for scalars and operators on scalars there will be
   #  no listing indices and no need to set a zero-th entry)
   #
   if objOperands <> NULL then
     grG_calcFlag[iName][objectName[objOperands]] := true:
   else
     grG_calcFlag[iName][objectName] := true:
   fi:
 elif mode = test then
   #
   # don't just return the flag, because it might not be assigned
   #
   if objOperands <> NULL then
     if assigned ( grG_calcFlag[iName][objectName[objOperands]] ) then
       grG_calcFlag[iName][objectName[objOperands]]:
     else
       false;
     fi:
   else
     if assigned ( grG_calcFlag[iName][objectName] ) then
       grG_calcFlag[iName][objectName]:
     else
       false;
     fi:
   fi:
 else
   ERROR(`Internal error-bad mode`):
 fi:

end:

#
# just a wrapper - do this for historical (hysterical?) reasons
#
grF_checkIfAssigned := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  if nargs=2  then
    grF_assignedFlag(args[1], test, args[2]):
  else
    grF_assignedFlag(args[1], test):
  fi:
end:


#----------------------------------------------------------
# grF_checkIfDefined
# check an object record has been defined
#----------------------------------------------------------

grF_checkIfDefined := proc(objectParm, act)
local  a, objRoot, i, baseObj, object, c, p, cb, pb;
global grG_metricName;
 #
 # see if the object is defined. If not see if something
 # with the same number of indices is defined, if so
 # construct object by altering indices.
 #
 # Failing that, look in the list of autoload objects and
 # see if we need to load a library. The autoload lists are
 # in rootSet format, so that we can determine if a requested
 # object is an index shift of an object in a supplementary
 # library.
 #

 # 
 # metric names may be passed, but they are to be ignored
 #
 if member( objectParm, grG_metricSet) then 
	grG_metricName := objectParm;
	RETURN( NULL); 
 fi:

 object := grF_objectName(objectParm):

 if not ( assigned(grG_ObjDef[object][grC_root] )
          or assigned(grG_ObjDef[object][grC_alias]) ) then

   if type(object, function) then
      #
      # if it's not a function then no index shifting can
      # make it appear BUT if it's a function of just cdn or cup
      # then the root can be a scalar
      #
      if has(object, {cup,cdn,pup,pdn,cbup,cbdn,pbup,pbdn}) then
	 #
	 # need to count the number of coD indices present
	 #
	 if nops(object) = 1 then
	   #
	   # root object must be a scalar
	   #
	   baseObj := cat(grG_,op(0,object)):

	 else
	   c := 0: 
	   p := 0:
           cb := 0:
           pb := 0:
           for i to nops(object) do
             if member ( op(i,object), {cup,cdn} ) then
               c := c + 1:
             elif member ( op(i,object), {pup,pdn} ) then
               p := p + 1:
             elif member ( op(i,object), {cbup,cbdn} ) then
               cb := cb + 1:
             elif member ( op(i,object), {pbup, pbdn} ) then
               pb := pb + 1:
             fi:
           od:
           i := nops(object) - c - p - cb - pb:
	   objRoot := cat(grG_,op(0,object),_,i,_,c,_,p,_,cb,_,pb):
           if i > 0 then
	     baseObj := cat(grG_,op(0,object),_,i):
           else
	     baseObj := cat(grG_,op(0,object)):
           fi:
	 fi:
      else
	 objRoot := cat(grG_,op(0,object),_,nops(object)):
      fi:

   elif type(object, indexed) then
      #
      # found a requirement for a metric name
      #
      if not assigned( grG_metricName||(op(object)) ) then
	#
	# prompt for the metric name
	#
	printf(`Calculation requires specification of metric[%d]\n`,
		op(object) ):
	grG_metricName||(op(object)) :=
		grF_readstat (`Enter name (followed by ;) >`, [], `grcalc`):
      fi:
      RETURN(NULL);

   else
     objRoot := grG_||object:
   fi:

   # Create a new definition based on shifted indices or derivative:

   if member(objRoot, grG_rootSet) then
     if act=create then
       grF_newIndices (object):
     fi:
   elif member(baseObj, grG_rootSet) then
     if act=create then
       grF_makeD (object);
     fi:
   else
     ERROR (`No definition found for object` = object ):
   fi:
 fi:
end:

#----------------------------------------------------------
# grF_assignedObjects(metric)
#
# Return a sequence of all objects assigned for the metric
# (used by grclear)
#----------------------------------------------------------

oldgrF_assignedObjects := proc(metric)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local allObjects, returnSeq, a, holdMetric;

global grG_metricName:

 returnSeq := NULL:
 allObjects := indices(grG_ObjDef):

 holdMetric := grG_metricName:
 grG_metricName := metric:
 for a in allObjects do
   if grF_checkIfAssigned(op(a)) then
     returnSeq := returnSeq, op(a):
   fi:
 od:
 grG_metricName := holdMetric:
 returnSeq:

end:

grF_assignedObjects := proc(metric)
local allObjects, returnSeq, a, holdMetric;
global grG_metricName:

 returnSeq := NULL:
 for a in indices(grG_calcFlag[metric]) do
   if grG_calcFlag[metric][op(a)] then
     returnSeq := returnSeq, op(a):
   fi:
 od:
 RETURN(returnSeq):
end:

#----------------------------------------------------------
# grF_clear
#
# Given an object name, find all instances of the object
# for the metric indicated by grG_metricName, If we
# get a metric name, then just change grG_metricName.
#----------------------------------------------------------

grF_clear := proc(object)
local a,b, clearMe, operands, entries, root, opList, objectName, rootStr;
global grG_metricName, grG_calcFlag, gr_data, grG_ObjDef, Ndim:

  if member( object, grG_metricSet) then
    grG_metricName := object:
  else
    #
    # Everything is now in gr_data, so need to find those entries which match
    # on object name and current metric name
    #
    grG_calcFlag[grG_metricName][object] := false:

    objectName := grF_objectName(object): # get name (might be operator)
    entries := indices(gr_data):
    rootStr := grG_ObjDef[object][grC_root];
    # entries is a list with objectName, metric as the first two 
    for a in entries do
      if a[1] = rootStr and a[2] = grG_metricName then
         #
         # found an entry for this metric, but if it's an operator
         # we require more than just the metric name to match
         #
         clearMe := true:
         if nops(a) > 2 then
            operands := [grF_objectOperands( grF_expandOperands(object))]:
            for b to nops(operands) do
              if operands[b] <> a[b+1] then
                 clearMe := false:
              fi:
            od:
         fi:
         if clearMe then
             gr_data[op(a)] := evaln(gr_data[op(a)]);
         fi:
      fi:
    od:

  fi:

end:

