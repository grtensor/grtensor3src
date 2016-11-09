#==============================================================================
#
# normalize.mpl - normalize a vector field.
#
# (C) 1992-1994 Peter Musgrave, Denis Pollney, Kayll Lake
#
# File Created By: Denis Pollney
#            Date: 5 June 1996
#
# Revisions
# June  5, 1996	Created from grvector library. [dp]
# Aug  18, 1999 Switched readstat and grF_my_readstat to grF_readstat [dp]
# Aug  20, 1999 Changed use of " to ` for R4 compatibility [dp]
#==============================================================================

#------------------------------------------------------------------------------
# grnormalize: normalize a timelike or spacelike vector field.
#------------------------------------------------------------------------------
grnormalize := proc( v, vnorm )
local	vRoot, a, b, localv, yorn, gname, ndim, mag, gidx:
global	gr_data:

  if nops(v) <> 1 then 
    ERROR ( `The vector must be a 1-index object.` ):
  fi: 

  gname := grG_metricName:
  ndim  := Ndim[gname]:
  vRoot := grG_ObjDef[v][grC_root]:

  if not grF_checkIfAssigned(v) then
    ERROR (`The vector has not been calculated yet.`):
  fi:

  if op(v) = up then
    if not grF_checkIfAssigned(g(dn,dn)) then
      grcalc ( g(dn,dn) ):
    fi:
    gidx := `gdndn_`:
  elif op(v) = dn then
    if not grF_checkIfAssigned(g(up,up)) then
      grcalc ( g(up,up) ):
    fi:
    gidx := `gupup_`:
  else
    ERROR ( `The vector must have indices of the form 'up' or 'dn'.` ):
  fi:

  mag := 0:
  for a to ndim do
    for b to ndim do
      mag := mag + gr_data[gidx,gname,a,b]*gr_data[vRoot,gname,a]*
                   gr_data[vRoot,gname,b]:
    od:
  od:
  mag := simplify ( sqrt ( mag*vnorm ), sqrt, symbolic ):

  if mag <> 0 then
    for a to Ndim[gname] do
      localv[a] := grG_||vRoot[gname, a]/mag:
    od:
  else
    ERROR ( `Vector `||v||` is null.` ):
  fi:
  print ( `The components of the normalized vector are` ):
  for a to Ndim[gname] do
    print ( op(0,v)^gr_data[xup_,gname,a] = localv[a] ):
  od:
  gr_data[vnorm_,gname,op(0,v)] := vnorm:
  
  printf ("Do you wish to overwrite %a with the normalized vector? (1=yes)\n", v):
  yorn := grF_readstat (``, [], `grnormalize`):

  if yorn = 1 then
    for a to Ndim[gname] do
      gr_data[vRoot,gname,a] := localv[a]:
    od:
    printf ( "%a has been overwritten.\n", v):
  fi:
end:

#==============================================================================
