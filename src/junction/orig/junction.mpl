#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: JUNCTION.MPL
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: May 8, 1994
#
#
# Purpose: Operators for Junction Conditions
#
# Revisions:
#
# May   8, 94     Created
# May  12, 94     Added some exploratory stuff.
# July 19, 94     Major re-write and restructuring
# July 23, 94     Add tricks.
# Mar  29, 95     Use new K(dn,dn) [don't need n(dn,cdn) anymore]
# Apr  28, 95     Don't display trK in join. Assign utype
# Aug   8, 95     - Add xform relations to surface constraints.
#                 - Screen xforms for r=r(tau) which will cause
#                   r(tau)(tau) in juncF_project and refuse to accept
#                   them
#
# Sept. 21, 95    Cosmetics.
#
# Jan  17, 96      Fix evInt (now call project)
# Jan  19  96      Add elasticity module [pm]
# Apr   2, 96      Add help [pm]
# Apr  16, 96      Add preliminary null junction support [pm]
# July  3, 96      Add in claw and hist operators [pm]
# July 10, 96      beautify prompts, make l^a optional [pm]
# May  22, 97      Fixed setting of calc'ed flag in grJ_getComponents [dp]
# 
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# customize this line for your system
rootDir := "/Users/peter/maple/junction/junctionsource/":

# Set version and date information based on the contents of grii/Version:
#   (The following assume that the command "sed' is available in your
#   build environment)


readfile := proc (filename)
  printf ("Reading %s", filename):
  read cat(rootDir, filename):
  printf (" done.\n"):
end:

junction := proc()
global grG_multipleDef:

  lprint(`The GRJunction Package Version 2.04`):
  lprint(`Last modified 22 May 1997`):
  lprint(`Developed by Peter Musgrave and Kayll Lake, (c) 1995,1996`);
  lprint(`Latest version available at:`);
  lprint(`     http://astro.queensu.ca/~grtensor/GRjunction.html`);
  lprint(`Help available via ?junction`);
  #
  # code for multiple definition of g(dn,dn)
  # (Note that we cannot just assign additional table entries in
  # junction.m since when they're loaded Maple will turf all the
  # old entries in favour of the new table - hence we assign them
  # in the start-up routine for the package)
  #
  if not assigned( grG_multipleDef[g(dn,dn)]) then
    grG_multipleDef[g(dn,dn)] := []:
  fi:
  grG_multipleDef[g(dn,dn)] := [ juncg(dn,dn), 
         op(grG_multipleDef[g(dn,dn)]) ]:
end:


#readlib(makehelp):
#makehelp( `junction`, `junction.txt`);

readfile(`objects.mpl`);
readfile( `clawHist.mpl`);
readfile( `nullObjects.mpl`);
#read `elasticity.mpl`;
readfile( `oper.mpl`);
readfile( `project.mpl`);
readfile( `jdiff.mpl`); # used only by n_\alpha
lprint(`Continuing with junction.mpl`);

# regenerate the list of availbale objects
grF_gen_rootSet():

macro( gname = grG_metricName):

#////////////////////////////
#////////////////////////////
#
# Functions
#
#////////////////////////////
#////////////////////////////

#************************************************
# surf( metric, gname, surface)
#
# metric - Name of metric to embed the surface in
#
# gname  - name of spacetime <metric> in terms of
#          the coordinates of the surface
#
# surface- name of the surface manifold
#
# - prompt for the necessary info to make a surface
#
#************************************************

surf := proc( metricName, sName)

local a, b, c, s, defList, useC, object, affine, c_rhs,
      c_eqn, elim, mate, response, sCoords, gname, traceValue,
      reply, Ncompts, lapse;

global grG_metricSet, grG_metricName, grG_ObjDef,
       grG_constraint, grG_ds_, grG_partner_, grG_gdndn_,
       grG_gdndndn_, grG_xup_, Ndim, grG_ntype_, grG_default_metricName,
       grG_uup_, grG_udn_, grG_totalVar_,
       grG_partialVars_, grG_nsign_,
       grJ_totalVar, grG_utype_, grG_coordStr,
       grOptionTrace, grG_Nup_, grG_Ndn_;

  readlib(freeze): # used in project

  gname := metricName:

  if not member(metricName, grG_metricSet) then
    ERROR(`The metric `,metricName, ` has not been loaded.`):
  elif member( sName, grG_metricSet) then
    ERROR(`The metric name `,sName, ` is already in use.`):
  fi:

  #
  # check if this spacetime has a surface associated with it already.
  # If so we cannot proceed since xform, u(up) etc. are all tied into M
  #
  if assigned( grG_partner_[metricName]) then
     printf(`A spacetime may have only one surface associated with it\n`);
     printf(`in a given session. \n`);
     ERROR(`Surface already declared`);
  fi:
  #
  # turn off trace messages
  #
  traceValue := grOptionTrace:
  grOptionTrace := false:

  #
  # link the surface to gname
  #
  grG_metricSet := grG_metricSet union {sName}:
  grG_partner_[sName] := gname:
  grG_partner_[gname] := sName:

  #
  # SURFACE COORDS
  #
  s := sprintf(`\n COORRDINATES: Enter the coordinates of the surface as a list\n`);
  s := cat(s, sprintf(`   e.g. [theta, phi, tau]; \n`));
  s := cat(s, sprintf(`   Enter a list >`));

  sCoords := 0;
  while not type(sCoords,list) do
    sCoords := grF_input(s, [], `junction`):
  od:
  Ndim[sName] := nops(sCoords):
  Ndim||sName := nops(sCoords):

  for a to Ndim[sName] do
    grG_coordStr[sName, a] := sCoords[a]:
    grG_xup_[sName,a] := sCoords[a]:
  od:
  grG_metricName := sName:
  grF_assignedFlag(x(up),set);

  #
  # TOTAL DERIV
  #
  grG_totalVar_[gname] := [];
  s := sprintf(`\n SHELL PARAMETER:\n`);
  s := cat(s, sprintf(`   For a one-parameter shell, enter the parameter name.\n`)):
  s := cat(s, printf(`   For a null shell indicate which coordinate is a null generator\n`));
  s := cat(s, printf(`   Enter coordinate name or 0 (zero) for none >`));
  while not type(grG_totalVar_[gname],{name,integer}) do
    grG_totalVar_[gname] := 
      grF_input(s, 0, `junction`):
  od:
  grJ_totalVar := grG_totalVar_[gname]: # used by jdiff and various definitions

  # assign coordinates 

  for a to Ndim[gname] do
    grG_xup_[gname,a] := grG_xup_[metricName,a]:
  od:

  #
  # COORDINATE RELATIONS
  #
  # Enter the coordinate relations. These are used in the
  # routine unleash.
  # (i.e. we need expressions like r=R(tau) to eliminate references
  #       to the enveloping spacetimes for quantities on the
  #       surface)
  #
  grG_default_metricName := gname:
  grcalc( xform(up)):

  #
  # determine if the normal is TL, SL or Null (calculate
  # the normal with simplify as the alteration function)
  #

  s := sprintf(`\n NORMAL TYPE: Please indicate the nature of the normal vector\n`);
  s := cat(s, sprintf(`   (-1 = timelike, 0 = null, 1= spacelike)`));
  s := cat(s, sprintf(` Enter +1,0 or -1 >`));
  grG_ntype_[metricName] := grF_input(s , 1, `junction`):
  grG_utype_[metricName] := -1*grG_ntype_[metricName]:

  #
  # SURFACE CONSTRAINT -> becomes GRT constraint
  #
  # Indicate the Lagrangian equation, and prompt for the
  # req'd info
  #
  useC := 0:
  if grG_totalVar_[gname] <> 0 then
    s := sprintf(`\n CONSTRAINT: Use  +/- 1 = u{^a} u{a} as a constraint ? `);
    s := cat(s, sprintf(`   Enter 1 if yes >`));
    useC := grF_input(s, 1, `junction`);
  fi:
  #
  # calculate u(up)
  #
  if useC = 1 then
    #
    # build the constraint
    #
    grcalc(u(up),u(dn));
    c_rhs := 0:
    for a to Ndim[gname] do
      for b to Ndim[gname] do
       c_rhs := c_rhs + grG_gdndn_[gname,a,b] *
                grG_uup_[gname,a] * grG_uup_[gname,b]:
      od:
    od:
    c_eqn := -1*grG_ntype_[gname] = normal(c_rhs):
    if not type(rhs(c_eqn), numeric) then
      print(`The constraint equation is:`);
      print( c_eqn);
      grG_constraint[gname] := grG_constraint[sName]:
      grG_constraint[ sName] := [c_eqn]:
      grFc_mod_constraint( constraint, sName):
      grG_constraint[sName] := [op(grG_constraint[sName]),
		seq( grG_xup_[gname,a] = 
		  grG_xformup_[gname,a],a=1..Ndim[gname]) ]:
    else
      #
      # need this for explicit subs in junction
      #
      grG_constraint[gname] := []:
      grG_constraint[sName] := [seq( grG_xup_[gname,a] = 
		grG_xformup_[gname,a],a=1..Ndim[gname]) ]:
      printf(`The rhs of the constraint equation is numeric\n`);
      printf(`and hence has no new information.\n`);
    fi:
  else
    grG_constraint[gname] := []:
    grG_constraint[sName] := [seq( grG_xup_[gname,a] = 
		grG_xformup_[gname,a],a=1..Ndim[gname]) ]:
  fi:

  grmetric(metricName);
  #
  # get the surface equation, and calculate the normal
  # vector (use an object definition for n(dn) )
  #
  grcalc( surface);
  #
  # if surface =0 then the user wants to enter components...
  #
  if grG_surface_[metricName] = 0 then
     s := `NORMAL VECTOR: Enter the components of the normal vector\n`;
     grJ_getComponents( s, metricName, n);
  fi: # null shell

  #
  # get the normal vector sign
  #
  s := sprintf(`\n NORMAL SIGN\n`);
  s := cat(s, sprintf(`   The definition of the normal vector is +/- grad(surface)\n`));
  s := cat(s, sprintf(`   please enter +1 or -1 to indicate the CHOICE of sign\n`));
  grG_nsign_[gname] := grF_input(s, 1, `junction`):


  # 
  # NULL SURFACE: get the Lapse vector (either covariant or
  # contravariant)
  #
  if grG_ntype_[metricName] = 0 then
     s := `TRANSVERSE VECTOR\n`;
     grJ_getComponents( s, metricName, N):
  fi: # null shell

  #
  # CALCULATE THE SURFACE METRIC 
  #
  # calculate g{i j}  n(dn)
  #
  grcalc( n(dn));
  grmetric(sName):
  grcalc( g(dn,dn)): # was g(dn,dn)

  #
  # ask if we can calculate g(up,up) for a null shell by inverting
  # the two metric 
  #
  if grG_ntype_[metricName] = 0 and grG_totalVar_[metricName] <> 0 then
    s := sprintf(`\n nullg(up,up): Calculate nullg(up,up) automatically?\n`);
    s := cat(s, sprintf(`   (If N is orthogonal to those basis vectors on\n`));
    s := cat(s, sprintf(`    the surface which are *not* the null\n`));
    s := cat(s, sprintf(`    generator of the surface)\n`));
    s := cat(s, sprintf(`   y/n`\n));
    if grF_input(s, "y", `junction`) = 'y' then
       grcalc(nullg(up,up) );
    fi:
  fi:
  if grG_ntype_[metricName] = 0 then
    s := sprintf(` l{^a}: Enter the components for l{^a}\n`);
    s := cat(s, sprintf(`   y/n`\n));
    if grF_input(s, "y", `junction`) = 'y' then
       grJ_getComponents( s, sName, l);
    fi:
  fi:


  #
  # now display the result
  #
  # naughty, but explicitly calc ds (since if goes through normal
  # it gets messy and this is best work around)
  #
  grG_metricName := sName:
  grG_ds_[sName] := grF_calc_ds(ds,[]):
  grdisplay(surface[gname],xform[gname](up),ds);

  grOptionTrace := traceValue:

  printf(`The intrinsic metric and normal vector have been calculated.\n`); 
  printf(`You may wish to simplify them further before saving the surface\n`);
  printf(`or calculating K(dn,dn) \n`);

end:

grJ_getComponents := proc(vec_prompt, metricName, vect)

    local reply, Ncompts, a, updn, s:
    #
    # does the user want co or contra components ?
    #
    s := vec_prompt:
    s := cat(s, sprintf(`\n   Do you wish to enter 1) covariant components\n`));
    s := cat(s, sprintf(`                        2) contravariant components\n`));
    reply := 0;
    while not member(reply, {1,2}) do 
      reply := grF_input(s, 1, `junction`);
    od:
    #
    # get the vector
    #
    s := vec_prompt:
    s := cat(s, sprintf(`\n   Enter the components of the vector as a list\n`));
    s := cat( s, sprintf(`   in the order (`));
    for a to Ndim[metricName] do
      s := cat( s, sprintf(`%a`, grG_xup_[metricName,a]));
      if a <> Ndim[metricName] then
        s := cat( s,printf(`, `));
      else
        s := cat(s, sprintf(`)`));
      fi:
    od:
    Ncompts := 1;
    s := cat(s, sprintf(`\n   Component list >`));
    while not type( Ncompts, list) do
       Ncompts := grF_input(s, 0, `junction`):
    od:
    #
    # copy the compnents the the appropriate object
    #
    if reply = 1 then 
       updn :=  dn;
    else
       updn := up:
    fi:
    for a to Ndim[metricName] do
       grG_||vect||updn||_[metricName, a] := op(a, Ncompts);
    od:
    print ( vect(updn) );
    grF_assignedFlag ( vect(updn), set, metricName ):

end:

#************************************************
# sload( metric, sName, fileName)
#
#************************************************

sload := proc( metric, sName, fileName)

global grG_metricSet, grG_default_metricName, grG_ds_, grG_metricName,
       grG_partner_:

local mFile, sFile:

 if member( metric, grG_metricSet) then
   ERROR(`Metric name `, metric, ` is already in use.`);
 elif member( sName, grG_metricSet) then
   ERROR(`Metric name `, sName, ` is already in use.`);
 fi:

 grG_metricSet := grG_metricSet union {metric,sName}:
 grG_partner_[metric] := sName:
 grG_partner_[sName] := metric:
 mFile := convert( fileName.`.ju1`, string):
 grloadobj( metric, mFile):
 grG_metricName := metric:
 grG_default_metricName := metric:
 grG_ds_[metric] := grF_calc_ds(ds,[]):
 grdisplay(ds);
 sFile := convert( fileName.`.ju2`, string):
 grG_default_metricName := sName:
 grloadobj( sName, sFile):
 grG_metricName := sName:
 grG_ds_[sName] := grF_calc_ds(ds,[]):
 grdisplay(ds);
 printf(`The default metric is now %a\n`, sName);

end:

#************************************************
# join( outside, inside)
#
# Associate two surfaces
#
#************************************************

join := proc( outside, inside)

local a:

global grG_join_, grG_default_metricName,
       grG_default_Mint, grG_default_Mext:

 for a in {outside, inside} do
   if not member( a, grG_metricSet) then
     ERROR(a, ` is not a metric`):
   elif not assigned( grG_partner_[a]) then
     ERROR(outside, ` does not have an associated metric`):
   elif Ndim[ grG_partner_[a]] < Ndim[a] then
     ERROR(`join requires the names of the surfaces, not full manifolds.`):
   fi:
 od:

 printf(`%a and %a are now joined.\n`, outside, inside):
 printf(`The default metric name is %a.\n`, outside):
 printf(`The exterior metric is: %a\n`, outside):
 printf(`The interior metric is: %a\n`, inside):

 grG_default_metricName := outside:
 grG_default_Mext := outside:
 grG_default_Mint := inside:
 grcalc(Jump[g(dn,dn)]);
 grdisplay(_):

 grG_join_[outside] := inside:
 grG_join_[inside] := outside:

 grG_join_[grG_partner_[outside]] := grG_partner_[inside]:
 grG_join_[grG_partner_[inside]] := grG_partner_[outside]:

end:

#************************************************
# ssave(sName, fileName)
#
# - save all the objects associated with a surface:
#     Sigma: g(dn,dn) x(up) K(dn,dn)
#         M: g(dn,dn) n(dn) n(up) xform(up) ntype x(up)
#
#************************************************

ssave := proc( sName, fileName)

global grG_default_metricName:

local  oldDefault, mFile, sFile:

 if not member(sName, grG_metricSet) then
   ERROR(`Cannot find `,sName):
 elif not assigned( grG_partner_[sName] ) then
   ERROR(sName, ` does not reference an enveloping spacetime.`):
 fi:

 # (use two files, one for M, one for Sigma, so we use grsaveobj)

 #
 # Save Manifold stuff to file.ju1
 #
 # use grsaveobj to save the values for the Enveloping space
 #
 oldDefault := grG_default_metricName:
 grG_default_metricName := grG_partner_[sName]:
 mFile := convert( fileName.`.ju1`, string):
 grsaveobj( g(dn,dn),x(up),xform(up),n(dn),u(up),
            udot(up),ntype,ndiv, mFile):
 appendto(mFile);
 printf(`Ndim[grG_metricName] := %d:\n`, Ndim[grG_default_metricName]):
 printf(`Ndim||grG_metricName := %d:\n`, Ndim[grG_default_metricName]):
 printf(`grG_totalVar_[grG_metricName] := %a:\n`,
           grG_totalVar_[grG_default_metricName]):
 printf(`grG_partialVars_[grG_metricName] := %a:\n`,
           grG_partialVars_[grG_default_metricName]):
 writeto(`terminal`):

 #
 # Save surface stuff to file.ju2
 #
 # for each object, set the metric name and any operands
 # grF_saveObj is a dummy function. Check for this fn name
 # in grcomponent.
 #
 grG_default_metricName := sName:
 sFile := convert( fileName.`.ju2`, string);
 grsaveobj( g(dn,dn), K(dn,dn), x(up), sFile);

 #
 # explicitly write out the constraints
 #
 appendto(sFile);
 lprint(`# additional stuff`);
 lprint(`grG_constraint[grG_metricName] :=`,
            grG_constraint[sName],`:`);

 lprint(`Ndim[grG_metricName] := `, Ndim[grG_default_metricName],`:`):
 lprint(`Ndim||grG_metricName := `, Ndim[grG_default_metricName],`:`):

 grG_default_metricName := oldDefault:

 writeto(`terminal`):
 printf(`Saved the spacetime %a in %s\n and surface %a in %s\n.`,
           grG_partner_[sName], mFile,  sName, sFile):

end:

#save `junction.m`:
#lprint(`Saved to ../lib/junction.m`);

