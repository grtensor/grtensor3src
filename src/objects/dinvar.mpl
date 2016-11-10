
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: dinvar.mpl
#
# Definitions for Differential invariants.
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: April 16 1994
#
# Revisions:
#
# April 18 1994		Fixed calc_dMRicci
# April 19 1994		Fixed diS
# April 31 1994         Change to cdn, cup where required
# Oct    1 1994         Fix typo in diRiem. Remove help.
# Jan   20 1995 	Added dR..d4R
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Object defintions are now inside a load_objects function
#

grG_symmetry[grF_sym_D2MRiem] := 
  { [[2,1,3,4,5,6],-1], [[1,2,4,3,5,6],-1] }:
grG_symmetry[grF_sym_D3MRiem] := 
  { [[2,1,3,4,5,6,7],-1], [[1,2,4,3,5,6,7],-1] }:
grG_symmetry[grF_sym_D4MRiem] := { [[2,1,3,4,5,6,7,8],-1], 
      [[1,2,4,3,5,6,7,8],-1] }:



#////////////////////////////////////////////////////////
#
# GENERIC CALCULATION FUNCTIONS
#
#////////////////////////////////////////////////////////


#--------------------------------------------------------
# grF_calc_diRiem
#--------------------------------------------------------

grF_calc_diRiem := proc( object, iList)
option `Copyright 1994-2001 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,c,d,e,f, root, s, n:
global gr_data, grG_metricName;

 root := grG_ObjDef[object][grC_calcFnParms]:
 s := 0:
 n := Ndim[grG_metricName]:

 for e to n do
  for f to n do
   if gr_data[gupup_,grG_metricName,e,f] <> 0 then
    for a to n do
     for b from a+1 to n do
      for c to n do
       for d from c+1 to n do
        s := s + gr_data[gupup_,grG_metricName,e,f] *
           gr_data[root,grG_metricName,a,b,c,d,e]*gr_data[root,grG_metricName,c,d,a,b,f]:
       od:
      od:
     od:
    od:
   fi:
  od:
 od:

 RETURN(4*s):

end:

#--------------------------------------------------------
# grF_calc_diRicci
#--------------------------------------------------------

grF_calc_diRicci := proc( object, iList)
option `Copyright 1994-2001 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a,b,c,d, root, s, n:
global gr_data, grG_metricName;

 root := grG_ObjDef[object][grC_calcFnParms]:
 s := 0:
 n := Ndim[grG_metricName]:

 for a to n do
  for b to n do
   for c to n do
     for d to n do
       s := s + gr_data[gupup_,grG_metricName,c,d] *
            gr_data[root,grG_metricName,a,b,c]*gr_data[root,grG_metricName,b,a,d]:
     od:
   od:
  od:
 od:

 RETURN(s):

end:


#//////////////////////////////////////
#
# OBJECT DEFINTIONS
#
#//////////////////////////////////////


#----------------------------
# diRicci
#
#----------------------------
grG_ObjDef[diRicci][grC_header] := ` R_{a b ; e} R^{a b ; e}`:
grG_ObjDef[diRicci][grC_root] := diRicci_:
grG_ObjDef[diRicci][grC_rootStr] := `diRicci `:
grG_ObjDef[diRicci][grC_indexList] := []:
grG_ObjDef[diRicci][grC_calcFn] := grF_calc_diRicci:
grG_ObjDef[diRicci][grC_calcFnParms] := Rdnupcdn_:
grG_ObjDef[diRicci][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[diRicci][grC_depends] := { R(dn,up,cdn)}:

#----------------------------
# dR
#----------------------------
grG_ObjDef[dR][grC_header] := ` dR`:
grG_ObjDef[dR][grC_root] := dRicci_:
grG_ObjDef[dR][grC_rootStr] := `dR `:
grG_ObjDef[dR][grC_indexList] := []:
grG_ObjDef[dR][grC_calcFn] := grF_calc_dR:
grG_ObjDef[dR][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[dR][grC_depends] := {Ricciscalar(cdn),g(up,up)}:


grF_calc_dR := proc(object, iList)

local e1,e2, s, N, root:
global gr_data, grG_metricName;

 root := Ricciscalarcdn_:
 N := Ndim[grG_metricName]:
 s := 0:

 #
 # outer loops are for the summations of the
 # covariant derivative indices
 #
   for e1 to N do
   for e2 to N do
        s := s +
           gr_data[gupup_,grG_metricName,e1,e2] *
           gr_data[root,grG_metricName,e1]*gr_data[root,grG_metricName,e2]:
  od:
  od:

 RETURN(s):

end:

#----------------------------
# d2R
#----------------------------
grG_ObjDef[d2R][grC_header] := ` d2R`:
grG_ObjDef[d2R][grC_root] := d2Ricci_:
grG_ObjDef[d2R][grC_rootStr] := `d2R `:
grG_ObjDef[d2R][grC_indexList] := []:
grG_ObjDef[d2R][grC_calcFn] := grF_calc_d2R:
grG_ObjDef[d2R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[d2R][grC_depends] := {Ricciscalar(cdn,cdn),g(up,up)}:


grF_calc_d2R := proc(object, iList)

local e1,e2,f1,f2, s, N, root:
global gr_data, grG_metricName;

 root := Ricciscalarcdncdn_:
 N := Ndim[grG_metricName]:
 s := 0:

 #
 # outer loops are for the summations of the
 # covariant derivative indices
 #
   for e1 to N do
   for e2 to N do
   if gr_data[gupup_,grG_metricName,e1,e2] <> 0 then
   for f1 to N do
   for f2 to N do
   if gr_data[gupup_,grG_metricName,f1,f2] <> 0 then

        s := s +
           gr_data[gupup_,grG_metricName,e1,e2] *
           gr_data[gupup_,grG_metricName,f1,f2] *
           gr_data[root,e1,f1]*gr_data[root,e2,f2]:
  fi:
  od:
  od:
  fi:
  od:
  od:

 RETURN(s):

end:
#----------------------------
# d3R
#----------------------------
grG_ObjDef[d3R][grC_header] := ` d3R`:
grG_ObjDef[d3R][grC_root] := d3Ricci_:
grG_ObjDef[d3R][grC_rootStr] := `d3R `:
grG_ObjDef[d3R][grC_indexList] := []:
grG_ObjDef[d3R][grC_calcFn] := grF_calc_d3R:
grG_ObjDef[d3R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[d3R][grC_depends] := {Ricciscalar(cdn,cdn,cdn),g(up,up)}:


grF_calc_d3R := proc(object, iList)

local e1,e2,f1,f2,g1,g2, s, N, root:
global gr_data, grG_metricName;

 root := Ricciscalarcdncdncdn_:
 N := Ndim[grG_metricName]:
 s := 0:

 #
 # outer loops are for the summations of the
 # covariant derivative indices
 #
   for e1 to N do
   for e2 to N do
   if gr_data[gupup_,grG_metricName,e1,e2] <> 0 then
   for f1 to N do
   for f2 to N do
   if gr_data[gupup_,grG_metricName,f1,f2] <> 0 then
   for g1 to N do
   for g2 to N do
   if gr_data[gupup_,grG_metricName,g1,g2] <> 0 then

        s := s +
           gr_data[gupup_,grG_metricName,e1,e2] *
           gr_data[gupup_,grG_metricName,f1,f2] *
           gr_data[gupup_,grG_metricName,g1,g2] *
           gr_data[root,e1,f1,g1]*gr_data[root,e2,f2,g2]:
  fi:
  od:
  od:
  fi:
  od:
  od:
  fi:
  od:
  od:

 RETURN(s):

end:
#----------------------------
# d4R
#----------------------------
grG_ObjDef[d4R][grC_header] := ` d4R`:
grG_ObjDef[d4R][grC_root] := d4Ricci_:
grG_ObjDef[d4R][grC_rootStr] := `d4R `:
grG_ObjDef[d4R][grC_indexList] := []:
grG_ObjDef[d4R][grC_calcFn] := grF_calc_d4R:
grG_ObjDef[d4R][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[d4R][grC_depends] := {Ricciscalar(cdn,cdn,cdn,cdn),g(up,up)}:


grF_calc_d4R := proc(object, iList)

local e1,e2,f1,f2,g1,g2,h1,h2, s, N, root:
global gr_data, grG_metricName;

 root := Ricciscalarcdncdncdncdn_:
 N := Ndim[grG_metricName]:
 s := 0:

 #
 # outer loops are for the summations of the
 # covariant derivative indices
 #
   for e1 to N do
   for e2 to N do
   if gr_data[gupup_,grG_metricName,e1,e2] <> 0 then
   for f1 to N do
   for f2 to N do
   if gr_data[gupup_,grG_metricName,f1,f2] <> 0 then
   for g1 to N do
   for g2 to N do
   if gr_data[gupup_,grG_metricName,g1,g2] <> 0 then
   for h1 to N do
   for h2 to N do
   if gr_data[gupup_,grG_metricName,h1,h2] <> 0 then

        s := s +
           gr_data[gupup_,grG_metricName,e1,e2] *
           gr_data[gupup_,grG_metricName,f1,f2] *
           gr_data[gupup_,grG_metricName,g1,g2] *
           gr_data[gupup_,grG_metricName,h1,h2] *
           gr_data[root,e1,f1,g1,h1]*gr_data[root,e2,f2,g2,h2]:
  fi:
  od:
  od:
  fi:
  od:
  od:
  fi:
  od:
  od:
  fi:
  od:
  od:

 RETURN(s):

end:
#----------------------------
# diRiem
#
#----------------------------
grG_ObjDef[diRiem][grC_header] := ` R_{a b c d ; e} R^{a b c d ; e}`:
grG_ObjDef[diRiem][grC_root] := diRiem_:
grG_ObjDef[diRiem][grC_rootStr] := `diRiem `:
grG_ObjDef[diRiem][grC_indexList] := []:
grG_ObjDef[diRiem][grC_calcFn] := grF_calc_diRiem:
grG_ObjDef[diRiem][grC_calcFnParms] := Rdndnupupcdn_:
grG_ObjDef[diRiem][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[diRiem][grC_depends] := { R(dn,dn,up,up,cdn)}:

#----------------------------
# d2Riem
#----------------------------
grG_ObjDef[d2Riem][grC_header] := ` d2Riem`:
grG_ObjDef[d2Riem][grC_root] := d2Riem_:
grG_ObjDef[d2Riem][grC_rootStr] := `d2Riem `:
grG_ObjDef[d2Riem][grC_indexList] := []:
grG_ObjDef[d2Riem][grC_calcFn] := grF_calc_d2Riem:
grG_ObjDef[d2Riem][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[d2Riem][grC_depends] := {R(dn,dn,up,up,cdn,cdn),g(up,up)}:


grF_calc_d2Riem := proc(object, iList)

local a,b,c,d, e1,e2,f1,f2, s, N, root:
global gr_data, grG_metricName;

 root := Rdndnupupcdncdn_:
 N := Ndim[grG_metricName]:
 s := 0:

 #
 # outer loops are for the summations of the
 # covariant derivative indices
 #
   for e1 to N do
   for e2 to N do
   if gr_data[gupup_,grG_metricName,e1,e2] <> 0 then
   for f1 to N do
   for f2 to N do
   if gr_data[gupup_,grG_metricName,f1,f2] <> 0 then

    #
    # central core (these are the mixed Riemann syms)
    #
    for a to N do
     for b from a+1 to N do
      for c to N do
       for d from c+1 to N do
        s := s +
           gr_data[gupup_,grG_metricName,e1,e2] *
           gr_data[gupup_,grG_metricName,f1,f2] *
           gr_data[root,a,b,c,d,e1,f1]*gr_data[root,c,d,a,b,e2,f2]:
       od:
      od:
     od:
    od:
  fi:
  od:
  od:
  fi:
  od:
  od:

 RETURN(4*s):

end:

#----------------------------
# d3Riem
#----------------------------
grG_ObjDef[d3Riem][grC_header] := ` d3Riem`:
grG_ObjDef[d3Riem][grC_root] := d3Riem_:
grG_ObjDef[d3Riem][grC_rootStr] := `d3Riem `:
grG_ObjDef[d3Riem][grC_indexList] := []:
grG_ObjDef[d3Riem][grC_calcFn] := grF_calc_d3Riem:
grG_ObjDef[d3Riem][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[d3Riem][grC_depends] := {R(dn,dn,up,up,cdn,cdn,cdn),g(up,up)}:


grF_calc_d3Riem := proc(object, iList)

local a,b,c,d, e1,e2,f1,f2,g1,g2,root, s, N:
global gr_data, grG_metricName;

 N := Ndim[grG_metricName]:
 s := 0:
 root := Rdndnupupcdncdncdn_:

 #
 # outer loops are for the summations of the
 # covariant derivative indices
 #
   for e1 to N do
   for e2 to N do
   if gr_data[gupup_,grG_metricName,e1,e2] <> 0 then
   for f1 to N do
   for f2 to N do
   if gr_data[gupup_,grG_metricName,f1,f2] <> 0 then
   for g1 to N do
   for g2 to N do
   if gr_data[gupup_,grG_metricName,g1,g2] <> 0 then

    #
    # central core (these are the mixed Riemann syms)
    #
    for a to N do
     for b from a+1 to N do
      for c to N do
       for d from c+1 to N do
        s := s +
           gr_data[gupup_,grG_metricName,e1,e2] *
           gr_data[gupup_,grG_metricName,f1,f2] *
           gr_data[gupup_,grG_metricName,g1,g2] *
           gr_data[root,a,b,c,d,e1,f1,g1]*gr_data[root,c,d,a,b,e2,f2,g2]:
       od:
      od:
     od:
    od:
  fi:
  od:
  od:
  fi:
  od:
  od:
  fi:
  od:
  od:

 RETURN(4*s):

end:

#----------------------------
# d4Riem
#----------------------------
grG_ObjDef[d4Riem][grC_header] := ` d4Riem`:
grG_ObjDef[d4Riem][grC_root] := d4Riem_:
grG_ObjDef[d4Riem][grC_rootStr] := `d4Riem `:
grG_ObjDef[d4Riem][grC_indexList] := []:
grG_ObjDef[d4Riem][grC_calcFn] := grF_calc_d4Riem:
grG_ObjDef[d4Riem][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[d4Riem][grC_depends] := {R(dn,dn,up,up,cdn,cdn,cdn,cdn),g(up,up)}:


grF_calc_d4Riem := proc(object, iList)

local a,b,c,d, e1,e2,f1,f2,g1,g2,h1,h2, s, N, root:
global gr_data, grG_metricName;

 N := Ndim[grG_metricName]:
 s := 0:
 root := Rdndnupupcdncdncdncdn_:

 #
 # outer loops are for the summations of the
 # covariant derivative indices
 #
   for e1 to N do
   for e2 to N do
   if gr_data[gupup_,grG_metricName,e1,e2] <> 0 then
   for f1 to N do
   for f2 to N do
   if gr_data[gupup_,grG_metricName,f1,f2] <> 0 then
   for g1 to N do
   for g2 to N do
   if gr_data[gupup_,grG_metricName,g1,g2] <> 0 then
   for h1 to N do
   for h2 to N do
   if gr_data[gupup_,grG_metricName,h1,h2] <> 0 then

    #
    # central core (these are the mixed Riemann syms)
    #
    for a to N do
     for b from a+1 to N do
      for c to N do
       for d from c+1 to N do
        s := s +
           gr_data[gupup_,grG_metricName,e1,e2] *
           gr_data[gupup_,grG_metricName,f1,f2] *
           gr_data[gupup_,grG_metricName,g1,g2] *
           gr_data[gupup_,grG_metricName,h1,h2] *
           gr_data[root,a,b,c,d,e1,f1,g1,h1]*
           gr_data[root,c,d,a,b,e2,f2,g2,h2]:
       od:
      od:
     od:
    od:
  fi:
  od:
  od:
  fi:
  od:
  od:
  fi:
  od:
  od:
  fi:
  od:
  od:

 RETURN(4*s):

end:


#----------------------------
# diS
#
#----------------------------
grG_ObjDef[diS][grC_header] := ` S_{a b ; e} S^{a b ; e}`:
grG_ObjDef[diS][grC_root] := diS_:
grG_ObjDef[diS][grC_rootStr] := `diS `:
grG_ObjDef[diS][grC_indexList] := []:
grG_ObjDef[diS][grC_calcFn] := grF_calc_diRicci:
grG_ObjDef[diS][grC_calcFnParms] := Sdnupcdn_:
grG_ObjDef[diS][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[diS][grC_depends] := { S(dn,up,cdn)}:

#----------------------------
# diWeyl
#
#----------------------------
grG_ObjDef[diWeyl][grC_header] := ` C_{a b c d ; e} C^{a b c d ; e}`:
grG_ObjDef[diWeyl][grC_root] := diWeyl_:
grG_ObjDef[diWeyl][grC_rootStr] := `diWeyl `:
grG_ObjDef[diWeyl][grC_indexList] := []:
grG_ObjDef[diWeyl][grC_calcFn] := grF_calc_diRiem:
grG_ObjDef[diWeyl][grC_calcFnParms] := Cdndnupupcdn_:
grG_ObjDef[diWeyl][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[diWeyl][grC_depends] := { C(dn,dn,up,up,cdn)}:

#----------------------------
# diWeylstar
#
#----------------------------
grG_ObjDef[diWeylstar][grC_header] := ` C_{a b c d ; e} C^{a b c d ; e}`:
grG_ObjDef[diWeylstar][grC_root] := diWeylstar_:
grG_ObjDef[diWeylstar][grC_rootStr] := `diWeylstar `:
grG_ObjDef[diWeylstar][grC_indexList] := []:
grG_ObjDef[diWeylstar][grC_calcFn] := grF_calc_diRiem:
grG_ObjDef[diWeylstar][grC_calcFnParms] := Cstardndnupupcdn_:
grG_ObjDef[diWeylstar][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[diWeylstar][grC_depends] := { Cstar(dn,dn,up,up,cdn)}:


#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#
# SYMMETRY ROUTINES
#
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


#*** six index symmetry of CoD of (2,2) Riemann tensor


grF_sym_D2MRiem := proc(objectName, root, calcFn)
option `Copyright 1994-2001 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 global  a1_, a2_, a3_, a4_, a5_, a6_, a7_, a8_, a9_, a10_, gr_data, grG_metricName;
 local N, dSeq:

    N := Ndim[grG_metricName]:
    if grG_calc and assigned(calcFn) then
      # by symmetry we know a number of terms are zero
      for a1_ to N do
	for a2_ to N do
	  for a3_ to N do
	    for a5_ to N do
	    for a6_ to N do
	       gr_data[root,grG_metricName,opSeq,a1_,a1_,a2_,a3_, a5_,a6_] := 0;
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a3_, a5_,a6_] := 0;
          od:
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
	for a6_ to N do
	    if grG_calc and assigned(calcFn)  then
	       # assignments here reflect symmetry
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a4_,a3_,a5_,a6_] :=
                  -gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_]:
	       gr_data[root,grG_metricName,opSeq,a2_,a1_,a3_,a4_,a5_,a6_] :=
                  -gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_]:
	       gr_data[root,grG_metricName,opSeq,a2_,a1_,a4_,a3_,a5_,a6_] :=
                  gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_]:
	       # assignment
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_] := calcFn(objectName,[a1_,a2_,a3_,a4_,a5_,a6_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_,a5_,a6_], root):
        od:
	od:
       od;
      od;
     od;
    od;
NULL;
end: # return NULL

#*** seven index symmetry of CoD of (2,2) Riemann tensor
grF_sym_D3MRiem := proc(objectName, root, calcFn)
option `Copyright 1994-2001 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 global  a1_, a2_, a3_, a4_, a5_, a6_, a7_, a8_, a9_, a10_, gr_data, grG_metricName;
 local N, dSeq:

    N := Ndim[grG_metricName]:
    if grG_calc and assigned(calcFn) then
      # by symmetry we know a number of terms are zero
      for a1_ to N do
	for a2_ to N do
	  for a3_ to N do
	    for a5_ to N do
	    for a6_ to N do
	    for a7_ to N do
	       gr_data[root,grG_metricName,opSeq,a1_,a1_,a2_,a3_, a5_,a6_,a7_] := 0;
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a3_, a5_,a6_,a7_] := 0;
          od:
          od:
	  od;
	od;
      od;
     od:
    fi:
#print(`Done init to zero`):
    for a1_ to N-1 do
#print(`Main loop ` = a1_):
     for a2_ from a1_+1 to N do
      for a3_ to N-1 do
#print(`a3 loop `=a3_):
       for a4_ from a3_+1 to N do
	for a5_ to N do
	for a6_ to N do
	for a7_ to N do
	    if grG_calc and assigned(calcFn)  then
	       # assignments here reflect symmetry
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a4_,a3_,a5_,a6_,a7_] :=
                  -gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_]:
	       gr_data[root,grG_metricName,opSeq,a2_,a1_,a3_,a4_,a5_,a6_,a7_] :=
                  -gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_]:
	       gr_data[root,grG_metricName,opSeq,a2_,a1_,a4_,a3_,a5_,a6_,a7_] :=
                  gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_]:
	       # assignment
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_] :=
                  calcFn(objectName,[a1_,a2_,a3_,a4_,a5_,a6_,a7_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_,a5_,a6_,a7_], root):
        od:
        od:
	od:
       od;
      od;
     od;
    od;
NULL;
end: # return NULL

#*** eight index symmetry of CoD of (2,2) Riemann tensor
grF_sym_D4MRiem := proc(objectName, root, calcFn)
option `Copyright 1994-2001 by Peter Musgrave, Denis Pollney and Kayll Lake`;
 global  a1_, a2_, a3_, a4_, a5_, a6_, a7_, a8_, a9_, a10_, gr_data, grG_metricName;
 local N, dSeq:

    N := Ndim[grG_metricName]:
    if grG_calc and assigned(calcFn) then
      # by symmetry we know a number of terms are zero
      for a1_ to N do
	for a2_ to N do
	  for a3_ to N do
	    for a5_ to N do
	    for a6_ to N do
	    for a7_ to N do
	    for a8_ to N do
	       gr_data[root,grG_metricName,opSeq,a1_,a1_,a2_,a3_, a5_,a6_,a7_,a8_] := 0;
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a3_, a5_,a6_,a7_,a8_] := 0;
          od:
          od:
          od:
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
	for a6_ to N do
	for a7_ to N do
	for a8_ to N do
	    if grG_calc and assigned(calcFn)  then
	       # assignments here reflect symmetry
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a4_,a3_,a5_,a6_,a7_,a8_] :=
                  -gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_,a8_]:
	       gr_data[root,grG_metricName,opSeq,a2_,a1_,a3_,a4_,a5_,a6_,a7_,a8_] :=
                  -gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_,a8_]:
	       gr_data[root,grG_metricName,opSeq,a2_,a1_,a4_,a3_,a5_,a6_,a7_,a8_] :=
                  gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_,a8_]:
	       # assignment
	       gr_data[root,grG_metricName,opSeq,a1_,a2_,a3_,a4_,a5_,a6_,a7_,a8_] := calcFn(objectName,[a1_,a2_,a3_,a4_,a5_,a6_,a7_,a8_]):
	    fi:
	    grF_symCore(objectName, [a1_,a2_,a3_,a4_,a5_,a6_,a7_,a8_], root):
        od:
        od:
        od:
	od:
       od;
      od;
     od;
    od;
NULL;
end: # return NULL




