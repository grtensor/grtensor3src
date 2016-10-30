###########################
# NEWMETRI.MPL
###
# Converted from 5.2 to 5.3
###########################
#/////////////////////////////////////
#
# grnewmetric ( newName, object, [coordList] ):
#
# newName      new metric name
# object       name of object to take metric from
# [coordList]  list of coordinates (optional)
#
# This function creates a metric by copying it from an existing
# object in the session. The metric is not saved, but can be saved
# using grsaveg().
#
# Sep 12  1994  Remove coordList arg [pm]
# Oct 21  1994  Allow contravariant source objects [pm]
# Dec 11  1994  Use convert(hostfile) [pm]
# Nov 19  1995  Add optional fifth parm (newCoords) [pm]
# Jan 17  1996  Fix parameter tests [pm]
# May 28  1996  Fixed bug in selection coords. [dp]
# Jun 26  1996	Don't save to file anymore, now only 2 or 3 args. [dp] 
# Feb  4  1997  Replace 0,0 checks with checkIfAssigned [dp]
# Feb 14, 1997   Switch convert(x,string) to convert(x,name) for R5 [dp]
#
#//////////////////////////////////////

grnewmetric := proc()
global  Ndim, grG_xup_, grG_gdndn_, filePath, grG_metricName;
local 	root, i, j, newG, newMetric, object, obj_metric, filename, newCoords:

if not ( nargs = 2 or nargs = 3 ) then
   ERROR ( `Wrong number of parameters. 2 or 3 required` ):
fi:

newMetric := args[1]:
object := args[2]:
obj_metric := grG_default_metricName:
if nargs = 3 then
  newCoords := args[3]:
  if not type(newCoords, list) then 
    ERROR(`Fourth argument must be of type list.`);
  fi:
else
  newCoords := [ seq(grG_xup_[obj_metric,i], i=1..Ndim[obj_metric]) ]:
fi:

if not type ( newMetric, name ) then
  ERROR(`Filename must be of type name.`);
fi:

if not member ( obj_metric, grG_metricSet ) then
  ERROR(`The metric `||obj_metric||` has not been loaded`);
fi:

if nargs = 3 and nops(newCoords) <> Ndim[obj_metric] then
  ERROR ( `Number of new coordinates does not equal dimension of `||obj_metric 
    ):
fi:

if ( nops ( object ) <> 2 ) then
  ERROR ( 
  `<Object> parameter must specify an object with two covariant indices.`
  ):
elif not ( op(1,object) = dn and op(2,object) = dn ) then
  ERROR ( `Indices of <Object> must both be dn or up.` ):
fi:

if member ( newMetric, grG_metricSet ) then
  ERROR ( `Metric name has already been used:`, newMetric ):
fi:

if not grF_checkIfAssigned ( object ) then
   ERROR ( ``||object||` has not been calculated for metric `, obj_metric );
fi:

root := grG_ObjDef[object][grC_root]:

newG := array ( 1..Ndim[obj_metric], 1..Ndim[obj_metric] ):
for i to Ndim[obj_metric] do
  for j to Ndim[obj_metric] do
     newG[i,j] := grG_||root[obj_metric,i,j];
  od:
od:

for i to Ndim[obj_metric] do
  grG_xup_[newMetric,i] := newCoords[i]:
od:
grF_assignedFlag ( x(up), set ):
Ndim||newMetric := Ndim[obj_metric]:
 
grF_initg ( Ndim[obj_metric], newG, newMetric ):
grF_initMetric ( newMetric ):

NULL:
end:
