########################################################
#
# Definitions and code for Elasticity Calculations
# 
#
# Jan 18  1996  Created. [pm]
# Jan 24  1996  Make a seperate package from junction [pm]
# Feb  2  1996  Reverse conventions (defult now deformed) [pm]
# Feb  6  1996  Make Phi etc. in stress function of coordinates
#               which appear in the invariants [pm]
# Feb 14  1996  Add bodystate [pm]
#
########################################################
#
# N.B. Note gname refers to the joined metric !!
#
macro(gname=grG_join_[grG_metricName]);
macro(Gname= grG_metricName);

elasticity := proc()
   printf(`The Elasticity Package\n`);
   printf(`Last Modified Feb. 14, 1996\n`);
   printf(`Created by P. Musgrave and K. Lake. Copyright 1996`);
end:


read `oper.mpl`;

body := proc( eqn1:equation, eqn2:equation)
#
# default metric will be G{ij} once done
# and it will be joined to g{ij}
#
global g,G, grG_default_metricName, grG_join_:

local default, joined:

  default := subs( eqn1,eqn2, G);
  joined := subs( eqn1, eqn2, g);

  grG_join_[ default] := joined:
  grG_default_metricName := default:

  printf(`The default metric is now: %s.\n`, default):


end:

bodystate := proc( newmetric:name, xform:list)
#
# bodystate is a watered down grtransform which 
# always transforms a euclidean metric to the
# body coordinates as indicated by xform.
#
# i.e g{i j} = diff( xform^a, x^i) diff( xform^b, x^j) I{a b}
#
# typical call: bodystate( deformed, [ y1(x,y)=x+k*y, y2(y)=y, y3(z)=z]);
#

local bodycoords, ecoords, i, j, a, dim;

global grG_metricSet, grG_default_metricName, grG_gdndn_, grG_xup_,
       Ndim;

   if member( newmetric, grG_metricSet) then
     ERROR(`The metric name `.newmetric.` has been used already.`);
   fi:

   bodycoords := [];
   dim := nops(xform);
   for i to dim do
     if not ( type(xform[i], equation) and type( lhs(xform[i]), function)) then
      ERROR(`Transformation entries must be of the form  y1(x,y)=x+k*y etc.`);
     fi:
     for a to nops( lhs(xform[i]) ) do
       # only add unique body coordinates to the list (avoid duplicates)
       if not has( bodycoords, op(a, lhs(xform[i])) ) then
          bodycoords := [ op(bodycoords), op(lhs(xform[i])) ];
       fi: 
     od:    
  od:

  ecoords := [ seq( op(0,lhs(xform[i])), i=1..nops(xform) ) ];
  
  for i to dim do
    grG_xup_[ newmetric, i] := bodycoords[i]:
    for j to dim do   
       grG_gdndn_[newmetric,i,j] := 0;
       for a to dim do
          grG_gdndn_[newmetric,i,j] := grG_gdndn_[newmetric,i,j]
              + diff( rhs(xform[a]), bodycoords[i] ) *
                diff( rhs(xform[a]), bodycoords[j] ):
       od:
    od:
  od:
  grG_gdndn_[ newmetric, 0, 0] := true: # calced flag
  Ndim[ newmetric] := dim:
  Ndim||newmetric := dim:

  grG_metricSet := grG_metricSet union {newmetric}:

  grG_default_metricName := newmetric:
  lprint(`The default metric is now `.newmetric);

  grdisplay( g(dn,dn) ); 

end:


#///////////////////////////////////////////////////////
# OBJECT DEFINITIONS
#///////////////////////////////////////////////////////

#----------------------------
# strain (we need to define both up and dn
# forms since auto raising would screw things up)
#
#  (G{i j} - g{i j})/2
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[strain(dn,dn)]):
gr[grC_header] := `Strain Tensor`:
gr[grC_root] := straindndn_:
gr[grC_rootStr] := `strain `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] := '(grG_gdndn_[ Gname, a1_, a2_] -
   grG_gdndn_[ gname, a1_, a2_])/2':

gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := {}:

macro( gr = grG_ObjDef[strain(up,up)]):
gr[grC_header] := `Strain Tensor`:
gr[grC_root] := strainupup_:
gr[grC_rootStr] := `strain `:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] := '(grG_gupup_[ Gname, a1_, a2_] -
   grG_gupup_[ gname, a1_, a2_])/2':
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { g(up,up), [ gname, g(up,up) ]}:

#----------------------------
# B(up,up) (we need to define both up and dn
# forms since auto raising would screw things up)
#
#  I1 g{^i ^j} - g{^i ^r} g{^i ^s} G{r s}
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[B(up,up)]):
gr[grC_header] := `Elasticity Tensor B`:
gr[grC_root] := Bupup_:
gr[grC_rootStr] := `B `:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_calc_Bupup_:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { [ gname, g(up,up)], I1 }:

grF_calc_Bupup_ := proc(object, iList)

local s, a, b:

  s := grG_I1_[Gname] * grG_gupup_[gname, a1_, a2_]:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s - grG_gupup_[gname, a1_, a] * grG_gupup_[gname, a2_, b]
             * grG_gdndn_[ Gname, a,b]:
    od:
  od:

  RETURN(s):

end:

macro( gr = grG_ObjDef[B(dn,dn)]):
gr[grC_header] := `Elasticity Tensor B`:
gr[grC_root] := Bdndn_:
gr[grC_rootStr] := `B `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_Bdndn_:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { g(up,up), I1 }:

grF_calc_Bdndn_ := proc(object, iList)

local s, a, b:

  s := grG_I1_[Gname] * grG_gdndn_[gname, a1_, a2_]:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s - grG_gdndn_[gname, a1_, a] * grG_gdndn_[gname, a2_, b]
             * grG_gupup_[ Gname, a,b]:
    od:
  od:

  RETURN(s):

end:

#----------------------------
# stress(up,up) (we need to define both up and dn
# forms since auto raising would screw things up)
#
#  Psi g{^i ^j} + Psi B{^i ^j} + p G{^i ^j}
#
# Conservation Law for the surface
#----------------------------
macro( gr = grG_ObjDef[stress(up,up)]):
gr[grC_header] := `stress tensor`:
gr[grC_root] := stressupup_:
gr[grC_rootStr] := tau:
gr[grC_indexList] := [up,up]:
gr[grC_calcFn] := grF_calc_stress:
gr[grC_calcFnParms] := upup_:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { B(up,up), [gname, g(up,up)], g(up,up) }:

macro( gr = grG_ObjDef[stress(dn,dn)]):
gr[grC_header] := `stress tensor`:
gr[grC_root] := stressdndn_:
gr[grC_rootStr] := `stress `:
gr[grC_indexList] := [dn,dn]:
gr[grC_calcFn] := grF_calc_stress:
gr[grC_calcFnParms] := dndn_:
gr[grC_symmetry] := grF_sym_sym2:
gr[grC_depends] := { B(dn,dn) }:

grF_calc_stress := proc( object, iList)

local vars, ind, i, fnVars, sex;

  sex := grG_ObjDef[ object][grC_calcFnParms]:
  ind := `union`( indets(grG_I1_[ Gname]), 
		  indets(grG_I2_[ Gname]),
		  indets(grG_I3_[ Gname]) ):
  vars := {seq( grG_xup_[gname, i], i=1..Ndim[Gname] )}:
  fnVars := vars intersect ind:
  
  if fnVars <> {} then
     fnVars := op(fnVars):
     Phi(fnVars) * grG_g.sex[ gname, a1_, a2_]
     + psi(fnVars) * grG_B.sex[ Gname, a1_, a2_]
     + p(fnVars) * grG_g.sex[ Gname, a1_, a2_];
  else
     Phi * grG_g.sex[ gname, a1_, a2_]
     + psi * grG_B.sex[ Gname, a1_, a2_]
     + p * grG_g.sex[ Gname, a1_, a2_];
  fi:

end:

#------------------------------
# Invariant I1
#
# I1 = g{^a ^b} G{a b}
#
#------------------------------

macro( gr = grG_ObjDef[I1]):
gr[grC_header] := `Elasticity Invariant I1`:
gr[grC_root] := I1_:
gr[grC_rootStr] := `I1 `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2:
gr[grC_calcFnParms] := 'grG_gupup_[ gname, s1_, s2_] 
   * grG_gdndn_[ Gname, s1_, s2_]':

gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { [gname, g(up,up)] }:

#------------------------------
# Invariant I2
#
# I2 = G{^a ^b} g{a b} * I3
#
#------------------------------

macro( gr = grG_ObjDef[I2]):
gr[grC_header] := `Elasticity Invariant I2`:
gr[grC_root] := I2_:
gr[grC_rootStr] := `I2 `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum2:
gr[grC_calcFnParms] := 'grG_gdndn_[ gname, s1_, s2_] 
   * grG_gupup_[ Gname, s1_, s2_] * grG_I3_[Gname]':

gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { g(up,up), I3 }:

#------------------------------
# Invariant I3
#
# I3 = det(G)/det(g)
#
#------------------------------

macro( gr = grG_ObjDef[I3]):
gr[grC_header] := `Elasticity Invariant I3`:
gr[grC_root] := I3_:
gr[grC_rootStr] := `I3 `:
gr[grC_indexList] := []:
gr[grC_calcFn] := grF_calc_sum0:
gr[grC_calcFnParms] := 'grG_detg_[ Gname ] 
   / grG_detg_[ gname]':

gr[grC_symmetry] := grF_sym_scalar:
gr[grC_depends] := { detg, [ gname, detg] }:


save `../lib/elasticity.m`;
lprint(`Saved as elasticity.m in /lib`);


