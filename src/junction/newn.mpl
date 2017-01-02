#----------------------------
# n(dn)
#
# this object may be entered directly,
# determined from n(up) or calculated
# by refering to surface.
#----------------------------
grG_ObjDef[n(dn)][grC_header] := `Normal Vector`:
grG_ObjDef[n(dn)][grC_root] := ndn_:
grG_ObjDef[n(dn)][grC_rootStr] := `n `:
grG_ObjDef[n(dn)][grC_indexList] := [dn]:
grG_ObjDef[n(dn)][grC_preCalcFn] := grF_calc_ndn: # preCalc since we need to normalize
grG_ObjDef[n(dn)][grC_symmetry] := grF_sym_vector:
grG_ObjDef[n(dn)][grC_depends] := {g(up,up),surface, nsign}:

grF_calc_ndn := proc( object, iList)

local a,b,s, coordList:
global gr_data, Ndim, grG_metricName:
local gname;

  gname := grG_metricName;

  for a to Ndim[gname] do
    gr_data[ndn_,gname,a] := subs( diff=jdiff,
        diff( gr_data[surface_,gname], gr_data[xup_,gname,a])):
  od:
  #
  # want to normalize, but ensure we don't take sqrt(-1)
  # so multiply normalization factor by ntype
  #
  for a to Ndim[gname] do
    gr_data[ndn_,gname,a] :=  gr_data[nsign_,gname]*
           gr_data[ndn_,gname,a];
  od:

end:

