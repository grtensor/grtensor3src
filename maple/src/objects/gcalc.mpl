#------------------------------------------------------------------------------
# gcalc.mpl
# routines used by the definitions of g(dn,dn), detg, and g(up,up) (in tensors1.mpl)
#
# This file contains:
#  grF_invMetric
#  grF_calcdetg
#
#------------------------------------------------------------------------------
macro(gname = grG_metricName):

#-------------------------------------------------
# grF_calcDetg
# (calculate detg given gdndn or gupup)
#-------------------------------------------------
grF_calcDetg := proc( startpt )
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_gupup_, grG_gdndn_, grG_detg_:
local   i,j,Ndim,gg:

Ndim := Ndim||gname:
if Ndim = 4 then
  # this mess is deteminant formed by linalg
  grG_detg_[gname] := grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,3]*grG_||startpt[gname,4,4] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,4]**2 -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3]^2*grG_||startpt[gname,4,4] +
	2*grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,4]**2*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,1,2]**2*grG_||startpt[gname,3,3]*grG_||startpt[gname,4,4] +
	grG_||startpt[gname,1,2]**2*grG_||startpt[gname,3,4]**2 +
	2*grG_||startpt[gname,1,2]*grG_||startpt[gname,2,3]*grG_||startpt[gname,1,3]*grG_||startpt[gname,4,4] -
	2*grG_||startpt[gname,1,2]*grG_||startpt[gname,2,3]*grG_||startpt[gname,1,4]*grG_||startpt[gname,3,4] -
	2*grG_||startpt[gname,1,2]*grG_||startpt[gname,2,4]*grG_||startpt[gname,1,3]*grG_||startpt[gname,3,4] +
	2*grG_||startpt[gname,1,2]*grG_||startpt[gname,2,4]*grG_||startpt[gname,1,4]*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,2,2]*grG_||startpt[gname,1,3]**2*grG_||startpt[gname,4,4] +
	2*grG_||startpt[gname,1,3]*grG_||startpt[gname,2,2]*grG_||startpt[gname,1,4]*grG_||startpt[gname,3,4] +
	grG_||startpt[gname,1,3]**2*grG_||startpt[gname,2,4]^2 -
	2*grG_||startpt[gname,1,3]*grG_||startpt[gname,2,4]*grG_||startpt[gname,1,4]*grG_||startpt[gname,2,3] -
	grG_||startpt[gname,2,2]*grG_||startpt[gname,1,4]^2*grG_||startpt[gname,3,3] +
	grG_||startpt[gname,1,4]**2*grG_||startpt[gname,2,3]**2:
elif Ndim = 3 then
  grG_detg_[gname] := grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3]**2 -
	grG_||startpt[gname,1,2]**2*grG_||startpt[gname,3,3] +
	2*grG_||startpt[gname,1,2]*grG_||startpt[gname,1,3]*grG_||startpt[gname,2,3] -
	grG_||startpt[gname,1,3]**2*grG_||startpt[gname,2,2]:
elif Ndim = 2 then
  grG_detg_[gname] := grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2] - grG_||startpt[gname,1,2]**2:
elif Ndim = 1 then
  grG_detg_[gname] := grG_||startpt[gname,1,1]:
elif (4 < Ndim) then
  gg := array(1 .. Ndim,1 .. Ndim):
  for i to Ndim||grG_metricName do
	for j to Ndim||grG_metricName do
	  gg[i,j] := grG_||startpt[gname,i,j]:
	od:
  od:
  grG_detg_[gname] := linalg[det](gg):
else 
  ERROR(`Ndim must be a positive integer`)
fi:
if startpt = gupup_ then
  grG_detg_[gname] := 1/grG_detg_[gname]:
fi:
end:

#-------------------------------------------------
# grF_invMetric
# (create gupup given gdndn, or gdndn given gupup)
#-------------------------------------------------
grF_invMetric := proc(endpt,startpt)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_gupup_, grG_gdndn_:  
local   i,j,Ndim,gg,hh,detg:

Ndim := Ndim||gname:
if startpt = gdndn_ then
  detg := grG_detg_[gname]:
else
  detg := 1/grG_detg_[gname]:
fi:
for i to Ndim-1 do
  for j from i+1 to Ndim do
	grG_||endpt[gname,j,i] := grG_||endpt[gname,i,j]:
  od:
od:
if Ndim = 4 then
  grG_||endpt[gname,1,1] := (grG_||startpt[gname,2,2]*grG_||startpt[gname,3,3]*grG_||startpt[gname,4,4]
	- grG_||startpt[gname,2,2]*grG_||startpt[gname,3,4]^2 +
	2*grG_||startpt[gname,2,3]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,4]
	- grG_||startpt[gname,3,3]*grG_||startpt[gname,2,4]^2
	- grG_||startpt[gname,4,4]*grG_||startpt[gname,2,3]^2)/detg:
  grG_||endpt[gname,1,2] := (grG_||startpt[gname,1,2]*grG_||startpt[gname,3,4]^2 +
	grG_||startpt[gname,1,3]*grG_||startpt[gname,2,3]*grG_||startpt[gname,4,4] +
	grG_||startpt[gname,1,4]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,3,3]*grG_||startpt[gname,4,4] -
	grG_||startpt[gname,1,3]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,4]*grG_||startpt[gname,2,3]*grG_||startpt[gname,3,4])/detg:
  grG_||endpt[gname,1,3] := (grG_||startpt[gname,1,2]*grG_||startpt[gname,2,3]*grG_||startpt[gname,4,4] +
	grG_||startpt[gname,1,3]*grG_||startpt[gname,2,4]^2 +
	grG_||startpt[gname,1,4]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,3]*grG_||startpt[gname,2,2]*grG_||startpt[gname,4,4] -
	grG_||startpt[gname,1,4]*grG_||startpt[gname,2,3]*grG_||startpt[gname,2,4])/detg:
  grG_||endpt[gname,1,4] := (grG_||startpt[gname,1,2]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,3] +
	grG_||startpt[gname,1,3]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,4] +
	grG_||startpt[gname,1,4]*grG_||startpt[gname,2,3]^2 -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,2,3]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,3]*grG_||startpt[gname,2,3]*grG_||startpt[gname,2,4] -
	grG_||startpt[gname,1,4]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,3])/detg:
  grG_||endpt[gname,2,2] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,3,3]*grG_||startpt[gname,4,4] +
	2*grG_||startpt[gname,1,3]*grG_||startpt[gname,1,4]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,3,4]^2 -
	grG_||startpt[gname,1,3]^2*grG_||startpt[gname,4,4] -
	grG_||startpt[gname,1,4]^2*grG_||startpt[gname,3,3])/detg:
  grG_||endpt[gname,2,3] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,4] +
	grG_||startpt[gname,1,2]*grG_||startpt[gname,1,3]*grG_||startpt[gname,4,4] +
	grG_||startpt[gname,1,4]^2*grG_||startpt[gname,2,3] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3]*grG_||startpt[gname,4,4] -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,1,4]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,3]*grG_||startpt[gname,1,4]*grG_||startpt[gname,2,4])/detg:
  grG_||endpt[gname,2,4] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3]*grG_||startpt[gname,3,4] +
	grG_||startpt[gname,1,2]*grG_||startpt[gname,1,4]*grG_||startpt[gname,3,3] +
	grG_||startpt[gname,1,3]^2*grG_||startpt[gname,2,4] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,4]*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,1,3]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,3]*grG_||startpt[gname,1,4]*grG_||startpt[gname,2,3])/detg:
  grG_||endpt[gname,3,3] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2]*grG_||startpt[gname,4,4] +
	2*grG_||startpt[gname,1,2]*grG_||startpt[gname,1,4]*grG_||startpt[gname,2,4] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,4]^2 -
	grG_||startpt[gname,2,2]*grG_||startpt[gname,1,4]^2 -
	grG_||startpt[gname,4,4]*grG_||startpt[gname,1,2]^2)/detg:
  grG_||endpt[gname,3,4] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3]*grG_||startpt[gname,2,4] +
	grG_||startpt[gname,1,2]^2*grG_||startpt[gname,3,4] +
	grG_||startpt[gname,1,3]*grG_||startpt[gname,1,4]*grG_||startpt[gname,2,2] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,4] -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,1,4]*grG_||startpt[gname,2,3] -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,1,3]*grG_||startpt[gname,2,4])/detg:
  grG_||endpt[gname,4,4] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2]*grG_||startpt[gname,3,3] +
	2*grG_||startpt[gname,1,2]*grG_||startpt[gname,1,3]*grG_||startpt[gname,2,3] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3]^2 -
	grG_||startpt[gname,1,2]^2*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,1,3]^2*grG_||startpt[gname,2,2])/detg:
elif Ndim = 3 then
  grG_||endpt[gname,1,1] := (grG_||startpt[gname,2,2]*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,2,3]^2)/detg:
  grG_||endpt[gname,1,2] := (grG_||startpt[gname,1,3]*grG_||startpt[gname,2,3] -
	grG_||startpt[gname,1,2]*grG_||startpt[gname,3,3])/detg:
  grG_||endpt[gname,1,3] := (grG_||startpt[gname,1,2]*grG_||startpt[gname,2,3] -
	grG_||startpt[gname,1,3]*grG_||startpt[gname,2,2])/detg:
  grG_||endpt[gname,2,2] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,3,3] -
	grG_||startpt[gname,1,3]^2)/detg:
  grG_||endpt[gname,2,3] := (grG_||startpt[gname,1,2]*grG_||startpt[gname,1,3] -
	grG_||startpt[gname,1,1]*grG_||startpt[gname,2,3])/detg:
  grG_||endpt[gname,3,3] := (grG_||startpt[gname,1,1]*grG_||startpt[gname,2,2] -
	grG_||startpt[gname,1,2]^2)/detg:
elif Ndim = 2 then
  grG_||endpt[gname,1,1] := grG_||startpt[gname,2,2]/detg:
  grG_||endpt[gname,1,2] := -grG_||startpt[gname,1,2]/detg:
  grG_||endpt[gname,2,2] := grG_||startpt[gname,1,1]/detg:
elif Ndim = 1 then
  grG_||endpt[gname,1,1] := normal(1/grG_||startpt[gname,1,1]):
elif type(Ndim,integer) and (4 < Ndim) then
  gg := array(1 .. Ndim,1 .. Ndim):
  for i to Ndim||grG_metricName do
	for j to Ndim||grG_metricName do
	  gg[i,j] := grG_||startpt[gname,i,j]:
	od:
  od:
  hh := array(1 .. Ndim,1 .. Ndim):
  hh := linalg[inverse](gg):
  #
  # (symmetry assignments done up top)
  #
  for i to Ndim||grG_metricName do
    for j from i to Ndim||grG_metricName do
      grG_||endpt[gname,i,j] := hh[i,j]:
    od:
  od:
else
  ERROR(`Ndim must be a positive integer`)
fi:
end:
