#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR III MODULE: undef.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
#
#**********************************************************

# define used in debugging
#$define DEBUG option trace;
$define DEBUG 

#----------------------------------------------------------
# grundef - set object definition to null
#----------------------------------------------------------
grundef := proc(object)
DEBUG
global  grG_ObjDef, gr_data, grG_rootSet;
local a, b, c, per_index, index, objects:
  if grF_checkIfDefined (object, check) <> NULL then
    ERROR(`This object is not defined`);
  fi:
  #
  # create a list of all index permutations of this object 
  # - need to delete them all 
  # TODO: if any derivitive extensions exist, those have not
  # been deleted
  #
  if nops(object) <> 0 then
    # build a per-index location list of each possible permuation
    for a to nops(object) do
      if member(op(a,object), {up,dn}) then
        per_index[a] := [up,dn];
      elif member(op(a,object), {bup,bdn}) then
        per_index[a] := [bup,bdn];
      elif member(op(a,object), {cup,cdn}) then
        per_index[a] := [cup,cdn];
      fi:
    od:
    # build a list of every perm: eg: gdndn_ gdnup_, gupdn_ ...
    new_list := [[]]:
    for b to nops(object) do
      list := new_list;
      new_list := [];
      for e in list do
        for c in per_index[b] do
          new_list := [op(new_list), [op(e), c]]:
        od:
      od:
    od:
    list := new_list:
    new_list := []:
    for a in list do
      new_list := [op(new_list), op(0,object)(op(a))]:
    od:

  else
    # object is a scalar
    objects := object:
  fi:

  #
  # clear each combination of the object in all metrics
  #
  for e in new_list do
    if grF_checkIfAssigned (e) then
      grclear(e):
    fi:
  od:
  #
  # remove the definition of each combination of indices
  #
  for e in new_list do
    printf("object %a\n", e):
    if assigned(grG_ObjDef[e]) then
      for a in indices(grG_ObjDef[e]) do
        # cannot use unassign (requires iname to be table, rtable or array)
        entry := op(a):
        # s := sprintf("grG_ObjDef[%a][%a] := `grG_ObjDef[%a][%a]`", e, entry, e, entry):
        s := sprintf("grG_ObjDef[%a][%a] := evaln(grG_ObjDef[%a][%a]);", e, entry, e, entry):
        printf("exec: %s\n",s);
        parse(s, 'statement');
        printf("parse done\n"):
        printf("check assigned %a: %a\n", grG_ObjDef[e][entry], assigned(grG_ObjDef[e][entry])):
      od:
      printf("Definition for %a has been removed.\n", e);
    fi:
  od:
  baseObj := cat(grG_,op(0,object),"_", nops(object)):
  grG_rootSet := grG_rootSet minus {baseObj}:

  printf("done\n");

end proc:


grundefine := proc(object)
  grundef(object):
end:

$undef DEBUG







