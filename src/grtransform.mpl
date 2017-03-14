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
  global Ndim, grG_calc, grG_fnCode, gr_data,
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
  # xfdir => xform direction 
  xfdir := newcoords[0]:

  if xfdir=1 then 
    #printf("transform is x_new(x_old)\n"):
    dcoord := oldcoords:
  else
    #printf("transform is x_old(x_new)\n"):
    dcoord := newcoords:
  fi:
  J := linalg[matrix](ndim,ndim):
  for a to ndim do
    for b to ndim do
      J[a,b] := simplify ( diff(rhs(xform[a]),dcoord[b]), hypergeom ):
#      if J[a,b] <> 0 then
#        printf("Jacobian[%d,%d]: %a\n", a, b, J[a,b]);
#      fi:
    od:
  od:

  if xfdir=1 then
    iJ := eval (J):
    J := linalg[inverse] (J):
  else
    iJ := linalg[inverse] (J):
  fi:
  grG_Ndim[newmetric] := ndim:
  Ndim[newmetric] := ndim:

  gtype := grG_g:
  if grF_checkIfAssigned ( eta(bup,bup) ) then
    if ndim = 4 then
      gtype := grG_np:
      npEta := array ( 1..4, 1..4, [[0,1,0,0],[1,0,0,0],[0,0,0,-1],[0,0,-1,0]] ):
      for a to 4 while gtype<>grG_basis do
        for b to 4 while gtype<>grG_basis do
          if npEta[a,b] <> grG[etabupbup_,oldmetric,a,b] then
            gtype := grG_basis:
          fi:
        od:
      od:
    else
      gtype := grG_basis:
    fi:
  fi:

  for a to ndim do
    gr_data[xup_, newmetric,a] := newcoords[a]:
  od:
  grF_assignedFlag ( x(up), set, newmetric ):

  if grF_checkIfAssigned ( e(bdn,up) ) then
    for a to ndim do
      for b to ndim do
        b1[a,b] := 0:
        for c to ndim do
          b1[a,b] := b1[a,b] + gr_data[ebdnup_,oldmetric,a,c]*iJ[b,c]:
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
          b2[a,b] := b2[a,b] + gr_data[ebdndn_,oldmetric,a,c]*J[c,b]:
        od:
      od:
    od:
    grF_initbasisdn ( ndim, b2, newmetric, gtype ):
  fi:

  if grF_checkIfAssigned ( e(bdn,dn) ) or
    grF_checkIfAssigned ( e(bdn,up) ) then
    for a to 4 do
      for b to 4 do
        ip[a,b] := gr_data[etabupbup_,oldmetric,a,b]:
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
            metric[a,b] := metric[a,b] + J[c,a]*gr_data[gdndn_,oldmetric,c,d]*J[d,b]:
          od:
        od:
      od:
    od:
    for a to ndim do 
      for b from a to ndim do
        metric[a,b] := simplify(metric[a,b]):
      od:
    od:
    grG_default_metricName := newmetric:
    grG_metricName := newmetric:
    grF_initg ( ndim, metric, newmetric ):
  fi:

  grG_sig_[newmetric] := stsig:

  grF_initMetric ( newmetric ):
  printf ("The new default metric is: %a\n", newmetric):
  grdisplay(x(up));
  grdisplay(ds);
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
global gr_data:
local a, oldcoords:
  for a to ndim do
    oldcoords[a] := gr_data[xup_,oldmetric,a]
  od:
  RETURN (eval(oldcoords)):
end:

#----------------------------------------------------------
# find_new_coords: Build a list of new coordinates.
#
# Returns:
#  element[0] = +1  functions give new coords
#               -1  function give old coords
#---------------------------------------------------------
grF_find_new_coords := proc (oldmetric, oldcoords, xform, ndim)
local a, b, c, cname, funcname, funcnames, funcnamev, fargname, fargnames,
  fargnamev:
  funcnames := {}:
  fargnames := {}:
  c := 0:
  #
  # scan LHS of xform list to get function names
  # these will be either new or old coords
  #
  for b to ndim do
    if type(lhs(xform[b]), name) and lhs(xform[b]) = rhs(xform[b]) then
      cname := lhs(xform[b]):
      # printf("identity for %a\n", cname):
      # allow e.g. theta=theta
      # add to both new and old coord list
      funcnames := funcnames union {cname}:
      funcnamev[b] := cname:
      if not member(cname, fargnames) then
        fargnames := fargnames union {cname}:
        c := c + 1:
        fargnamev[c] := cname:
      fi:
    else
      # e.g. u(r,t) = <expression>
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
    fi:
  od:

  # dimension check
  if c <> ndim then
    ERROR(`Dimension is`, ndim, 
      `but number of distinct arguments to transformation is`,c):
  fi:

  # Are function names new coords?
  oldcoord_set := {ops(oldcoords)}:
  if nops(funcnames minus oldcoord_set) > 0 then
    # use function names as new coords
    funcnamev[0] := 1:
    RETURN (eval(funcnamev)):
  else
    # use function args as new coords
    fargnamev[0] := -1:
    RETURN (eval(fargnamev)):
  fi:


end:

