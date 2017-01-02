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

  gr_data[join_, default] := joined:
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
    gr_data[xup_, newmetric, i] := bodycoords[i]:
    for j to dim do
       gr_data[gdndn_,newmetric,i,j] := 0;
       for a to dim do
          gr_data[gdndn_,newmetric,i,j] := gr_data[gdndn_,newmetric,i,j]
              + diff( rhs(xform[a]), bodycoords[i] ) *
                diff( rhs(xform[a]), bodycoords[j] ):
       od:
    od:
  od:
  gr_data[gdndn_, newmetric, 0, 0] := true: # calced flag
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
grG_ObjDef[strain(dn,dn)][grC_header] := `Strain Tensor`:
grG_ObjDef[strain(dn,dn)][grC_root] := straindndn_:
grG_ObjDef[strain(dn,dn)][grC_rootStr] := `strain `:
grG_ObjDef[strain(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[strain(dn,dn)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[strain(dn,dn)][grC_calcFnParms] := '(grG_gdndn_[ Gname, a1_, a2_] -
   gr_data[gdndn_, gname, a1_, a2_])/2':

grG_ObjDef[strain(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[strain(dn,dn)][grC_depends] := {}:

grG_ObjDef[strain(up,up)][grC_header] := `Strain Tensor`:
grG_ObjDef[strain(up,up)][grC_root] := strainupup_:
grG_ObjDef[strain(up,up)][grC_rootStr] := `strain `:
grG_ObjDef[strain(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[strain(up,up)][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[strain(up,up)][grC_calcFnParms] := '(grG_gupup_[ Gname, a1_, a2_] -
   gr_data[gupup_, gname, a1_, a2_])/2':
grG_ObjDef[strain(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[strain(up,up)][grC_depends] := { g(up,up), [ gname, g(up,up) ]}:

#----------------------------
# B(up,up) (we need to define both up and dn
# forms since auto raising would screw things up)
#
#  I1 g{^i ^j} - g{^i ^r} g{^i ^s} G{r s}
#
# Conservation Law for the surface
#----------------------------
grG_ObjDef[B(up,up)][grC_header] := `Elasticity Tensor B`:
grG_ObjDef[B(up,up)][grC_root] := Bupup_:
grG_ObjDef[B(up,up)][grC_rootStr] := `B `:
grG_ObjDef[B(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[B(up,up)][grC_calcFn] := grF_calc_Bupup_:
grG_ObjDef[B(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[B(up,up)][grC_depends] := { [ gname, g(up,up)], I1 }:

grF_calc_Bupup_ := proc(object, iList)

local s, a, b:

  s := gr_data[I1_,Gname] * gr_data[gupup_,gname, a1_, a2_]:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s - gr_data[gupup_,gname, a1_, a] * gr_data[gupup_,gname, a2_, b]
             * gr_data[gdndn_, Gname, a,b]:
    od:
  od:

  RETURN(s):

end:

grG_ObjDef[B(dn,dn)][grC_header] := `Elasticity Tensor B`:
grG_ObjDef[B(dn,dn)][grC_root] := Bdndn_:
grG_ObjDef[B(dn,dn)][grC_rootStr] := `B `:
grG_ObjDef[B(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[B(dn,dn)][grC_calcFn] := grF_calc_Bdndn_:
grG_ObjDef[B(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[B(dn,dn)][grC_depends] := { g(up,up), I1 }:

grF_calc_Bdndn_ := proc(object, iList)

local s, a, b:

  s := gr_data[I1_,Gname] * gr_data[gdndn_,gname, a1_, a2_]:
  for a to Ndim[gname] do
    for b to Ndim[gname] do
      s := s - gr_data[gdndn_,gname, a1_, a] * gr_data[gdndn_,gname, a2_, b]
             * gr_data[gupup_, Gname, a,b]:
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
grG_ObjDef[stress(up,up)][grC_header] := `stress tensor`:
grG_ObjDef[stress(up,up)][grC_root] := stressupup_:
grG_ObjDef[stress(up,up)][grC_rootStr] := tau:
grG_ObjDef[stress(up,up)][grC_indexList] := [up,up]:
grG_ObjDef[stress(up,up)][grC_calcFn] := grF_calc_stress:
grG_ObjDef[stress(up,up)][grC_calcFnParms] := upup_:
grG_ObjDef[stress(up,up)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[stress(up,up)][grC_depends] := { B(up,up), [gname, g(up,up)], g(up,up) }:

grG_ObjDef[stress(dn,dn)][grC_header] := `stress tensor`:
grG_ObjDef[stress(dn,dn)][grC_root] := stressdndn_:
grG_ObjDef[stress(dn,dn)][grC_rootStr] := `stress `:
grG_ObjDef[stress(dn,dn)][grC_indexList] := [dn,dn]:
grG_ObjDef[stress(dn,dn)][grC_calcFn] := grF_calc_stress:
grG_ObjDef[stress(dn,dn)][grC_calcFnParms] := dndn_:
grG_ObjDef[stress(dn,dn)][grC_symmetry] := grF_sym_sym2:
grG_ObjDef[stress(dn,dn)][grC_depends] := { B(dn,dn) }:

grF_calc_stress := proc( object, iList)

local vars, ind, i, fnVars, sex;

  sex := grG_ObjDef[ object][grC_calcFnParms]:
  ind := `union`( indets(gr_data[I1_, Gname]),
		  indets(gr_data[I2_, Gname]),
		  indets(gr_data[I3_, Gname]) ):
  vars := {seq( gr_data[xup_,gname, i], i=1..Ndim[Gname] )}:
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

grG_ObjDef[I1][grC_header] := `Elasticity Invariant I1`:
grG_ObjDef[I1][grC_root] := I1_:
grG_ObjDef[I1][grC_rootStr] := `I1 `:
grG_ObjDef[I1][grC_indexList] := []:
grG_ObjDef[I1][grC_calcFn] := grF_calc_sum2:
grG_ObjDef[I1][grC_calcFnParms] := 'grG_gupup_[ gname, s1_, s2_]
   * gr_data[gdndn_, Gname, s1_, s2_]':

grG_ObjDef[I1][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[I1][grC_depends] := { [gname, g(up,up)] }:

#------------------------------
# Invariant I2
#
# I2 = G{^a ^b} g{a b} * I3
#
#------------------------------

grG_ObjDef[I2][grC_header] := `Elasticity Invariant I2`:
grG_ObjDef[I2][grC_root] := I2_:
grG_ObjDef[I2][grC_rootStr] := `I2 `:
grG_ObjDef[I2][grC_indexList] := []:
grG_ObjDef[I2][grC_calcFn] := grF_calc_sum2:
grG_ObjDef[I2][grC_calcFnParms] := 'grG_gdndn_[ gname, s1_, s2_]
   * gr_data[gupup_, Gname, s1_, s2_] * gr_data[I3_,Gname]':

grG_ObjDef[I2][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[I2][grC_depends] := { g(up,up), I3 }:

#------------------------------
# Invariant I3
#
# I3 = det(G)/det(g)
#
#------------------------------

grG_ObjDef[I3][grC_header] := `Elasticity Invariant I3`:
grG_ObjDef[I3][grC_root] := I3_:
grG_ObjDef[I3][grC_rootStr] := `I3 `:
grG_ObjDef[I3][grC_indexList] := []:
grG_ObjDef[I3][grC_calcFn] := grF_calc_sum0:
grG_ObjDef[I3][grC_calcFnParms] := 'grG_detg_[ Gname ]
   / gr_data[detg_, gname]':

grG_ObjDef[I3][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[I3][grC_depends] := { detg, [ gname, detg] }:


save `../lib/elasticity.m`;
lprint(`Saved as elasticity.m in /lib`);


