

#----------------------------
# e3(bdn,up)
#
# This object is an anomoly in GRTensorII, since
# the basis index ranges from 1 to 3 and the tensor
# index from 1 to 4.
#
# This causes a host of problems, since we cannot let
# auto index raising etc. loose on this object.
#
#----------------------------
grG_ObjDef[e3(bdn,up)][grC_header] := `e3(bdn,up)`:
grG_ObjDef[e3(bdn,up)][grC_root] := e3bdnup_:
grG_ObjDef[e3(bdn,up)][grC_rootStr] := `e3bdnup `:
grG_ObjDef[e3(bdn,up)][grC_indexList] := [bdn,up]:
grG_ObjDef[e3(bdn,up)][grC_calcFn] := grF_calc_e3bdnup:
grG_ObjDef[e3(bdn,up)][grC_symmetry] := grF_sym_asym2:
grG_ObjDef[e3(bdn,up)][grC_depends] := {}:

grF_calc_e3bdnup := proc(object, iList)
global gr_data, grG_metricName
local a, s, partner, gname;

  gname := grG_metricName;

  partner := gr_data[partner_,gname];

  s := 0;
  for a to Ndim[gname]+1 do
    s := s + gr_data[xform_, partner, a]



end:
