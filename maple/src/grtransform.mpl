#*********************************************************
# 
# GRTENSOR II MODULE: grtransform.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: January 29, 1995
#
# Perform coordinate transformations.
#
# Revisions:
#
# Mar 10, 1995  Change call to grF_displayMetric to grF_displaymetric [dp]
# Nov 20, 1995  Transform basis vectors along with the metric [dp]
# Apr  1, 1996  Removed automatic display of ds from grtransform [dp]
# Feb  4, 1997	Replace 0,0 checks with checkIfAssigned [dp]
#
#*********************************************************

#---------------------------------------------------------
# grtransform: Perform coordinate transformations.
#---------------------------------------------------------

grtransform := proc ()
  local a, b, c, d, ndim, newcoordlist, newcoords, oldcoords, xfdir,
        dcoord, keeper, fullpath, J, iJ, npEta, metric, b1, b2, ip, 
        gtype, oldmetric, newmetric, xform, stsig:
  global grG_xup_, grG_gdndn_, grG_Ndim, grG_calc, grG_fnCode,
	grG_metricName, grG_default_metricName, grG_sig_:

  if nargs<3 or nargs>4 then
    ERROR (`Wrong number of arguments.`):
  fi:

  oldmetric := args[1]:
  newmetric := args[2]:
  xform := args[3]:
  ndim := Ndim[oldmetric]:

  if nargs = 4 then
    if not type ( args[4], integer ) then
      ERROR ( `The signature must be specified as an integer.` ):
    elif abs(args[4]) > ndim then
      ERROR ( `|signature| must be less than the number of dimensions.` ):
    else
      stsig := args[4]:
    fi:
  elif assigned ( grG_sig_[oldmetric] ) then
    stsig := grG_sig_[oldmetric]:
  else
    stsig := NULL:
  fi:

  grF_check_xform_errors (oldmetric, newmetric, xform, ndim):
  oldcoords := grF_set_old_coords (oldmetric, ndim):
  newcoords := grF_find_new_coords (oldmetric, oldcoords, xform, ndim):
  xfdir := newcoords[0]:

  if xfdir=1 then 
    dcoord := oldcoords:
  else
    dcoord := newcoords:
  fi:
  J := linalg[matrix](ndim,ndim):
  for a to ndim do
    for b to ndim do
      J[a,b] := simplify ( diff(rhs(xform[a]),dcoord[b]), hypergeom ):
    od:
  od:
  if xfdir=1 then
    iJ := eval (J):
    J := linalg[inverse] (J):
  else
    iJ := linalg[inverse] (J):
  fi:
  grG_Ndim[newmetric] := ndim:
  Ndim||newmetric := ndim:

  gtype := grG_g:
  if grF_checkIfAssigned ( eta(bup,bup) ) then
    if ndim = 4 then
      gtype := grG_np:
      npEta := array ( 1..4, 1..4, [[0,1,0,0],[1,0,0,0],[0,0,0,-1],[0,0,-1,0]] ):
      for a to 4 while gtype<>grG_basis do
        for b to 4 while gtype<>grG_basis do
          if npEta[a,b] <> grG_etabupbup_[oldmetric,a,b] then
            gtype := grG_basis:
          fi:
        od:
      od:
    else
      gtype := grG_basis:
    fi:
  fi:

  for a to ndim do
    grG_xup_[newmetric,a] := newcoords[a]:
  od:
  grF_assignedFlag ( x(up), set, newmetric ):

  if grF_checkIfAssigned ( e(bdn,up) ) then
    for a to ndim do
      for b to ndim do
        b1[a,b] := 0:
        for c to ndim do
          b1[a,b] := b1[a,b] + grG_ebdnup_[oldmetric,a,c]*iJ[b,c]:
        od:
      od:
    od:
    grF_initbasisup ( ndim, b1, newmetric, gtype ):
  fi:

  if grF_checkIfAssigned ( e(bdn,dn) ) then
    for a to ndim do
      for b to ndim do
        b2[a,b] := 0:
        for c to ndim do
          b2[a,b] := b2[a,b] + grG_ebdndn_[oldmetric,a,c]*J[c,b]:
        od:
      od:
    od:
    grF_initbasisdn ( ndim, b2, newmetric, gtype ):
  fi:

  if grF_checkIfAssigned ( e(bdn,dn) ) or
    grF_checkIfAssigned ( e(bdn,up) ) then
    for a to 4 do
      for b to 4 do
        ip[a,b] := grG_etabupbup_[oldmetric,a,b]:
      od:
    od:
    grF_initip ( ndim, ip, newmetric ):
  fi:

  if grF_checkIfAssigned ( g(dn,dn) ) then
    for a to ndim do 
      for b from a to ndim do
        metric[b,a] := metric[a,b]:
        metric[a,b] := 0:
        for c to ndim do
          for d to ndim do
            metric[a,b] := metric[a,b] + J[c,a]*grG_gdndn_[oldmetric,c,d]*J[d,b]:
          od:
        od:
      od:
    od:
    grG_default_metricName := newmetric:
    grG_metricName := newmetric:
    grF_initg ( ndim, metric, newmetric ):
  fi:

  grG_sig_[newmetric] := stsig:

  grF_initMetric ( newmetric ):
  printf ("The new default metric is: %a\n", newmetric):
end:

#---------------------------------------------------------
# check_xform_errors: Check for errors in input parameters.
#---------------------------------------------------------
grF_check_xform_errors := proc (oldmetric, newmetric, xform, ndim)
  if not member ( oldmetric, grG_metricSet ) then
    ERROR ( `Metric name has not been defined:`, oldmetric ):
  fi:
  if not type ( newmetric, name ) then
    ERROR ( `New metric name must be of type NAME`):
  fi:
  if member ( newmetric, grG_metricSet ) then
    ERROR ( `Metric name has already been used: `, newmetric ):
  fi:
  if not type ( xform, list ) then
    ERROR ( `Coordinate transformation must be specified as a LIST` ):
  fi:
  if ndim <> nops(xform) then
    ERROR ( `Number of dimensions of transformation does not match that of the metric.` ):
  fi:
end:

#---------------------------------------------------------
# set_old_coords: Build a list of existing coordinates which
#		are to be transformed.
#---------------------------------------------------------
grF_set_old_coords := proc (oldmetric, ndim)
local a, oldcoords:
  for a to ndim do
    oldcoords[a] := grG_xup_[oldmetric,a]
  od:
  RETURN (eval(oldcoords)):
end:

#----------------------------------------------------------
# find_new_coords: Build a list of new coordinates.
#---------------------------------------------------------
grF_find_new_coords := proc (oldmetric, oldcoords, xform, ndim)
local a, b, c, funcname, funcnames, funcnamev, fargname, fargnames,
  fargnamev:
  funcnames := {}:
  fargnames := {}:
  c := 0:
  for b to ndim do
    funcname := op(0, lhs(xform[b])):
    funcnames := funcnames union {funcname}:
    funcnamev[b] := funcname:
    for a in lhs(xform[b]) do
      fargname := a:
      if not member(fargname, fargnames) then
        fargnames := fargnames union {fargname}:
        c := c + 1:
        fargnamev[c] := fargname:
      fi:
    od:
  od:
  if c <> ndim then
    ERROR(`Dimension is`, ndim, 
      `but number of distinct arguments to transformation is`,c):
  fi:
  for a to ndim do
    if not member(oldcoords[a], funcnames) then
      if a <> 1 then
        ERROR(`Coordinate`, oldcoords[a-1],
          `is a function name but`, oldcoords[a],
          `is not.`):
      fi:
      for b to ndim do
        if not member(oldcoords[b], fargnames) then
          ERROR(`Coordinate`, oldcoords[a], 
            `is not a function name and`, oldcoords[b], 
            `is not an argument.`):
        fi:
      od:
      funcnamev[0] := 1:
      RETURN(eval(funcnamev)):
    fi:
  od:
  for a to ndim do
    if funcnamev[a] <> oldcoords[a] then
      ERROR(`Coordinate`, oldcoords[a], 
        `does not match function name`, funcnamev[a]):
    fi:
  od:
  fargnamev[0] := -1:
  RETURN (eval(fargnamev)):
end:

