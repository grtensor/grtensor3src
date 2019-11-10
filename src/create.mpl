#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: CREATE.MPL
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgave
#            Date: April 30, 1994
#
# Purpose: Routines which auto-create object definitions
#          from known objects. e.g. a change in index
#          positions from up to dn etc. or the definition
#          of a covariant derivative of a known object.
#
# Revisions:
# April 30, 1994        Renamed newindex.mpl to this file
#                       and added automatic CoD routines.
# June  11, 1994        Added operator support.
# July   5, 1994        Fixed RiemSq(cdn,cup) bug in grF_makeCoD.
# July   7, 1994        Changed grF_newIndices to allow 
#                       raising and lowering of basis indices.[dp]
# Sept. 8,  1994        copy across operandSeq for operators [pm]
# Sept. 26, 1994  	Make tensor -> tetrad creation harder [pm]
# Dec.   6, 1994        Add pup/pdn [pm]
# Aug.   5, 1995	Add unassignLoopVars to makeD [dp]
# Mar.  26, 1996        First arg to procmake must be a name in R4 [pm]
# June   6, 1996	Add support for cbup, cbdn [dp]
# June  12, 1996	Fix conversion for pup/pdn indices [dp]
# June  19, 1996	Add passing of operands to dependSet [dp]
# Sept   5, 1996        Fix newIndices for operators. [pm]
# Dec    5, 1997	Added grOptionMessageLevel [dp]
# Feb   14, 1997        Switch convert(x,string) to convert(x,name) for R5 [dp]
# Feb   24, 1997	Cleaned up unassign and reassign of metric names [dp]
# Sep   10, 1999        Fixed symmetry determination for new-style symLists[dp]
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#**********************************************************
#
#  Note that grF_newIndices is used from grcalc
#  and grcalcalter if a new index combination of an existing
#  object is requested.
#
#  This file contains:
#       grF_newIndices()
#       grF_newSymmetry()
#       grF_makeD
#       grF_buildCoDfunction
#
#**********************************************************

#----------------------------------------------------------
# grF_newIndices
#
# Defines a new grG_ObjDef record for an object which can
# constructed by raising/lowering/converting indices from
# an existing object record.
#
# Should determine symmetry !! (think about this)
#----------------------------------------------------------

grF_newIndices := proc(object)
#option trace;
global  grG_ObjDef, grG_metricName, grF_contractFn, gr_data;
local a,b,c,i, cousins,root, newList, baseObj, objIndices, dependSet,
      dist, nearest, nearList,expr, exprProd, objSeq, numUp, numDn,
      numSym, mostSym, numcUp, numcDn, numbUp, numbDn, numcbUp, numcbDn,
      numpbUp, numpbDn, okay, newIndex, nearIndex, mname, 
      depArgs, dependObj:

  if nops(object) = 0 then
    ERROR(`no indices!`):
  fi:

  # unassign a1_ etc. so that assignments later are ok
  grF_unassignLoopVars():

  if assigned ( grG_metricName ) then
    grF_unassignMetricNames():
  fi:

  root := op(0,object);
  #
  # first task is to find those existing objects with the same number
  # of indices and the same root (cousins). Cousins must also
  # have the same type of index in matching positions.
  #
  #    i.e  g(dn,dn,dn) cannot be a cousin of g(dn,dn,cup)
  #
  objSeq := indices(grG_ObjDef);
  cousins := []:
  for a in objSeq do
    b := op ( a ): # elements of a are lists, shed their listness
    if not type ( b, name ) then
      if ( root = op(0,b) ) and ( nops(b) = nops(object) ) and
        grG_ObjDef[b] <> grG_deleted then
        #
	# have a coarse match (same number of indices)
        # are they the same type ?
        #
        okay := true:
        for c to nops(b) do
          okay := okay and
            ( ( has ( op(c,object), {up,dn,bup,bdn}     ) and
                has ( op(c,b),      {up,dn,bup,bdn}     ) ) or
              ( has ( op(c,object), {pup,pdn,bup,bdn}   ) and
                has ( op(c,b),      {pup,pdn,bup,bdn}   ) ) or
              ( has ( op(c,object), {cup,cdn,bup,bdn}   ) and 
                has ( op(c,b),      {cup,cdn,bup,bdn}   ) ) or
              ( has ( op(c,object), {cbup,cbdn,up,dn}   ) and
                has ( op(c,b),      {cbup,cbdn,up,dn}   ) ) or
              ( has ( op(c,object), {pbup,pbdn,up,dn}   ) and
                has ( op(c,b),      {pbup,pbdn,up,dn}   ) ) ): 
        od:
        if okay then
          cousins := [op(cousins), grG_ObjDef[b][grC_indexList] ]:
        fi:
      fi:
    fi:
  od:
  #
  # now determine a "distance" from the present object to each cousin.
  # For each entry in indexList different from that in the new object
  # this is a distance of 1 unit.
  # Keep the list with the "least distance"
  #
  # at the same time search for the cousin with the most indices
  # up or dn, this will have the maximum symmetry
  #
  newList := [op(object)]: # make a list of new objects indices
  nearest := 100: # set a big intial distance
  numSym := 0:

  for a in cousins do
    dist := 0:
    numUp := 0:
    numDn := 0:
    numcUp := 0:
    numcDn := 0:
    numcbUp := 0:
    numcbDn := 0:
    numpbUp := 0:
    numpbDn := 0:
    mostSym := -1;
    for b to nops(newList) do
      if a[b] =   up then   numUp :=   numUp + 1 fi:
      if a[b] =   dn then   numDn :=   numDn + 1 fi:
      if a[b] =  cup then  numcUp :=  numcUp + 1 fi:
      if a[b] =  cdn then  numcDn :=  numcDn + 1 fi:
      if a[b] =  bup then  numbUp :=  numbUp + 1 fi:
      if a[b] =  bdn then  numbDn :=  numbDn + 1 fi:
      if a[b] = cbup then numcbUp := numcbUp + 1 fi:
      if a[b] = cbdn then numcbDn := numcbDn + 1 fi:
      if a[b] = pbup then numpbUp := numpbUp + 1 fi:
      if a[b] = pbdn then numpbDn := numpbDn + 1 fi:
      if a[b] <> newList[b] then
        #
        # make a tensor to tetrad conversion more expensive than
        # just staying within the same formalism
        #
        if   (     member (       a[b], {bup,bdn,cbup,cbdn,pbup,pbdn} ) and 
               not member ( newList[b], {bup,bdn,cbup,cbdn,pbup,pbdn} )     )
          or ( not member (       a[b], {bup,bdn,cbup,cbdn,pbup,pbdn} ) and 
                   member ( newList[b], {bup,bdn,cbup,cbdn,pbup,pbdn} )     )
           then
	      dist := dist + 2:
        else
              dist := dist + 1:
        fi:
      fi:
    od:
    # is this one the nearest ?
    if dist < nearest then
       nearest := dist:
       nearList := a:
    fi:
    # is this the most symmetric ?
    if numUp > mostSym then
       numSym := numUp:
       mostSym := a:
    elif numDn > mostSym then
       numSym := numDn:
       mostSym := a:
    fi:
  od:
  if dist = 0 then
     printf("Asked to create object %a\n", object);
     ERROR(`asked to define an existing object`);
  fi:
  #
  # now build an expression for how this new object can be calculated.
  #
  # first build a product formula (before expr is assigned so don't
  # repeatedly evaluate each expr[a])
  #
  exprProd := 1;
  for a to nops(newList) do
    exprProd := exprProd * expr[a]:
  od:
  #
  # now assign the expr[a]'s
  #
  objIndices := []:
  dependSet := {}:
  b := 1; # b keeps track of the number of the dummy index
  for a to nops(newList) do
    #
    # for purposes of raising/lowering cup -> up etc.
    #
    newIndex := newList[a]:
    if member ( newIndex, {pup,cup} ) then
       newIndex := up:
    elif member ( newIndex, {pdn,cdn} ) then
       newIndex := dn:
    elif member ( newIndex, {cbup,pbup} ) then
       newIndex := bup:
    elif member ( newIndex, {cbdn,pbdn} ) then
       newIndex := bdn:
    fi:    
    nearIndex := nearList[a]:
    if member ( nearIndex, {pup,cup} ) then
      nearIndex := up:
    elif member ( nearIndex, {pdn,cdn} ) then
      nearIndex := dn:
    elif member ( nearIndex, {cbup,pbup} ) then
       nearIndex := bup:
    elif member ( nearIndex, {cbdn,pbdn} ) then
       nearIndex := bdn:
    fi:
  
    if newIndex <> nearIndex then
      #
      # find out what kind of term is needed
      # Note: can't assume up,dn pairs since could be up tdn() etc.
      # use '' to prevent evaluation of the metric name. Want this
      # assigned during the calculation, not now!!
      #
      if (newIndex = up) and (nearIndex = dn) then
      	expr[a] := gr_data[gupup_,'grG_metricName',a||a||_,s||b||_]:
      	dependSet := dependSet union {g(up,up)}:

      elif (newIndex = dn) and (nearIndex = up) then
      	expr[a] := gr_data[gdndn_,'grG_metricName',a||a||_,s||b||_]:
      	dependSet := dependSet union {g(dn,dn)}:

      elif (newIndex = bup) and (nearIndex = bdn) then
        expr[a] := gr_data[etabupbup_,'grG_metricName',a||a||_,s||b||_]:
        dependSet := dependSet union {eta(bup,bup)}:

      elif (newIndex = bdn) and (nearIndex = bup) then
        expr[a] := gr_data[etabdnbdn_,'grG_metricName',a||a||_,s||b||_]:
        dependSet := dependSet union {eta(bdn,bdn)}:

      elif (newIndex = bup) and (nearIndex = up) then
        expr[a] := gr_data[ebupdn_,'grG_metricName',a||a||_,s||b||_]:
        dependSet := dependSet union {e(bup,dn)}:

      elif (newIndex = bup) and (nearIndex = dn) then
        expr[a] := gr_data[ebupup_,'grG_metricName',a||a||_,s||b||_]:
        dependSet := dependSet union {e(bup,up)}:

      elif (newIndex = bdn) and (nearIndex = up) then
        expr[a] := gr_data[ebdndn_,'grG_metricName',a||a||_,s||b||_]:
        dependSet := dependSet union {e(bdn,dn)}:
  
      elif (newIndex = bdn) and (nearIndex = dn) then
        expr[a] := gr_data[ebdnup_,'grG_metricName',a||a||_,s||b||_]:
        dependSet := dependSet union {e(bdn,up)}:

      elif (newIndex = up) and (nearIndex = bup) then
        expr[a] := gr_data[ebdnup_,'grG_metricName',s||b||_,a||a||_]:
        dependSet := dependSet union {e(bdn,up)}:

      elif (newIndex = up) and (nearIndex = bdn) then
        expr[a] := gr_data[ebupup_,'grG_metricName',s||b||_,a||a||_]:
        dependSet := dependSet union {e(bup,up)}:

      elif (newIndex = dn) and (nearIndex = bup) then
        expr[a] := gr_data[ebdndn_,'grG_metricName',s||b||_,a||a||_]:
        dependSet := dependSet union {e(bdn,dn)}:
 
      elif (newIndex = dn) and (nearIndex = bdn) then
        expr[a] := gr_data[ebupdn_,'grG_metricName',s||b||_,a||a||_]:
        dependSet := dependSet union {e(bup,dn)}:

      else
        if not assigned ( grG_metricName ) then
          grF_reassignMetrics():
        fi:
        ERROR(`cannot convert index difference:`,newList[a],nearList[a], object ):
      fi:

      # add a summation index to the index list for objects
      objIndices := [op(objIndices),s||b||_]:
      b := b + 1: # advance the dummy index
    else
      expr[a] := 1:
      objIndices := [op(objIndices),a||a||_]:
    fi:
  od:
  # now need the name of the root object

  baseObj := op(0,object)(op(nearList)):
  #
  # if it's an operator then copy across the operandSeq
  #
  if assigned(grG_ObjDef[baseObj][grC_operandSeq]) then
     grG_ObjDef[object][grC_operandSeq] := grG_ObjDef[baseObj][grC_operandSeq]:
     depArgs := NULL:
     for i in [ grG_ObjDef[baseObj][grC_operandSeq] ] do
	depArgs := depArgs, grG_||i:
     od:
     dependObj := 
       op(0,object)[depArgs](op(nearList));
  else
     dependObj := baseObj:
  fi:

  root := grG_ObjDef[baseObj][grC_root]:
  grG_ObjDef[object][grC_calcFnParms] := exprProd *
            gr_data[root,'grG_metricName','grG_operands',op(objIndices)];
  #
  # that's most of the hard work done, now update other fields of the
  # object def record
  #
  # build the root name (from the object concatenated with the
  # parameters)
  #
  grG_ObjDef[object][grC_header] := convert(object,name):
  grG_ObjDef[object][grC_root] := cat(op(0,object), op( object), _);
  grG_ObjDef[object][grC_rootStr] := grG_ObjDef[baseObj][grC_rootStr]:
  grG_ObjDef[object][grC_indexList] := newList:
  grG_ObjDef[object][grC_depends] := { dependObj } union dependSet:

  #
  # If an index contraction function does not exist, one is automagically
  # created by grF_build_contractFn ()
  #
  if not type (grF_contractFn[b-1], procedure) then
     grF_contractFn[b-1] := grF_build_contractFn (b-1):
  fi:
  grG_ObjDef[object][grC_calcFn] := grF_contractFn[b-1]:

  grG_ObjDef[object][grC_symmetry] :=
	 grF_newSymmetry(object,op(0,object)(op(mostSym)), newList):
  #
  # if it's an operator then copy across the operandSeq
  #
  if assigned(grG_ObjDef[baseObj][grC_operandSeq]) then
     grG_ObjDef[object][grC_operandSeq] := grG_ObjDef[baseObj][grC_operandSeq]:
  fi:

  if grOptionMessageLevel > 0 then
    printf(`Created definition for %a \n`,object);
  fi:
  if not assigned ( grG_metricName ) then
    grF_reassignMetrics():
  fi:

  NULL;

end:

#----------------------------------------------------------
# grF_newSymmetry(newObject,oldObject)
#
# Determine the symmetry of a new object which is based on shifting
# indices of oldObject.
#
# Get the perm list for the
#----------------------------------------------------------

grF_newSymmetry := proc(newObject,oldObject, newIndex)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, oldPerms, newPerm, permList, okay, symSet, asymSet, itype,
  oldIndex:
global grG_ObjDef:

  # if number of indices < 2 then just copy sym from oldObject
  if nops(newIndex) < 2 then
    RETURN(grG_ObjDef[oldObject][grC_symmetry]);
  fi:

  if not assigned (grG_ObjDef[oldObject][grC_symList]) then
    # original styled symmetry determination for objects in
    # tensors.mpl uses the grG_symmetry lists which are inconsistent
    # with grdef()'s symList structure. This should be replaced. [dp]

    # get the set of perms for the oldObject
    oldPerms := grG_symmetry[ grG_ObjDef[oldObject][grC_symmetry] ]:

    # which index positions are different types in new object ?
    newPerm := {}:
    for a in oldPerms do
      permList := a[1]; # get a list
      okay := true:
      for b to nops(permList) do
        #
        # if the index permuted to this position is a different type
        # from the index in this position then must reject this perm
        #
        if newIndex[b] <> newIndex[ permList[b]] then
	  okay := false
        fi:
      od:
      if okay then
        newPerm := newPerm union {a}:
      fi:
    od:
  else
    oldIndex := grG_ObjDef[oldObject][grC_indexList]:
    
    symSet := {}:
    for a in grG_ObjDef[oldObject][grC_symList][1] do
      itype := op(op(1,a),newIndex):
      okay := true:
      for b from 2 to nops(a) while okay do
        if op(op(b,a),newIndex) <> itype then
	  okay := false
	fi:
      od:
      if okay then
        symSet := symSet union {a}:
      fi:
    od:
    
    asymSet := {}:
    for a in grG_ObjDef[oldObject][grC_symList][2] do
      itype := op(op(1,a),newIndex):
      okay := true:
      for b from 2 to nops(a) while okay do
        if op(op(b,a),newIndex) <> itype then
	  okay := false
	fi:
      od:
      if okay then
        asymSet := asymSet union {a}:
      fi:
    od:

    grG_ObjDef[newObject][grC_symList] := [symSet, asymSet]:
  fi:
  
  # now find a symmetry function (RETURN this value)
  grF_findSymmetry(newObject, newPerm, nops(newIndex));
end:

#----------------------------------------------------------
# grF_makeD
#
# Given a calc request for e.g. R(dn,dn,cdn) or R(dn,dn,pdn)
# create a defintion of this object in terms of
# R(dn,dn).
#
# If asked for R(dn,dn,cdn,cdn) then check if R(dn,dn,cdn)
# is already defined. If not, do them both.
#
#----------------------------------------------------------

grF_makeD := proc(object)
local rootObj, newPerm, oldPerm, n, a, newObject, dependsOn, raise,
	newIndex, i:

global grG_ObjDef, grG_operands, gr_data:

 # we want to create a generic operator derivative so we
 # require grG_operands undefined

 grF_unassignLoopVars():
 grG_operands := 'grG_operands':
 #
 # merely a matter of taking the derivative of same of object
 # with one fewer index (this may result in a recursive call
 # to this routine)
 #
 n := nops(object):
 newObject := grF_objectName(object):
 newIndex := op(n,newObject):
 #
 # if asked to take cup do this by taking cdn and then raising
 #
 raise := false:
 if newIndex = cup then
   newObject := op(0,newObject)
                (seq(op(i,newObject),i=1..nops(newObject)-1),cdn):
   newIndex := cdn:
   raise := true:
 elif newIndex = pup then
   newObject := op(0,newObject)
                (seq(op(i,newObject),i=1..nops(newObject)-1),pdn):
   newIndex := pdn:
   raise := true:
 elif newIndex = cbup then
   newObject := op(0,newObject)
                (seq(op(i,newObject),i=1..nops(newObject)-1),cbdn):
   newIndex := cbdn:
   raise := true:
 elif newIndex = pbup then
   newObject := op(0,newObject)
                (seq(op(i,newObject),i=1..nops(newObject)-1),pbdn):
   newIndex := pbdn:
   raise := true:
 fi:
 #
 # rootObj refers to the newObject minus the last cup/cdn
 #
 if nops(newObject) > 1 then
    rootObj := op(0,newObject)( seq(op(a,newObject),a=1..nops(newObject)-1)):
 else
    rootObj := op(0,newObject):
 fi:

 grF_checkIfDefined (rootObj, create): # this may result in recursion

 #
 # generate the object defintion
 #
 grG_ObjDef[newObject][grC_header] := convert(newObject,name):
 grG_ObjDef[newObject][grC_root] := cat(op(0,newObject), op( newObject), _);
 grG_ObjDef[newObject][grC_rootStr] := grG_ObjDef[rootObj][grC_rootStr]:
 grG_ObjDef[newObject][grC_indexList] := [op(newObject)]:
 #
 dependsOn := rootObj:
 if assigned (grG_ObjDef[rootObj][grC_operandSeq] ) then
   #
   # if the root object is an operator, then we must copy across the
   # operand sequence, plus set the dependency 
   #
    grG_ObjDef[object][grC_operandSeq] :=
          grG_ObjDef[rootObj][grC_operandSeq]:
    if type(rootObj, function) then
      dependsOn :=
         op(0,rootObj)[ grG_operands](op(rootObj)):
    else
      dependsOn :=
         rootObj[ grG_operands]:
    fi:
 fi:
 #
 # define the calc function
 #
 dependsOn := rootObj:
 if newIndex = cdn or newIndex = cbdn or newIndex = pbdn then
   grG_ObjDef[newObject][grC_calcFn] := 
     grF_buildCoDfunction( newObject, rootObj ):
   if newIndex = cbdn then
     grG_ObjDef[newObject][grC_depends] := {dependsOn, rot(bup,bdn,bdn)}:
   elif newIndex = pbdn then
     grG_ObjDef[newObject][grC_depends] := {dependsOn}:
   else     
     grG_ObjDef[newObject][grC_depends] := {dependsOn, Chr(dn,dn,up)}:
   fi:
 elif newIndex = pdn then
     grG_ObjDef[newObject][grC_calcFn] := grF_calc_scalar:
     grG_ObjDef[newObject][grC_calcFnParms] :=
        parse(convert(cat(`'`,`diff(gr_data`,
	      `[`,grG_ObjDef[rootObj][grC_root],`,grG_metricName`,seq(`,a`||i||_,i=1..n-1),
	      `],gr_data[xup_,grG_metricName,`,
	      a||n||_,`])'` ),name)):
     grG_ObjDef[newObject][grC_depends] := { dependsOn }:
 fi:
 #
 # FIND A SYMMETRY FOR THE NEW OBJECT
 #
 # now build a new perm list based on the root object
 #
 # perm list looks like {[[2,1],1], etc. }
 #
 oldPerm := grG_symmetry[ grG_ObjDef[rootObj][grC_symmetry] ]:
 newPerm := {}:
 if oldPerm <> {[]} then
   for a in oldPerm do
     newPerm := newPerm union {[ [op(a[1]),n], a[2]]}:
   od:
 else
   newPerm := {[[1],1]}:
 fi:

 grG_ObjDef[newObject][grC_symmetry] :=
   grF_findSymmetry (newObject, newPerm, n):

 grF_gen_rootSet():
 if grOptionMessageLevel > 0 then
   printf ("Created a definition for %a\n", newObject):
 fi:

 if raise then
   grF_newIndices(object):
 fi:

end:

#----------------------------------------------------------
# grF_buildCoDfunction
#
# More efficient calculation results from creating a
# custom routine than relying on a generic CoD calc
# routine because the generic routine would have to
# figure out what to do for each component call.
#----------------------------------------------------------

grF_buildCoDfunction := proc( object, rootObj)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

local i, objIndices, body, template,
      index, listIndex, firstStmt, loopStmt,
      summand, root, n, baseSeq, indexSeq:

global grG_operands, gr_data, grG_inertForHas7:

  #
  # to create the defintion it's best if the metric names are
  # unassigned, but since this can be called from the core
  # we need to preserve them and re-assign them later
  #
  grF_unassignLoopVars():
  grF_unassignMetricNames():
  grG_operands := 'grG_operands':

  #
  # if has cup, we cannot proceed since we would need
  # diff( ?, xdn_)
  #
  if op( nops(object), object) = cup then
    ERROR(`Internal - grF_buildCoDfunction cannot take CoD{^a} of object`):
  fi:
  #
  # for this routine cup is treated as up etc.
  #
  root := grG_ObjDef[rootObj][grC_root]:
  indexSeq := subs ( cdn=dn, cup=up, pup=up, pdn=dn, [op(rootObj)] ):

  #
  # the procedure we build will be of the form: (e.g)
  #
  # s := 0:
  # for s1 to Ndim[gname] do
  #   s := s + grG_Xdnup_[gname,s1,a2_ ] * grG_Chrdndnup_[gname,a1_,a3_,s1 ]
  #          - grG_Xdnup_[gname,a1_,s1 ] * grG_Chrdndnup_[gname,s1, a3_,a2_]:
  #
  # od:
  # s := s + diff( grG_Xdndn_[a1_,a2_], gr_data[xup_,gname,a3_]
  #
  n := nops ( object ):
  baseSeq := seq ( a||i||_, i=1..n-1 ):
  if op ( n, object ) <> pbdn then
    if op ( n, object ) = cbdn then
      template[up] := gr_data[root,grG_metricName,grG_operands,baseSeq] *
                    gr_data[rotbupbdnbdn_,grG_metricName,listIndex,s1,a||n||_]:
      template[dn] := -gr_data[root,grG_metricName,grG_operands,baseSeq] *
                    gr_data[rotbupbdnbdn_,grG_metricName,s1,listIndex,a||n||_]:
    else
      template[up] := gr_data[root,grG_metricName,grG_operands,baseSeq] *
                    gr_data[Chrdndnup_, grG_metricName,s1, a||n||_, listIndex ]:

      template[dn] := -gr_data[root,grG_metricName,grG_operands,baseSeq] *
                      gr_data[Chrdndnup_, grG_metricName, listIndex, a||n||_, s1]:
    fi:

    summand := 0:
    for i to nops(indexSeq) while type(rootObj, function) do
      index := indexSeq[i]:
      if index = bup then
        index := up:
      elif index = bdn then
        index := dn:
      fi:
      if member(index, {up,dn}) then
         summand := summand + subs(a||i||_=s1,listIndex = a||i||_,template[index]):
      fi:
    od:

    if grG_inertForHas7 then
      loopStmt := `&for`( s1, 1, 1, Ndim[grG_metricName], true,
              `&statseq`( `&:=`(s, s + summand) ), false):
    else
      loopStmt := `&for`( s1, 1, 1, Ndim[grG_metricName], true,
              `&statseq`( `&:=`(s, s + summand) )):
    fi:
  else
    loopStmt := `&expseq`():
  fi:

  if op ( n, object ) = cbdn or op ( n, object ) = pbdn then
    if grG_inertForHas7 then
      body := `&proc`( [dummy, iList], [s1,s], [], `&statseq` (
        `&:=`(s,0), 
        `&for`( s1, 1, 1, Ndim[grG_metricName], true,
          `&statseq`(
          `&:=`(s, s + 'diff'( gr_data[root,grG_metricName,grG_operands,baseSeq],
             gr_data[xup_,grG_metricName, s1] )*gr_data[ebdnup_,grG_metricName,a||n||_,s1] 
           )), false
         ),
         loopStmt ) ):
    else
      body := `&proc`( [dummy, iList], [s1,s], [], `&statseq` (
        `&:=`(s,0), 
        `&for`( s1, 1, 1, Ndim[grG_metricName], true,
          `&statseq`(
          `&:=`(s, s + 'diff'( gr_data[root,grG_metricName,grG_operands,baseSeq],
             gr_data[xup_,grG_metricName, s1] )*gr_data[ebdnup_,grG_metricName,a||n||_,s1] 
           ))
         ),
         loopStmt ) ):
    fi:
  else
    body := `&proc`( [dummy, iList], [s1,s], [], `&statseq`(
            `&:=`(s, 'diff'( gr_data[root,grG_metricName,grG_operands,baseSeq],
                                 gr_data[xup_,grG_metricName, a||n||_]) ),
             loopStmt) ):
  fi:
  body := procmake(body):
  grF_reassignMetrics():
  RETURN( body );

end:
