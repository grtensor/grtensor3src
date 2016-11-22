#*********************************************************-*-Maple-*-**
# 
# GRTENSOR II MODULE: grtetrad.mpl
#
# (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
# File Created By: Denis Pollney
#            Date: August 30, 1994
#
# Given a 4-d metric, create a null tetrad. 
#
# 27 Sep 1994	Fix a plethora of bugs [dp]
# 28 Sep 1994	Add npsave [dp]
# 29 Sep 1994	Rename gr... to np... [dp]
# 11 Dec 1994   Use convert( , hostfile) for fullpath [pm]
#  7 Jun 1996	Remove npsave (superceded by grsaveg()) [dp]
#  3 Feb 1997	Clean up code, allow complex coordinates [dp]
#  4 Feb 1997	Change 0,0 checks to grF_checkIfAssigned [dp]
# 18 Aug 1999   Switched readstat and grF_my_readstat to grF_readstat [dp]
# 20 Aug 1999   Changed use of " to ` for R4 compatibility [dp]
#
#*********************************************************

#---------------------------------------------------------
#
# nptetrad: Create a null tetrad from a metric.
#
#---------------------------------------------------------

nptetrad := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

global	grG_metricName, gr_data, grG_preSeq, grG_postSeq, 
	grG_simpHow, grG_lastObjectSeq, grG_calc, grG_fnCode:
local	gname, ndim, lnspace, sig, a, b, G, bv, yorn, basis, ip:

gname := grG_default_metricName:
if Ndim[gname] <> 4 then
  ERROR ( `Dimension of metric <> 4.` ):
else
  ndim := Ndim[gname]:
fi:

lnspace := []:
if nargs > 0 then
  if type ( args[1], list ) then
    lnspace := args[1]:
  fi:
fi:

if grF_checkIfAssigned ( e(bdn,dn) ) or grF_checkIfAssigned ( e(bdn,up) ) then
  yorn := grF_input ( 
    `Basis vectors already exist for this spacetime.\n Overwrite? (1=yes, other=no [default]):`, 0, `nptetrad` ):
  if yorn = 1 or yorn = y or yorn = yes then
    if grF_checkIfAssigned ( e(bdn,dn) ) then
      grclear ( e(bdn,dn) ):
    fi:
    if grF_checkIfAssigned ( e(bdn,up) ) then
      grclear ( e(bdn,up) ):
    fi:
  else
    ERROR ( `Exit requested by user.` ):
  fi:
fi:

grF_checkSig ( gname, ndim ):
lnspace := grF_checklnspace ( lnspace, gname, ndim ):

grF_simpDecode ( grOptionDefaultSimp, gname ):

G := evalm ( grarray ( g(dn,dn) ) ):
basis := grF_createBasis ( G, 4, lnspace ):
bv := basis[1]:
ip := basis[2]:

for a to 4 do
  for b from a to 4 do
    gr_data[etabupbup_,gname,b,a] := gr_data[etabupbup_,gname,a,b]:
    gr_data[etabupbup_,gname,a,b] := simplify ( ip[a,b] ):
  od:
  for b to 4 do
    gr_data[ebdndn_,gname,a,b] := grG_simpHow ( grG_preSeq, bv[a,b], grG_postSeq):
  od:
od:
grF_assignedFlag ( e(bdn,dn), set ):
grF_assignedFlag ( eta(bup,bup), set ):

grG_lastObjectSeq := e(bdn,dn):

for a to 4 do
  gr_data[NPldn_,gname,a] := gr_data[ebdndn_,gname,1,a]:
  gr_data[NPndn_,gname,a] := gr_data[ebdndn_,gname,2,a]:
  gr_data[NPmdn_,gname,a] := gr_data[ebdndn_,gname,3,a]:
  gr_data[NPmbardn_,gname,a] := gr_data[ebdndn_,gname,4,a]:
od:
grF_assignedFlag ( NPl(dn), set ):
grF_assignedFlag ( NPn(dn), set ):
grF_assignedFlag ( NPm(dn), set ):
grF_assignedFlag ( NPmbar(dn), set ):

grdisplay ( eta(bup,bup), nullt(dn) ):

printf ( "The null tetrad has been stored as e(bdn,dn).\n" ):
end:

#------------------------------------------------------------------------------
#
# checkSig: Ask for the metric signature
#
#------------------------------------------------------------------------------

grF_checkSig := proc ( gname, ndim )
local sig, yorn, prompt:
global grG_sig_:

if not assigned ( grG_sig_[gname] ) then
  prompt := sprintf ( `The metric signature has not been assigned.\n` ):
  prompt := cat(prompt, `Please enter the metric signature as an integer: \n`):
  sig := grF_input ( prompt, [], "nptetrad" ):
  if not type ( sig, integer ) then
    ERROR ( `The signature must be specified as an integer.` ):
  else
    grG_sig_[gname] := sig:
  fi:
fi:

if grG_sig_[gname] = 2 then
  s := sprintf ( `The metric signature of the %s spacetime is +2.\n`, gname, 
    grG_sig_[gname] ):
  s := cat( sprintf (
    `In order to create an NP-tetrad, the signature of g(dn,dn) will be changed to -2.\n` )):
  s := cat(s, sprintf(`Continue? (1=yes [default], other=no) :`)):
  yorn := grF_input ( s, 1, nptetrad ):
  if yorn = 1 or yorn = y or yorn = yes then
    antisig ( gname ):
  else
    ERROR ( `Exit requested by user.` ):
  fi:
fi:

if assigned ( grG_sig_[gname] ) then
  if not grG_sig_[gname] = -2 then
    ERROR ( 
      `The spacetime signature must be -2 in order to use the NP formalism.` ):
  fi:
fi:
end:

#------------------------------------------------------------------------------
#
# antisig: Reverse the signature of the metric.
#
#------------------------------------------------------------------------------

antisig := proc ( )
local	a, b, ndim, gname:
global	grG_sig_, grG_calc, grG_fnCode, grG_metricName, gr_data:

if nargs = 1 then
  gname := args[1]:
else
  gname := grG_metricName:
fi:

ndim := Ndim[gname]:
for a to ndim do
  for b from a to ndim do
    gr_data[gdndn_,gname,a,b] := -gr_data[gdndn_,gname,a,b]:
  od:
od:
grG_ds_[gname] := -grG_ds_[gname]:
grG_sig_[gname] := -grG_sig_[gname]:
printf ( `The signature of the %s spacetime is now %d.\n`, gname,
  grG_sig_[gname] ):

if grF_checkIfAssigned ( g(up,up) ) then
  for a to ndim do
    for b from a to ndim do
      gr_data[gupup_,gname,a,b] := -gr_data[gupup_,gname,a,b]:
    od:
  od:
fi:

NULL:
end:

#------------------------------------------------------------------------------
#
# checklnspace: check the input of the ln-subspace.
#
#------------------------------------------------------------------------------

grF_checklnspace := proc ( lnspace, gname, ndim )
local a, b, idxnbr, found, localln:
global gr_data:

if lnspace <> [] and nops ( lnspace ) <> 2 then
  printf("lnspace list=%a\n", lnspace);
  ERROR ( 
    `The l-n subspace must be specified as a 2-component list, eg. [t,r].`
  ):
fi:

if lnspace <> [] then  
  idxnbr := NULL:
  for a to 2 do
    found := false:
    for b to 4 while not found do
      if lnspace[a] = gr_data[xup_,gname,b] then
        idxnbr := idxnbr,b:
        found := true:
      fi:
    od:
  od:
  if nops ( [idxnbr] ) = 2 then
    localln := [idxnbr]:
  else
    localln := lnspace:
  fi:
  if not nops ( localln ) = 2 or
    not member ( localln[1], {1,2,3,4} )
    or not member ( localln[2], {1,2,3,4} )
    or localln[1] = localln[2] then
      printf("lnspace list=%a\n", lnspace);
      ERROR ( 
      `The lnspace argument should be specified as a list of two coordinate names, eg. [t,r].` ):
  fi:
else
  localln := []:
fi:

RETURN ( localln ):
end:

#---------------------------------------------------------
#
# nprotate: Apply a rotation to a null tetrad.
#
#---------------------------------------------------------

nprotate := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

global	grG_metricName:
local	gname, rclass:

gname := grG_metricName:
if not grF_checkIfAssigned ( e(bdn,up) ) then
  ERROR ( `A tetrad must first be defined.` ):
fi:

if not member ( args[1], { I, II, III } ) then
  ERROR ( `Rotation class must be of type I, II or III.` ):
fi:

rclass := args[1]:

if rclass = I then
  grF_rotateI ( gname, 1, args[2], args[3] ):
elif rclass = II then
  grF_rotateI ( gname, 2, args[2], args[3] ):
else
  grF_rotateIII( gname, args[2], args[3] ):
fi:

if grF_checkIfAssigned ( e(bdn,dn) ) then
  grclear ( e(bdn,dn) ):
fi:

printf ("Rotated tetrad stored as e(bdn,up).\n"):
end:
   
#---------------------------------------------------------
#
# grF_createBasis: Given a timelike vector, construct
#                  three other independent vectors.
#
#---------------------------------------------------------

grF_createBasis := proc( G, ndim, lnspace )
local nullip, iG, obv, cset, complexCoords, nullCoords, a, ovlist, ip,
  vlist, found, vseq, bv, v, new12, nv, new34, vx3, vx4, f1, f2, c1, c2,
  b, firstbv, firstip:
global gr_data:


nullip := linalg[matrix](4,4,[[0,1,0,0],[1,0,0,0],[0,0,0,-1],[0,0,-1,0]]):

if grF_checkIfAssigned ( g(up,up) ) then
  iG := evalm ( grarray ( g(up,up) ) ):
else
  iG := linalg[inverse](G):
fi:
obv := evalm ( G ):

if assigned ( complexSet_ ) then
  cset := complexSet_ union createConjSet ( complexSet_ ):
else
  cset := {}:
fi:

complexCoords := false:
nullCoords := {}:
for a to 4 do
  if member ( gr_data[xup_,grG_metricName,a], cset ) then
      complexCoords := true:
  elif obv[a,a] = 0 then
    nullCoords := nullCoords union { a }:
  fi:
od:

if nops(lnspace)=2 then
  ovlist := [ op(lnspace), op ({1,2,3,4} minus {op(lnspace)}) ]:
else
  ip := evalm ( obv ):
  ovlist := reorder ( ip, ndim ):
fi:
vlist := ovlist:

found := false:
while not found do
  vseq := NULL:
  for a to nops ( vlist ) do
    vseq := vseq, convert ( linalg[col] ( obv, vlist[a] ), list ):
  od:
  bv := linalg[transpose] ( linalg[matrix] ( ndim, ndim, [vseq] ) ):

  if not assigned ( ip ) or vlist <> [1,2,3,4] then
    ip := evalm ( linalg[transpose] ( bv ) &* iG &* bv ):
  fi:
  for a to ndim do
    v[a] := linalg[col] ( bv, a ):
  od:

  new12 := grF_new12Frame ( 1, 2, v[1], v[2], ip, iG ):
  nv[1] := new12[1]:
  nv[2] := new12[2]:
  
  if not complexCoords then
    vx3 := evalm ( iG &* v[3] ):
    vx4 := evalm ( iG &* v[4] ):
    f1 := evalm ( linalg[transpose] ( nv[1] ) &* vx3 ):
    f2 := evalm ( linalg[transpose] ( nv[2] ) &* vx3 ):
    v[3] := evalm ( v[3] - f2*nv[1] - f1*nv[2] ):
    f1 := evalm ( linalg[transpose] ( nv[1] ) &* vx4 ):
    f2 := evalm ( linalg[transpose] ( nv[2] ) &* vx4 ):
    v[4] := evalm ( v[4] - f2*nv[1] - f1*nv[2] ):
    ip[3,3] := expand(evalm ( linalg[transpose] ( v[3] ) &* iG &* v[3] )):
    ip[4,4] := expand(evalm ( linalg[transpose] ( v[4] ) &* iG &* v[4] )):
    ip[3,4] := expand(evalm ( linalg[transpose] ( v[3] ) &* iG &* v[4] )):
    ip[4,3] := ip[3,4]:
    if ip[3,4]<>0 then
      if ip[3,3]<>0 then
        v[4] := evalm ( v[4] - ip[3,4]/ip[3,3]*v[3] ):
      elif ip[4,4]<>0 then
        v[3] := evalm ( v[3] - ip[3,4]/ip[4,4]*v[4] ):
      fi:
      ip[3,3] := expand(evalm ( linalg[transpose] ( v[3] ) &* iG &* v[3] )):
      ip[4,4] := expand(evalm ( linalg[transpose] ( v[4] ) &* iG &* v[4] )):
      ip[3,4] := evalm ( linalg[transpose] ( v[3] ) &* iG &* v[4] ):
      ip[4,3] := ip[3,4]:
    fi:
  fi:
    
  if ip[3,3]<>0 and ip[4,4]<>0 then
    c1 := I/radsimp ( sqrt(-2*ip[3,3]) ):
    c2 := 1/radsimp ( sqrt(-2*ip[4,4]) ):
    nv[3] := evalm ( c1*v[3] + c2*v[4] ):
    nv[4] := evalm ( conj(c1)*v[3] + conj(c2)*v[4] ):
  else
    c1 := 1/sqrt(-ip[3,4]):
    c2 := c1:
    nv[3] := evalm ( c1*v[3] ):
    nv[4] := evalm ( conj(c1)*v[4] ): 
  fi:
 
  vseq := NULL:
  for a to 4 do
    vseq := vseq, convert ( nv[a], list ):
  od:
  bv := linalg[matrix] ( ndim, ndim, [vseq] ):
  ip := evalm ( bv &* iG &* linalg[transpose](bv) ):
  
  found := true:  
  if not complexCoords and nops ( nullCoords ) < 2 then
    for a to 4 while found do
      for b from a to 4 while found do
        if  simplify ( ip[a,b] - nullip[a,b] ) <> 0 then
          found := false:
        fi:
      od:
    od:
  fi:
  
  if found = false then
    if vlist = ovlist then
      firstbv := evalm ( bv ):
      firstip := evalm ( ip ):
    fi:
    
    if nops ( nullCoords ) = 0 then
      vlist := [vlist[4],vlist[1],vlist[2],vlist[3]]:
    elif nops ( nullCoords ) = 1 then
      vlist := [op(nullCoords),vlist[4],vlist[2],vlist[3]]:
    else
      vlist := [vlist[4],vlist[1],vlist[2],vlist[3]]:
    fi:
  
    if vlist = ovlist then
      found := true:
      bv := evalm ( firstbv ):
      ip := evalm ( firstip ):
      printf ( `*** Warning: Could not form a proper NP-tetrad. Check the values of e(bdn,dn), eta(bdn,bdn) for errors.\n` ):
    fi:
  fi:
od:
RETURN ( [eval(bv),eval(ip)] ):
end;

#------------------------------------------------------------------------------
# new12Frame
#------------------------------------------------------------------------------
grF_new12Frame := proc ( i1, i2, v1, v2, ip, iG )
local c1, c2, c3, c4, disc, t1, t2, nv1, nv2, f1:

  if ( ip[i1,i1] = 0 or ip[i2,i2] = 0 ) and ip[i1,i2] <> 0 then
    c1 := -(1/2)*ip[i1,i1]/ip[i1,i2]:
    c2 := 1:
    c3 := 1/ip[i1,i2]:
    c4 := -(1/2)*ip[i2,i2]/ip[i1,i2]:
  else
    disc :=  simplify ( ip[i1,i2]^2 - ip[i1,i1]*ip[i2,i2] ):
    if disc <> 0 then
      t1 := ip[i1,i2]/ip[i2,i2]:
      t2 := radsimp ( sqrt ( disc ) /ip[i2,i2] ):
      c1 := -t1 + t2:
      c2 := -t1 - t2:
      c3 := ip[i2,i2]/(2*disc):
      c4 := 1:
    else
      c1 := 0:
      c2 := 1:
      c3 := 1:
      c4 := 0:
    fi:
  fi:
  nv1 := evalm ( v1 + c1*v2 ):
  nv2 := evalm ( c3*c4*v1 + c3*c2*v2 ):
  f1 := simplify ( evalm ( linalg[transpose](nv1) &* iG &* nv2 ) ):
  if ( i1 = 1 and f1 = -1 ) then
    nv2 := evalm ( -1*nv2 ):
  fi:
  RETURN ( [eval(nv1),eval(nv2)] ):
end:

#------------------------------------------------------------------------------
#
# reorder: put vectors in an optimal order for creating a null tetrad.
#
#------------------------------------------------------------------------------

reorder := proc ( ip, ndim )
local a, cList, nList, idxSet, idxList, unusedSeq:

# list complex coordinates if there are any.
#
if assigned ( complexSet_ ) then
  cList := grF_getComplexCoords ( ndim ):
else
  cList := []:
fi:

# find null coordinates that are not already included in the complex list.
#
nList := [ op( {op(grF_getNullCoords ( ip, ndim ))} minus {op(cList)} ) ]:

idxSet := {op(cList)} union {op(nList)}:

# if there are only 0 or 1 null vectors found, reorder them
# according to the number of zeros in each column (for efficiency).
#
if nops ( idxSet ) = 0 or nops ( idxSet ) = 1 then
  idxList := grF_genReorderVectors ( ip, ndim, idxSet ):
else
  idxList := []:
fi:

idxSet := idxSet union {op(idxList)}:

unusedSeq := NULL:
for a to ndim do
  if not member ( a, idxSet ) then
    unusedSeq := unusedSeq, a:
  fi:
od:

RETURN ( [ op(nList), op(idxList), unusedSeq, op(cList) ] ):
end:

#------------------------------------------------------------------------------
# getComplexCoords
#------------------------------------------------------------------------------
grF_getComplexCoords := proc ( ndim )
local a, i, coordList, complexCoords, idxseq:
global gr_data:
  coordList := [ seq ( gr_data[xup_,grG_metricName,i], i=1..ndim ) ]:
  complexCoords := {op(coordList)} intersect 
    ( complexSet_ union createConjSet ( complexSet_) ):
  idxseq := NULL:
  if complexCoords <> {} then
    for a to ndim do
      if member ( coordList[a], complexCoords ) then
        idxseq := idxseq, a:
      fi:
    od:
  fi:
  RETURN ( [idxseq] ):
end:

#------------------------------------------------------------------------------
# getNullCoords
#------------------------------------------------------------------------------
grF_getNullCoords := proc ( ip, ndim )
local a, nullseq:
  nullseq := NULL:
  for a to ndim do
    if ip[a,a] = 0 then
      nullseq := nullseq, a:
    fi:
  od:
  RETURN ( [nullseq] ):
end:


#------------------------------------------------------------------------------
# genReorderVectors
#------------------------------------------------------------------------------
grF_genReorderVectors := proc ( ip, ndim, idxSet )
local found, a, b, idxList, zerocount, usedindices, maxorder, maxzeros,
maxidx:

  idxList := []:
  if nops ( idxSet ) = 1 then
    found := false:
    # find a vector which has a non-zero inner product with the already
    # chosen vector.
    for b to ndim while not found do
      if not member ( b, idxSet ) then
        if ip[op(idxSet),b]<>0 then
          idxList := [b]:
          found := true:
        fi:
      fi:
    od:
  elif nops ( idxSet ) = 0 then
    # count the number of zeros in each row of the inner product.
    for a to ndim do
      zerocount[a] := 0:
      for b to ndim do
        if ip[b,a] = 0 then
          zerocount[a] := zerocount[a] + 1:
        fi:
      od:
    od:
    # reorder the index numbers from least to greatest number of zeros.
    usedindices := {}:
    maxorder := NULL:
    while nops ( usedindices ) < ndim do
      maxzeros := 0:
      for a from ndim to 1 by -1 do
        if zerocount[a] >= maxzeros and not member ( a, usedindices ) then
          maxidx := a:
          maxzeros := zerocount[a]:
        fi:
      od:
      maxorder := maxorder, maxidx:
      usedindices := usedindices union {maxidx}:
    od:
    idxList := [ maxorder[4], maxorder[1], maxorder[3], maxorder[2] ]:
  fi:
  RETURN ( idxList ):
end:

#---------------------------------------------------------
#
# grF_rotateI: Perform tetrad rotations of class I or II.
#
#---------------------------------------------------------

grF_rotateI := proc ( gname, v1, aR, aI )

global	gr_data:
local	a, A, Ac, v2:

A  := aR + I*aI:
Ac := aR - I*aI: 

if v1 = 1 then 
  v2 := 2:
else
  v2 := 1:
fi:

for a to 4 do
  gr_data[ebdnup_,gname, v2, a] := gr_data[ebdnup_,gname, v2, a] +
    Ac*gr_data[ebdnup_,gname,3,a] + A*gr_data[ebdnup_,gname,4,a] +
    A*Ac*gr_data[ebdnup_,gname, v2, a]:

  gr_data[ebdnup_,gname, 3, a] := gr_data[ebdnup_,gname, 3, a] +
    A*gr_data[ebdnup_,gname, v1, a]:

  gr_data[ebdnup_,gname, 4, a] := gr_data[ebdnup_,gname, 4, a] +
    Ac*gr_data[ebdnup_,gname, v1, a]:
od:

end: 

#---------------------------------------------------------
#
# grF_rotateIII: Perform tetrad rotations of class III.
#
#---------------------------------------------------------

grF_rotateIII := proc ( gname, A, theta )

global	gr_data:
local	a:

for a to 4 do
  gr_data[ebdnup_,gname, 1, a] := gr_data[ebdnup_,gname, 1, a]/A:

  gr_data[ebdnup_,gname, 2, a] := gr_data[ebdnup_,gname, 2, a]*A:

  gr_data[ebdnup_,gname, 3, a] := gr_data[ebdnup_,gname, 3, a]*exp( I*theta):

  gr_data[ebdnup_,gname, 4, a] := gr_data[ebdnup_,gname, 4, a]*exp(-I*theta):
od:

end: 

