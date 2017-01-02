###########################
# SYMMETRY.MPL
###
# Converted from 5.2 to 5.3
###########################
#----------------------------------------------------------
# symmetry.mpl
#
# DEFINTION OF SYMMETRY ROUTINES AND VARIABLES FOR:
#  - tensor objects
#
# Contains the functions:
# grF_findSymmetry
# grF_sym_scalar        grF_sym_vector  grF_sym_sym2
# grF_sym_nosym2        grF_sym_Chr1    grF_sym_d2
# grF_sym_Riem          grF_sym_NRiem   grF_sym_MRiem
#
#
# ToDo: add nosym3 and nosym4
#
# Date         Reason
# -------------------
# Feb   2, 94   Add diff constraint support.
# Apr  23, 94   Use grF_symCore in all symmetry routines
# May   7, 94   Added operators (indexed names, grG_operands etc.)
# May  31, 94   Added Aconstraints
# Aug   3, 94   Added grF_sym_nosym5 [pm]
# Aug  23, 94   Added some 3-index symmetry routines [dp]
# Sept  5, 94   Special case in scalar for ds^2 [pm]
# Sept 21, 94	Added grF_sym_asym2 [dp]
# July  7, 95   Add profile to symettry core routine [pm]
# July 13, 95   Use lprint in grOptionVerbose [pm]
# Aug  23, 95   Use simpArgs in symCore [pm]
# Jan  17, 96   Add grF_sym_nosym0 (so grdef of these will work) [pm]
# Oct  21, 96   Change findSymmetry so it returns grF_symFn [pm]
# Mar  11, 97   Put iSeq= statement in symCore inside `if' (optimization) [dp]
# Feb  14, 97   Switch convert(x,string) to convert(x,name) for R5 [dp]
# Sep  10, 99   Fixed symmetry determination for new-style symLists [dp]
#----------------------------------------------------------

#----------------------------------------------------------
# grF_findSymmetry(permSet,numIndices)
#
# - given a set of permutations, see if any of the defined
# symmetries match. If not then assign a general routine
# based on the number of indices.
#----------------------------------------------------------

grF_findSymmetry := proc (object, permSet, num)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, c, nidx, symList;
global grF_symFn_, gr_data;

  if num = 0 then
    RETURN(grF_sym_scalar);
  elif num = 1 then
    RETURN(grF_sym_vector);
  else
    # original styled symmetry determination for objects in
    # tensors.mpl uses the grG_symmetry lists which are inconsistent
    # with grdef()'s symList structure. This should be replaced. [dp] 
 
   # scan the existing symmetries in grG_symmetry
   if not assigned (grG_ObjDef[object][grC_symList]) then
     a := indices(grG_symmetry);
     for b in a do
       c := op(b); # shed the bothersome square brackets
       if ((permSet minus grG_symmetry[c]) = {}) and (permSet <> {})
	 and ( (grG_symmetry[c] minus permSet) = {}) then
         RETURN(c);
       fi:
     od:
     # didn't get a match so assign the general routine
     if not assigned ( grF_symFn_[ num, {}, {}] ) then
        grF_symFn_[ num, {}, {}] := 
          grF_create_symFn ( num, {}, {} ):
     fi:
     RETURN( grF_symFn_[ num, {}, {}] ):
   else
     nidx := nops(grG_ObjDef[object][grC_indexList]):
     symList := op(grG_ObjDef[object][grC_symList]):
     if not assigned (grF_symFn_[nidx, symList]) then
       grF_symFn_[nidx, symList] :=
         grF_create_symFn (nidx, symList):
     fi:
     RETURN (grF_symFn_[nidx,symList]):
   fi:
 fi:
end:

#*****************************************************
#
# SYMMETRY CORE
#
#*****************************************************

grF_symCore := proc(objectName, iList, root)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 local tic, iSeq, simpArgs:
 global gr_data, grG_metricName, grG_profileList, grG_profileCount, grG_profileTimer, grG_profileSize:

 if grOptionVerbose and not grG_callComp then
    printf ("Component %s of %a\n", convert(iList,name), objectName):
 fi:
 if grG_simp then
      iSeq := grG_metricName,grG_operands,op(iList):
      if grOptionProfile and gr_data[root,iSeq] <> 0 then
	      grG_profileSize := grG_profileSize + length(gr_data[root,iSeq]);
	      grG_profileCount := grG_profileCount + 1;
	      grG_profileList := [op(grG_profileList),length(gr_data[root,iSeq])];
       fi:
       #
       # need simpArgs to allow NULLs to collapse before calling
       # single arg functions (otherwise get an error in e.g. eval)
       #
       simpArgs := grG_preSeq, gr_data[root,iSeq], grG_postSeq:
       tic := time();
       gr_data[root,iSeq] :=
	  grG_simpHow( simpArgs ); 
       grG_profileTimer := grG_profileTimer + time() - tic:
 fi:
 if grG_callComp then
       iSeq := grG_metricName,grG_operands,op(iList):
       grF_component(objectName,iList, gr_data[root,iSeq]);
 elif grOptionVerbose then
    printf (" done.\n"):
 fi:
end:

#*****************************************************
#
# SYMMETRY ROUTINES
#
#*****************************************************

grF_sym_nosym0 := grF_sym_scalar:

grG_symmetry[grF_sym_scalar] := {[]}:
#*** scalar ***
grF_sym_scalar := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global gr_data, grG_metricName:
	if grG_calc and assigned(calcFn) then
	   gr_data[root,grG_metricName,grG_operands] := calcFn(objectName,[]):
	fi:
        #
        # Here is a shameful special case. For the calculation
        # of ds^2 we don't want simplification after calculation,
        # since the dx^a will get messed up. So we avoid calling
        # the simplfication routine.
        #
        if not(grG_calc and objectName = ds) then
	  grF_symCore(objectName, [NULL], root):
        fi:
NULL; end: # return NULL

#*** vector ***
grG_symmetry[grF_sym_vector] := {[[1],1]}:

grF_sym_nosym1 := grF_sym_vector:

grF_sym_vector := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global gr_data, grG_metricName, a1_, grG_displayZero;
  #
  # better to print out the coordinates all on one line, so handle that
  # as a special case
  #
  if grG_fnCode = grC_DISP and objectName = x(up) then
    print( seq( `x `^convert(a1_,name) = gr_data[xup_,grG_metricName,a1_], a1_=1..Ndim[grG_metricName])):
    grG_displayZero := false:
  else
    for a1_ to Ndim[grG_metricName] do
      if grG_calc and assigned(calcFn) then
	 gr_data[root,grG_metricName,grG_operands,a1_] := calcFn(objectName,[a1_]):
      fi:
      grF_symCore(objectName, [a1_], root):
    od;
  fi:
NULL; end: # return NULL

#*** 2 index symmetric ***
grG_symmetry[grF_sym_sym2] := {[[2,1],1]}:

grF_sym_sym2 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_;
    for a1_ to Ndim[grG_metricName] do
      for a2_ from a1_ to Ndim[grG_metricName] do
	if grG_calc and assigned(calcFn)  then
	   # assignments here reflect symmetry
	   if a1_ <> a2_ then
	      gr_data[root,grG_metricName,grG_operands,a2_,a1_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_]:
	   fi:
	   # assignement
	   gr_data[root,grG_metricName,grG_operands,a1_,a2_] := calcFn(objectName,[a1_,a2_]):
	fi:
	grF_symCore(objectName, [a1_,a2_], root):
      od;
    od;
NULL; end: # return NULL

#*** 2 index anti-symmetric ***
grG_symmetry[grF_sym_asym2] := {[[2,1],-1]}:

grF_sym_asym2 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_;
    for a1_ to Ndim[grG_metricName] do
      for a2_ from a1_ to Ndim[grG_metricName] do
	if grG_calc and assigned(calcFn)  then
	   # assignments here reflect asymmetry
	   if a1_ <> a2_ then
	      gr_data[root,grG_metricName,grG_operands,a2_,a1_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_]:
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_] := calcFn(objectName,[a1_,a2_]):
           else
              gr_data[root,grG_metricName,grG_operands,a1_,a2_] := 0:
           fi:
	fi:
	grF_symCore(objectName, [a1_,a2_], root):
      od;
    od;
NULL; end: # return NULL


#*** two index - no symmetry ***
grF_sym_nosym2 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global gr_data, grG_metricName, a1_, a2_;
  # 2 index symmetric object
    for a1_ to Ndim[grG_metricName] do
      for a2_ to Ndim[grG_metricName] do
	if grG_calc and assigned(calcFn)  then
	  gr_data[root,grG_metricName,grG_operands,a1_,a2_] := calcFn(objectName,[a1_,a2_]):
	fi:
	grF_symCore(objectName, [a1_,a2_], root):
      od;
    od;
  NULL;
end:

#*** three index, symmetric in first two *** d1metric, Chr1 etc.
grG_symmetry[grF_sym_Chr1] := {[[2,1,3],1]}:

grF_sym_Chr1 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global gr_data, grG_metricName, a1_, a2_, a3_;
  # three index objects, sym w.r.t first two
    for a1_ to Ndim[grG_metricName] do
      for a2_ from a1_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName] do
	  if grG_calc and assigned(calcFn)  then
	     # assignments here reflect symmetry
	     if a1_ <> a2_ then
		gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_] :=  gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_]:
	     fi:
	     # assignment
	     gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := calcFn(objectName,[a1_,a2_,a3_]):
	  fi:
	  grF_symCore(objectName, [a1_,a2_,a3_], root):
	od;
      od;
    od;
NULL; end: # return NULL

#*** 3 indices, no symmetry ***
grG_symmetry[grF_sym_nosym3] := {}:

grF_sym_nosym3 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global gr_data, grG_metricName, a1_, a2_, a3_;
  # three index objects, sym w.r.t first two
    for a1_ to Ndim[grG_metricName] do
      for a2_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName] do
	  if grG_calc and assigned(calcFn)  then
	     gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := calcFn(objectName,[a1_,a2_,a3_]):
	  fi:
	  grF_symCore(objectName, [a1_,a2_,a3_], root):
	od;
      od;
    od;
  NULL;
end: # return NULL

#*** three index, anti-symmetric in first two *** eg. rotation coefficients
grG_symmetry[grF_sym_12] := {[[2,1,3],-1]}:

grF_sym_3a12 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global gr_data, grG_metricName, a1_, a2_, a3_;
  # three index objects, anti-sym w.r.t first two
    for a1_ to Ndim[grG_metricName] do
      for a2_ from a1_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName] do
	  if grG_calc and assigned(calcFn)  then
	     # assignments here reflect symmetry
	     if a1_ <> a2_ then
		gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_] :=  -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_]:
	        # assignment
	        gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := calcFn(objectName,[a1_,a2_,a3_]):
             else
                gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := 0:
             fi:
	  fi:
	  grF_symCore(objectName, [a1_,a2_,a3_], root):
	od;
      od;
    od;
NULL; end: # return NULL

#*** three index, anti-symmetric in first and third *** 
grG_symmetry[grF_sym_3a13] := {[[3,2,1],-1]}:

grF_sym_3a13 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global gr_data, grG_metricName, a1_, a2_, a3_;
  # three index objects, sym w.r.t first two
    for a1_ to Ndim[grG_metricName] do
      for a3_ from a1_ to Ndim[grG_metricName] do
	for a2_ to Ndim[grG_metricName] do
	  if grG_calc and assigned(calcFn)  then
	     # assignments here reflect symmetry
	     if a1_ <> a3_ then
		gr_data[root,grG_metricName,grG_operands,a3_,a2_,a1_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_]:
 	        # assignment
	        gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := calcFn(objectName,[a1_,a2_,a3_]):
             else
                gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := 0:
             fi:
	  fi:
	  grF_symCore(objectName, [a1_,a2_,a3_], root):
	od;
      od;
    od;
NULL; end: # return NULL

#*** three index, anti-symmetric in last two ***
grG_symmetry[grF_sym_3a23] := {[[1,3,2],-1]}:

grF_sym_3a23 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  global gr_data, grG_metricName, a1_, a2_, a3_;
  # three index objects, sym w.r.t first two
    for a2_ to Ndim[grG_metricName] do
      for a3_ from a2_ to Ndim[grG_metricName] do
	for a1_ to Ndim[grG_metricName] do
	  if grG_calc and assigned(calcFn)  then
	     # assignments here reflect symmetry
	     if a3_ <> a2_ then
		gr_data[root,grG_metricName,grG_operands,a1_,a3_,a2_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_]:
	        # assignment
	        gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := calcFn(objectName,[a1_,a2_,a3_]):
	     else
                gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_] := 0:
	     fi:
	  fi:
	  grF_symCore(objectName, [a1_,a2_,a3_], root):
	od;
      od;
    od;
NULL; end: # return NULL

#++++++++++++++++++++++++++++++++++++++
# FOUR INDICES
#++++++++++++++++++++++++++++++++++++++

#*** four index, symetric in first pair and second pair *** d2metric
grG_symmetry[grF_sym_d2] := { [[2,1,3,4],1], [[1,2,4,3],1] }:

grF_sym_d2 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_, a3_, a4_;
    for a1_ to Ndim[grG_metricName] do
      for a2_ from a1_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName] do
	  for a4_ from a3_ to Ndim[grG_metricName] do
	    if grG_calc and assigned(calcFn)  then
	      # assignments here reflect symmetry
	      if a1_ <> a2_ then
		 gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_,a4_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 if a3_ <> a4_ then
		    gr_data[root,grG_metricName,grG_operands,a2_,a1_,a4_,a3_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 fi:
	      fi:
	      if a3_ <> a4_ then
		 gr_data[root,grG_metricName,grG_operands,a1_,a2_,a4_,a3_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
	      fi:
	      # assignment
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_] := calcFn(objectName,[a1_,a2_,a3_,a4_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_], root):
	  od;
	od;
      od;
    od;
NULL; end: # return NULL

#*** four index - symmetry like the Riemann tensor ***
grG_symmetry[grF_sym_Riem] := { [[2,1,3,4],-1], [[1,2,4,3],-1], [[3,4,1,2],1] }:

grF_sym_Riem := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global gr_data, grG_metricName, a1_, a2_, a3_, a4_;
local x:
    if grG_calc and assigned(calcFn) then
    # by symmetry we know a number of terms are zero
      for a1_ to Ndim[grG_metricName] do
	for a2_ to Ndim[grG_metricName] do
	  for a3_ to Ndim[grG_metricName] do
	       gr_data[root,grG_metricName,grG_operands,a1_,a1_,a2_,a3_] := 0;
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a3_] := 0;
	  od;
	od;
      od;
    fi:
    for a1_ to Ndim[grG_metricName]-1 do
      for a2_ from a1_ + 1 to Ndim[grG_metricName] do
	for a3_ from a1_ to Ndim[grG_metricName]-1 do
	  if a3_ = a1_ then x := a2_ else x := a3_+1 fi;
	    for a4_ from x to Ndim[grG_metricName] do
	      if grG_calc and assigned(calcFn)  then
		 # assignments here reflect symmetries
		 gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_,a4_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 gr_data[root,grG_metricName,grG_operands,a1_,a2_,a4_,a3_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 gr_data[root,grG_metricName,grG_operands,a2_,a1_,a4_,a3_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 # now with first & second pair exchanged
		 gr_data[root,grG_metricName,grG_operands,a3_,a4_,a1_,a2_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 gr_data[root,grG_metricName,grG_operands,a3_,a4_,a2_,a1_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 gr_data[root,grG_metricName,grG_operands,a4_,a3_,a1_,a2_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 gr_data[root,grG_metricName,grG_operands,a4_,a3_,a2_,a1_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
		 #
		 # put assigment AFTER sym ,so when simplification occurs
		 # the symmetrized objects don't need reassigment
		 #
		 gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_] := calcFn(objectName,[a1_,a2_,a3_,a4_]):
	      fi:
	      grF_symCore(objectName, [a1_,a2_,a3_,a4_], root):
	   od;
	 od;
      od;
    od;
 NULL;
end: # return NULL

#*** four index - symmetry of Natural (1,3) Riemann tensor ***
grG_symmetry[grF_sym_NRiem] := { [[1,2,4,3],-1] }:

grF_sym_NRiem := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_, a3_, a4_;
    for a1_ to Ndim[grG_metricName] do
      for a2_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName]-1 do
	  for a4_ from a3_+1 to Ndim[grG_metricName] do
	    if grG_calc and assigned(calcFn)  then
	      # zero by symmetry
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a3_] := 0:
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_+1,a3_+1] := 0:

	      # assignments here reflect symmetry
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_,a4_,a3_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
	      # assignment
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_] :=  calcFn(objectName,[a1_,a2_,a3_,a4_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_], root):
	 od;
       od;
     od;
   od;
NULL; end: # return NULL

#*** four index symmetry of (2,2) Riemann tensor
grG_symmetry[grF_sym_MRiem] := { [[2,1,3,4],-1], [[1,2,4,3],-1] }:

grF_sym_MRiem := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_, a3_, a4_;
    if grG_calc and assigned(calcFn) then
      # by symmetry we know a number of terms are zero
      for a1_ to Ndim[grG_metricName] do
	for a2_ to Ndim[grG_metricName] do
	  for a3_ to Ndim[grG_metricName] do
	       gr_data[root,grG_metricName,grG_operands,a1_,a1_,a2_,a3_] := 0;
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a3_] := 0;
	  od;
	od;
      od;
    fi:
    for a1_ to Ndim[grG_metricName]-1 do
      for a2_ from a1_+1 to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName]-1 do
	  for a4_ from a3_+1 to Ndim[grG_metricName] do
	    if grG_calc and assigned(calcFn)  then
	       # assignments here reflect symmetry
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a4_,a3_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
	       gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_,a4_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
	       gr_data[root,grG_metricName,grG_operands,a2_,a1_,a4_,a3_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
	       # assignment
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_] := calcFn(objectName,[a1_,a2_,a3_,a4_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_], root):
	  od;
	od;
      od;
    od;
NULL;
end: # return NULL

#*** four index - no symmetry ***
grG_symmetry[grF_sym_nosym4] := {}:

grF_sym_nosym4 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_, a3_, a4_;
    for a1_ to Ndim[grG_metricName] do
      for a2_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName] do
	  for a4_ to Ndim[grG_metricName] do
	    if grG_calc and assigned(calcFn)  then
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_] :=  calcFn(objectName,[a1_,a2_,a3_,a4_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_], root):
	 od;
       od;
     od;
   od;
 NULL;
end: # return NULL

#*** four index - sym in first 2 no symmetry in last 2***
grG_symmetry[grF_sym_sym2nosym2] := {[[2,1,3,4],1]}:

grF_sym_sym2nosym2 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_, a3_, a4_;
    for a1_ to Ndim[grG_metricName] do
      for a2_ from a1_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName] do
	  for a4_ to Ndim[grG_metricName] do
	    if grG_calc and assigned(calcFn)  then
	      if a1_ <> a2_ then
		gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_,a4_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_]:
	      fi:
	      gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_] :=  calcFn(objectName,[a1_,a2_,a3_,a4_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_], root):
	 od;
       od;
     od;
   od;
 NULL;
end: # return NULL

grF_sym_LevC3 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
#
# all other terms are just sign changes of  e
#                                            123
#
  grF_symCore(objectName, [1,2,3], root):
 NULL:
end:


grF_sym_LevC4 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 #
 # all other terms are just sign changes of  e
 #                                            1234
 #
  grF_symCore(objectName, [1,2,3,4], root):
 NULL:
end:


#++++++++++++++++++++++++++++++++++++++
# FIVE INDICES
#++++++++++++++++++++++++++++++++++++++


#*** five index - symmetry like R_{a b c d ; e} ***

grG_symmetry[grF_sym_DRiem] := { [[2,1,3,4,5],-1], [[1,2,4,3,5],-1], [[3,4,1,2,5],1] }:

grF_sym_DRiem := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global gr_data, grG_metricName, a1_, a2_, a3_, a4_, a5_;
local x:
    if grG_calc and assigned(calcFn) then
    # by symmetry we know a number of terms are zero
    for a5_ to Ndim[grG_metricName] do
      for a1_ to Ndim[grG_metricName] do
	for a2_ to Ndim[grG_metricName] do
	  for a3_ to Ndim[grG_metricName] do
	       gr_data[root,grG_metricName,grG_operands,a1_,a1_,a2_,a3_,a5_] := 0;
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a3_,a5_] := 0;
	  od;
	od;
      od;
    od:
    fi:
    for a1_ to Ndim[grG_metricName]-1 do
      for a2_ from a1_ + 1 to Ndim[grG_metricName] do
	for a3_ from a1_ to Ndim[grG_metricName]-1 do
	  if a3_ = a1_ then x := a2_ else x := a3_+1 fi;
	    for a4_ from x to Ndim[grG_metricName] do
	      for a5_ to Ndim[grG_metricName] do
		if grG_calc and assigned(calcFn)  then
		  # assignments here reflect symmetries
		  gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_,a4_,a5_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
		  gr_data[root,grG_metricName,grG_operands,a1_,a2_,a4_,a3_,a5_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
		  gr_data[root,grG_metricName,grG_operands,a2_,a1_,a4_,a3_,a5_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
		  # now with first & second pair exchanged
		  gr_data[root,grG_metricName,grG_operands,a3_,a4_,a1_,a2_,a5_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
		  gr_data[root,grG_metricName,grG_operands,a3_,a4_,a2_,a1_,a5_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
		  gr_data[root,grG_metricName,grG_operands,a4_,a3_,a1_,a2_,a5_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
		  gr_data[root,grG_metricName,grG_operands,a4_,a3_,a2_,a1_,a5_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
		  #
		  # put assigment AFTER sym ,so when simplification occurs
		  # the symmetrized objects don't need reassigment
		  #
		  gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_] := calcFn(objectName,[a1_,a2_,a3_,a4_,a5_]):
	       fi:
	       grF_symCore(objectName, [a1_,a2_,a3_,a4_,a5_], root):
	     od:
	   od;
	 od;
      od;
    od;
 NULL;
end: # return NULL

#*** five index symmetry of CoD of (2,2) Riemann tensor
grG_symmetry[grF_sym_DMRiem] := { [[2,1,3,4,5],-1], [[1,2,4,3,5],-1] }:

grF_sym_DMRiem := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 global gr_data, grG_metricName, a1_, a2_, a3_, a4_, a5_;
 local N:

    N := Ndim[grG_metricName]:
    if grG_calc and assigned(calcFn) then
      # by symmetry we know a number of terms are zero
      for a1_ to N do
	for a2_ to N do
	  for a3_ to N do
	    for a5_ to N do
	       gr_data[root,grG_metricName,grG_operands,a1_,a1_,a2_,a3_, a5_] := 0;
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a3_, a5_] := 0;
	  od;
	od;
      od;
     od:
    fi:
    for a1_ to N-1 do
     for a2_ from a1_+1 to N do
      for a3_ to N-1 do
       for a4_ from a3_+1 to N do
	for a5_ to N do
	    if grG_calc and assigned(calcFn)  then
	       # assignments here reflect symmetry
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a4_,a3_,a5_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
	       gr_data[root,grG_metricName,grG_operands,a2_,a1_,a3_,a4_,a5_] := -gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
	       gr_data[root,grG_metricName,grG_operands,a2_,a1_,a4_,a3_,a5_] := gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_]:
	       # assignment
	       gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_] := calcFn(objectName,[a1_,a2_,a3_,a4_,a5_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_,a5_], root):
	od:
       od;
      od;
     od;
    od;
NULL;
end: # return NULL

#*** four index - no symmetry ***
grG_symmetry[grF_sym_nosym5] := {}:

grF_sym_nosym5 := proc(objectName, root, calcFn)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
    global gr_data, grG_metricName, a1_, a2_, a3_, a4_, a5_;
    for a1_ to Ndim[grG_metricName] do
      for a2_ to Ndim[grG_metricName] do
	for a3_ to Ndim[grG_metricName] do
	  for a4_ to Ndim[grG_metricName] do
	    for a5_ to Ndim[grG_metricName] do
	      if grG_calc and assigned(calcFn)  then
	        gr_data[root,grG_metricName,grG_operands,a1_,a2_,a3_,a4_,a5_] :=
                      calcFn(objectName,[a1_,a2_,a3_,a4_,a5_]):
	      fi:
	      grF_symCore(objectName, [a1_,a2_,a3_,a4_,a5_], root):
            od:
	 od;
       od;
     od;
   od;
 NULL;
end: # return NULL
