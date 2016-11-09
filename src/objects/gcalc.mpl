#------------------------------------------------------------------------------
# gcalc.mpl
# routines used by the definitions of g(dn,dn), detg, and g(up,up) (in tensors1.mpl)
#
# This file contains:
#  grF_invMetric
#  grF_calcdetg
#
#------------------------------------------------------------------------------

#-------------------------------------------------
# grF_calcDetg
# (calculate detg given gdndn or gupup)
#-------------------------------------------------
grF_calcDetg := proc( startpt )
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  gr_data, grG_metricName, Ndim:
local   i,j,n,gg:

  n := Ndim[grG_metricName]:

  gg := array(1 .. n,1 .. n):
  for i to n do
	for j to n do
	  gg[i,j] := gr_data[startpt,grG_metricName,i,j]:
	od:
  od:
  if startpt = gupup_ then
     gr_data[detg_,grG_metricName] := 1/linalg[det](gg):
  else
     gr_data[detg_,grG_metricName] := linalg[det](gg):
  fi:
end:

#-------------------------------------------------
# grF_invMetric
# (create gupup given gdndn, or gdndn given gupup)
#-------------------------------------------------
grF_invMetric := proc(endpt,startpt)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  grG_metricName, Ndim, gr_data:  
local   i,j,n,gg,hh,detg:


  n := Ndim[grG_metricName]:
  if startpt = "gdndn_" then
    detg := gr_data[detg_,grG_metricName]:
  else
    detg := 1/gr_data[detg_,grG_metricName]:
  fi:
  for i to n-1 do
    for j from i+1 to n do
  	gr_data[endpt,grG_metricName,j,i] := gr_data[  endpt,grG_metricName,i,j]:
    od:
  od:
  
  gg := array(1 .. n,1 .. n):
  for i to Ndim[grG_metricName] do
	for j to Ndim[grG_metricName] do
	  gg[i,j] := gr_data[startpt,grG_metricName,i,j]:
	od:
  od:
  hh := array(1 .. n,1 .. n):
  hh := linalg[inverse](gg):
  #
  # (symmetry assignments done up top)
  #
  for i to n do
    for j from i to n do
      gr_data[endpt,grG_metricName,i,j] := hh[i,j]:
    od:
  od:

end:
