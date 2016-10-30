#==============================================================================
# initFn.mpl
#
# Some extra functions for the initialization of tensor components.
#
# Denis Pollney
# 18 September 1997
#
# Revisions:
# 18 Sep 1997	Created, with initzero, initcmpt [dp]
# 18 Aug 1999   Switched readstat and grF_my_readstat to grF_readstat [dp]
# 20 Aug 1999   Changed use of " to ` for R4 compatibility [dp]
#  9 Sep 1999   Fixed setcmpt() so that it is usable [dp]
#  9 Sep 1999   Added getsym() and setsym() hacks [dp]
#==============================================================================

#------------------------------------------------------------------------------
# initzero: initialise all components of an object to zero.
#------------------------------------------------------------------------------
initzero := proc ()
global grG_fnCode, grG_simp, grG_calc, grG_callComp, grG_lastObjectSeq:
local i, objSeq:
  if args[1]=_ then
    if assigned (grG_lastObjectSeq) then
      objSeq := grG_lastObjectSeq:
    else
      ERROR ( `No previous object sequence to recall.` ):
    fi:
  else 
    grF_checkIfDefined (args, create):
    objSeq := args:
  fi:
  grF_unassignLoopVars():
  grG_fnCode := grC_ZERO:
  grG_simp := false:
  grG_callComp := false:
  for i in grF_screenArgs ([objSeq], false, false) do
    grG_calc := true:
    grF_core (i, false):
  od:
  grG_lastObjectSeq := objSeq:
  NULL:
end:

grF_zeroCalcFn := proc (object, iList)
  RETURN (0):
end:

#------------------------------------------------------------------------------
# setcmpt: set a particular component of an object to a given value.
#  eg. setcmpt (R(dn,dn,dn,dn), [1,2,3,4] = -1, [2,3,3,4] = 1):
#
# Note: at the present time, this sets the components related via
# symmetry independently, so that if gralter() is applied, only the
# key component will be simplified while the others that have been set
# will retain their original form. This should be fixed (maybe using
# the symm function during the assignment phase. [dp]
#------------------------------------------------------------------------------
setcmpt := proc ()
local a, b, c, ic, clist, cmpt, val, objlist, obj, err, found, isgn,
  symSet, asymSet, fullSymList, idxInfo, idxList, idxSign, objSeq,
  diag, sym, usedset:
global grG_lastObjectSeq:

  if args[1]=_ then
    if assigned (grG_lastObjectSeq) then
      objSeq := grG_lastObjectSeq:
    else
      ERROR ( `No previous object sequence to recall.` ):
    fi:
  else 
    grF_checkIfDefined (args[1], create):
    objSeq := args[1]:
  fi:

  for obj in [objSeq] do
    if not (grF_checkIfAssigned (obj)) then
      initzero (obj):
    fi:
  
    for a from 2 to nargs do
      if type (args[a], equation) then
        if not type (lhs(args[a]), list) then
          ERROR (`Component was not specified as a list: `||lhs(args[a])):
        fi:
        cmpt := lhs(args[a]):
        val := rhs(args[a]):
      elif type (args[a], list) then
        cmpt := args[a]:
        printf (`Value for the %a component:\n`, args[a]):
        val := grF_readstat (``, [], `grinitcmpt`):
      fi:
  
      ic := true:
      for c in cmpt while ic do
        if not type (c, integer) then
          ic := false:
        fi:
      od:
  
      if not ic then
        clist := NULL:
        for c to nops(cmpt) do
          found := false:
          for b to Ndim||grG_metricName while not found do
            if cmpt[c]=grG_xup_[grG_metricName,b] then
              clist := clist,b:
              found := true:
            fi:
          od:
          if not found then
            clist := clist, cmpt[c]:
          fi:
        od:
        clist := [clist]:
      else
        clist := cmpt:
      fi:
  
      #
      # see grdef.mpl [dp]
      #
      if type (grG_ObjDef[obj][grC_symList], list) then
        symSet := grG_ObjDef[obj][grC_symList][1]:
        asymSet := grG_ObjDef[obj][grC_symList][2]:
      else
        symSet := {}:
        asymSet := {}:
      fi:
  
      diag := false:
      for sym in asymSet do
        usedset := {}:
        for b in sym while not diag do
	  c := op(b,clist):
	  if member (op(b,clist), usedset) then
            diag := true:
	  else
	    usedset := usedset union {c}:
	  fi:
	od:
      od:
      if diag then
        ERROR (printf (
	  `Attempted to set a component on an antisymmetric diagonal.\n`)):
      fi:

      fullSymList := [op(symSet union asymSet)]:
  
      if fullSymList <> [] then
        idxInfo := grF_getIdxInfo (nops(clist), symSet, asymSet):
  
        idxList := idxInfo[1]:
        idxSign := idxInfo[2]:
  
        for b to nops(clist) do
          idxList := subs (b=s||b||_, idxList):
        od:
        
        for b to nops(clist) do
          idxList := subs (s||b||_=op(b,clist), idxList):
        od:
        
        isgn := 'isgn':
        for b to nops (idxList) while not assigned (isgn) do
          if op(b,idxList) = clist then
            isgn := op(b,idxSign):
          fi:
        od:
      else
        idxList := [clist]:
        idxSign := [1]:
      fi:
  
      if not assigned (isgn) then
        isgn := 1:
      fi:
  
      for b to nops (idxList) do
        grG_||(grG_ObjDef[obj][grC_root])[grG_metricName,op(op(b,idxList))]
          := isgn*op(b,idxSign)*val:
      od:
    od:
  od:
  grG_lastObjectSeq := objSeq:
  NULL:
end:

#------------------------------------------------------------------------------
# getsym: prints out the symmetric and antisymmetric index sets of the tensor
#         (if they can be determined from the grC_symList variable)
#------------------------------------------------------------------------------
getsym := proc (object)
  grF_checkObjects ([object], false, false):
  if not type (grG_ObjDef[object][grC_symList], list) then
    printf (`SymList unknown. Not a grdef() defined object.\n`):
    RETURN():
  fi:
  print (`Symmetric indices` = grG_ObjDef[object][grC_symList][1]):
  print (`Antisymmetric indices` = grG_ObjDef[object][grC_symList][2]):
end:

#------------------------------------------------------------------------------
# setsym: sets the grC_symList of an object. symSet and asymSet are of the
#         form of sets of lists of integers ( eg. {[1,2],[3,4,6]} )
#------------------------------------------------------------------------------
setsym := proc (object, symSet, asymSet)
global grF_symFn_, grG_ObjDef:
local nidx:
  grF_checkObjects ([object], false, false):
  grG_ObjDef[object][grC_symList] := [symSet, asymSet]:
  nidx := nops (object):
  grF_symFn_[nidx, symSet, asymSet] := grF_create_symFn (nidx, symSet,
    asymSet):
  grG_ObjDef[object][grC_symmetry] := grF_symFn_[nidx, symSet, asymSet]:
  printf (`Symmetry function updated.\n`):
end:












