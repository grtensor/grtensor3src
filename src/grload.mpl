
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: grload.mpl
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: April 1994
#
# Contains routines to load metrics and object libraries.
#
# Revisions:
#
# April 17 94	Port from commands to here
# April 18 94   Change grlib to allow overwrite option.
# ???           Tetrad support [dp]
# July 30  94   AConstraints [pm]
# Aug  15  94   grlib now erases overwritten objects.[pm]
# Aug  20  94   Fix grlib for autoload [pm]
# Sept  1  94   Flags for new checkIfAssigned [pm]
# Sept 19  94   Only constraint [pm]
# Dec  11  94   Use convert(hostfile) [pm]
# Mar  10  95   Replace grload to load covariant bases [dp]
# Mar  20  95   Load a string of text information with metrics [dp]
# May  13  95   Don't assume zeros specified for old metrics [dp]
# Nov  15  95	Add global grG_constant_eta to grF_initMetric [dp]
# May   9  96   Modify qload so it checks grOptionqloadPath [pm]
# June 19  96	Check metricPath after all qloadPath are searched [dp]
# Aug  22  96	If sig_ is assigned in metric file, assign it to grG_sig_ [dp]
# Feb   4  97	Change 0,0 checks to checkIfAssigned [dp]
# Feb   5  97	Load and assign complexSet for use with conj() [dp]
# Feb  24  97	add 2nd arg to initMetric so can init but not set [dp]
# Sept 16  97	Removed R3 type specifiers in proc headers [dp]
# Sept 19  97   Added prompt to qload if grOptionMetricPath not set [dp]
# Dec   5  97   Moved location where complexSet_ is set [dp]
# Feb  14  97   Switch convert(x,string) to convert(x,name) for R5 [dp]
# Aug  18  99   Switched readstat and grF_my_readstat to grF_readstat [dp]
# Aug  20  99   Changed use of " to ` for R4 compatibility [dp]
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


#-------------------------------------------------------------------
# These routines make some use of a structure, G.
# G has the following sub-elements:
#	G.gname := name of metric/basis.
#  G.gdim  := dimension of entry.
#  G.gtype := type of entry = { grG_g, grG_ds, grG_basis, grG_np}
#  G.basisu:= contravariant components of the basis, if they exist; or
#       0 if they do not.
#  G.basisd:= covariant components of the basis, if they exist; or
#       0 if they do not.
#  G.metric:= components of metric for gtype = {grG_g or grG_ds}; or
#       components of basis inner product for gtype = {grG-basis, or
#       grG_np}.
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# grload
#-------------------------------------------------------------------
grload := proc()
  if nargs = 0 then:
    grload_maplet();
    RETURN():
  else:
    grF_loadMetric(args[1], args[2]):
  fi:

end proc:

#-------------------------------------------------------------------
# grF_loadMetric
#-------------------------------------------------------------------
grF_loadMetric := proc (gname, gfile)
# need Ndim_ global since can be read from metric file (typically will be)
global  Ndim, Ndim_, constraint_,
  grG_metricName, Info_, sig_, grG_sig_, grG_complexSet_, 
  grG_metricSet, gr_data;
local  a, b, cons,  i, j, ndim, gtype, ip, npip, g,  
       bu, bd, bup, bdn, grinit, stsig, underscore:

  if member ( gname, grG_metricSet ) then
    grmetric (gname):
    RETURN():
  fi:
  if not type ( gname, name ) then
    ERROR ( `Metric name must be of type NAME.` ):
  fi:  

  # Ndim is now the global array of per-metric dimensions...
  #Ndim := 'Ndim':
  Ndim_:= 'Ndim_':
  read gfile:
  # 
  # Support two input styles that differ by whether all the expected names
  # in a metric file have trailing underscores.
  #
  underscore := false:
#
# set dimension.
#
  if assigned ( Ndim_ ) then
    Ndim[gname] := Ndim_:
    underscore := true:
  else
    ERROR ( `Invalid metric file. grload could not find Ndim_.` ):
  fi:
  if assigned ( sig_ ) then
    stsig := sig_:
    sig_ := 'sig_':
  else
    stsig := NULL:
  fi:
  ndim := Ndim[gname]:

  grG_metricName := gname:
#
# initialize complex quantities, if any.
#
  if assigned ( complex_ ) then
    grG_complexSet_[gname] := complex_:
  fi:
#
# determine type of file ( grG_g, grG_np, or grG_basis ).
#
  gtype := grG_g:
  for a to ndim while gtype = grG_g do
    for b from a to ndim while gtype = grG_g do
      if assigned ( eta||(a)||(b)||_ )  then
        gtype := grG_basis:
      fi:
    od:
  od:
  if ndim = 4 and gtype = grG_basis then
    npip := array ( 1..4, 1..4, [[0,1,0,0],[1,0,0,0],[0,0,0,-1],[0,0,-1,0]]):
    gtype := grG_np:
    for a to 4 while gtype = grG_np do
      for b from a to 4 while gtype = grG_np do
        if assigned ( eta||(a)||(b)||_ ) and eta||a||b||_ <> npip[a,b] then
          gtype := grG_basis:
        fi:
      od:
    od:
  fi:
#
# set coordinates.
#
  if not underscore then
    for a to ndim do
      gr_data[xup_,gname,a] := x||a:
      x||a := evaln ( x||a ):
    od:
  else
    for a to ndim do
      gr_data[xup_,gname,a] := x||a||_:
      x||a||_ := evaln ( x||a||_ ):
    od:
  fi:
  grF_assignedFlag ( x(up), set ):
#
# set metric g(dn,dn) for type grG_g.
#
  grinit := false:
  g := array ( 1..ndim, 1..ndim, symmetric ):
  if not underscore then
    for a to ndim do
      for b from a to ndim do
        if assigned ( g||(a)||(b) ) then
          g[a,b] := g||a||b:
          g||a||b  := evaln ( g||a||b ):
          g||b||a  := evaln ( g||b||a ):
          grinit := true:
        else
          g[a,b] := 0:
        fi:
      od:
    od:
  else
    for a to ndim do
      for b from a to ndim do
        if assigned ( g||(a)||(b)||_ ) then
          g[a,b]  := g||a||b||_:
          g||a||b||_ := evaln ( g||a||b||_ ):
          g||b||a||_ := evaln ( g||b||a||_ ):
          grinit := true:
        else
          g[a,b] := 0:
        fi:
      od:
    od:
  fi:
  if grinit = true then
    grF_initg ( ndim, g, gname ):
  fi:
#
# set basis inner product eta(bdn,bdn) and eta(bup,bup) for 
# types grG_basis and grG_np.
#
  grinit := false:
  ip := array ( 1..ndim, 1..ndim, symmetric ):
  for a to ndim do
    for b from a to ndim do
      if assigned ( eta||(a)||(b)||_ ) then
        ip[a,b] := eta||a||b||_:
        eta||a||b||_ := evaln ( eta||a||b||_ ):
        grinit := true:
      else
        ip[a,b] := 0:
      fi:
    od:
  od:
  if grinit = true then
    grF_initip ( ndim, ip, gname ):
  fi:
#
# initialize basis vectors e(bdn,up) and e(bdn,dn) for types grG_basis
# and grG_np.
#
  grinit := false:
  bu := array ( 1..ndim, 1..ndim ):
  for a to ndim do
    for b to ndim do
      if assigned ( b||(a)||(b)||_ ) then
        bu[a,b] := b||a||b||_:
        b||a||b||_ := evaln ( b||a||b||_ ):
        grinit := true:
      else 
        bu[a,b] := 0:
      fi:
    od:
  od:
  if grinit = true then
    grF_initbasisup ( ndim, bu, gname, gtype ):
  fi:

  grinit := false:
  bd := array ( 1..ndim, 1..ndim ):
  for a to ndim do
    for b to ndim do
      if assigned ( bd||(a)||(b)||_ ) then
        bd[a,b] := bd||a||b||_:
        bd||a||b||_ := evaln ( bd||a||b||_ ):
        grinit := true:
      else
        bd[a,b] := 0:
      fi:
    od:
  od:
  if grinit = true then
    grF_initbasisdn ( ndim, bd, gname, gtype ):
  fi:
#
# initialize constraints, if they exist.
#
  if assigned ( constraint_ ) then
    # awkward, since use constraint_ as tag
    cons := constraint_;
    constraint_ := 'constraint_':
    #printf("Loaded constraint: %a\n", cons):
    gr_data[constraint_,gname] := [op(cons)]:
    grF_assignedFlag ( constraint, set, gname ):
  fi:
#
# initialize text information field, if it exists.
#
  if assigned ( Info_ ) then
    gr_data[Text_,gname] := Info_:
    grF_assignedFlag ( Info, set, gname ):
    Info_ := 'Info_':
  fi:
#
# initialize the spacetime signature
#
  if stsig = NULL and grOptionLLSC then
    if G||gtype = grG_np then
      stsig := -2:
    else
      stsig := 2:
    fi:
  fi:
  if stsig <> NULL then
    grG_sig_[gname] := stsig:
    grF_assignedFlag ( sig, set, gname ):
  fi:
#
# perform some housekeeping and display the metric.
#
  grF_initMetric ( gname ):
  grF_displaymetric ( gname, gtype ):
  if grF_assignedFlag( constraint, test, gname ) then
    grdisplay(constraint);
  fi:
end:

#---------------------------------------------------------------
# put common initalization here. This is used by grxform() and
# junction() also.
#---------------------------------------------------------------

grF_initMetric := proc()
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  
  grG_coordStr, 
  grG_defaultMetric, 
  grG_metricSet,
  grG_default_metricName, 
  grG_metricName, 
  grG_constant_eta,
  complexSet_, 
  Ndim:

local i, gname, setMetric;

  gname := args[1]:
  if nargs = 2 then
    setMetric := args[2]:
  else
    setMetric := true:
  fi:
  # initalize records for the new metric
  grG_ricciFlat||gname := false:
  grG_weylFlat||gname := false:
  if grF_checkIfAssigned ( eta(bup,bup) ) then
      grG_constant_eta[gname] := grF_checkEtaComponents ( gname ):
  fi:
  # build array of coord names with leading spaces for use
  # by grComponents
  grG_record||gname := grG_recordInit:
  grG_metricSet := grG_metricSet union {gname}:
  for i to Ndim[gname] do
      grG_coordStr[gname,i] := convert(gr_data[xup_,gname,i], name);
  od:

  if setMetric then
    grF_setmetric ( gname ):
  fi:

  #
  # copy all the dimensions into the Ndim array
  # (Ndim[gname] id required in auto object creation
  # and historically we used Ndim in the input file also
  # hence this uglification)
  #
#  for i in grG_metricSet do
#    Ndim[i] := Ndim||i:
#  od:

end:

#----------------------------------------------------------
# setComplexSet
#----------------------------------------------------------
grF_setComplexSet := proc ( gname )
global complexSet_:
  if assigned ( grG_complexSet_[gname] ) then
    complexSet_ := grG_complexSet_[gname]:
  else
    complexSet_ := {}:
  fi:
end:

#----------------------------------------------------------
# qload
# load a metric given only it's name
#----------------------------------------------------------

qload := proc( metric)
global  grOptionFileCharacter, grOptionMetricPath, grOptionqloadPath:
local mfile, m;

    mfile = metric:
    if not type(metric, string) then
       mfile := sprintf("%a", metric);
    fi:
    mfile := cat(mfile,".mpl"):

    if not assigned ( grOptionMetricPath ) then
      printf ( `Warning: grOptionMetricPath has not been assigned.\n` ):
    else
      if not type(grOptionMetricPath, string) then
        printf("%a is not of type string. Please use double quotes\n", grOptionMetricPath);
        RETURN();
      fi:
      mpath := FileTools:-JoinPath([grOptionMetricPath, mfile]);
      if grF_testLoad( mpath) then
        grload( metric, mpath);
        RETURN():
      fi:
    fi:

 
    #
    # if it's not in the directory indicated in grOptionMetricPath
    # then try each of the entries in grOptionqloadPath (in order)
    #
    if assigned(grOptionqloadPath) then
      for m in [grOptionqloadPath] do
        if not type(m, string) then
          printf("%a is not of type string. Please use double quotes\n", m);
          RETURN():
        fi:
         mpath := FileTools:-JoinPath([m, mfile]);
         if not grF_testLoad( mpath) then
           mfile := NULL:
         else
           break;
         fi:
      od:
    fi:

    if mfile <> NULL then
        grload( metric, mpath);
    else
        ERROR(`Could not find metric `||metric):
    fi:
end:

grF_testLoad := proc( metricFile)
option `Copyright 1996 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  if traperror( grF_testRead( metricFile)) = lasterror then
     false;
  else
     true;
  fi:
end:

# need this wrapper to use traperror around read

grF_testRead := proc( fileName) read fileName; end:


#----------------------------------------------------------
# checkEtaComponents - check that the components of eta(bup,bup) are
#  constants (true) or functions of the coordinates (false).
#----------------------------------------------------------

grF_checkEtaComponents := proc ( gname )
local  a, b, c:
global gr_data, Ndim, grG_metricName:

for a to Ndim[grG_metricName] do
    for b to Ndim[grG_metricName] do
        for c to Ndim[grG_metricName] do
           if diff ( gr_data[etabupbup_,grG_metricName,a,b], gr_data[xup_,grG_metricName,c] ) <> 0 then
               RETURN ( false ):
           fi:
        od:
    od:
od:
RETURN ( true ):
end:

