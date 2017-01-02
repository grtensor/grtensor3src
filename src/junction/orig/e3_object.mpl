
macro( gname = grG_metricName);

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
macro( gr = grG_ObjDef[e3(bdn,up)]):
gr[grC_header] := `e3(bdn,up)`:
gr[grC_root] := e3bdnup_:
gr[grC_rootStr] := `e3bdnup `:
gr[grC_indexList] := [bdn,up]:
gr[grC_calcFn] := grF_calc_e3bdnup:
gr[grC_symmetry] := grF_sym_asym2:
gr[grC_depends] := {}:

grF_calc_e3bdnup := proc(object, iList)
local a, s, partner;

  partner := grG_partner_[gname];
 
  s := 0;
  for a to Ndim[gname]+1 do
    s := s + grG_xform_[ partner, a]



end:
