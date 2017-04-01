#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: define.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: Long ago
#
#
# Purpose: Use routines for defining, saving and loading new objects.
#
#
# Revisions:
#
# Dec 31 1993   Add calls to allow string definitions.
# Feb 20 1994   Change to use Tensor_ internals
# Jun 20 1994   Add loadobj/saveobj
# Jun 25 1994   Support new style aux metrics
# Sep 18 1994   Code inspection changes [pm]
# Dec 14 1994   Check to see if auto-object creation can create the
#               required object [pm]
# Jun  7 1996	Added grundef and grundefine wrapper. [dp]
# Jul 29 1996	grsaveobj now saves sym-functions; also cleaned up output. [dp]
# Sep 16 1997	removed R3 type specifiers in proc headers [dp]
# Feb 14 1997   Switch convert(x,string) to convert(x,name) for R5 [dp]
# Feb 14 1997	Fixed parse of scalars on LHS of grdef expr [dp]
# Feb 24 1997	Fixed grundef() to clear calced obj, remove all indices [dp]
# Oct 18 1998	Changed savedef/loaddef to save grdef statements [dp]
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
    if grF_checkIfDefined (e, check) <> NULL then
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
        s := sprintf("grG_ObjDef[%a][%a] := \'grG_ObjDef[%a][%a]\'", e, entry, e, entry):
        printf("exec: %s\n",s);
        parse(s, 'statement');
        printf("parse done\n"):
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







