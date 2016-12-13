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






#************************************************
# surf( metric, grG_metricName, surface)
#
# metric - Name of metric to embed the surface in
#
# grG_metricName  - name of spacetime <metric> in terms of
#          the coordinates of the surface
#
# surface- name of the surface manifold
#
# - prompt for the necessary info to make a surface
#
#************************************************

grsurface := proc()
#option trace;
local a, b, c, s, defList, useC, object, affine, c_rhs,
      c_eqn, elim, mate, response, sCoords, traceValue,
      reply, Ncompts, lapse, errString, inputOk, metricName, sName;

global grG_metricSet, grG_metricName, grG_ObjDef,
       Ndim, gr_data, grG_constraint,
       grOptionTrace, jfields;

  readlib(freeze): # used in project

  metricName := args[1];
  sName := args[2];
  # verify that a minimal set of input attributes has been provided


  grG_metricName := metricName:

  if not member(metricName, grG_metricSet) then
    ERROR(`The metric `,metricName, ` has not been loaded.`):
  elif member( sName, grG_metricSet) then
    ERROR(`The metric name `,sName, ` is already in use.`):
  fi:

  #
  # check if this spacetime has a surface associated with it already.
  # If so we cannot proceed since xform, u(up) etc. are all tied into M
  #
  if assigned( gr_data[partner_,metricName]) then
     printf("Surface %a is already associated\n", gr_data[partner_,metricName]):
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
  # link the surface to grG_metricName
  #
  grG_metricSet := grG_metricSet union {sName}:
  gr_data[partner_,sName] := grG_metricName:
  gr_data[partner_,metricName] := sName:

  #
  # SURFACE COORDS
  #
  s := sprintf(`\n COORRDINATES: Enter the coordinates of the surface as a list\n`);
  s := cat(s, sprintf(`   e.g. [theta, phi, tau]; \n`));
  s := cat(s, sprintf(`   Enter a list >`));

  sCoords := 0;
  errString := "";
  inputOk := false;
  while not inputOk do
    sCoords := grF_input(s, [], `junction`):
    if not type(sCoords,list) then
      errorStr := "Please enter co-ords as a list (in [])\n":
    elif Ndim[sName] != Ndim[metricName]-1 then
      errorStr := sprintf("Number of co-ords is not %d\n", Ndim[metricName]-1);
    else
      inputOk := true; 
    fi:
  od:
  Ndim[sName] := nops(sCoords):

  # assign coordinates
  for a to Ndim[sName] do
    gr_data[xup_,sName,a] := sCoords[a]:
  od:
  grG_metricName := sName:
  grF_assignedFlag(x(up),set);

  #
  # TOTAL DERIV
  #
  gr_data[totalVar_,grG_metricName] := [];
  s := sprintf(`\n SHELL PARAMETER:\n`);
  s := cat(s, sprintf(`   For a one-parameter shell, enter the parameter name.\n`)):
  s := cat(s, printf(`   For a null shell indicate which coordinate is a null generator\n`));
  s := cat(s, printf(`   Enter coordinate name or 0 (zero) for none >`));
  while not type(gr_data[totalVar_,grG_metricName],{name,integer}) do
    gr_data[totalVar_,metricName] := grF_input(s, 0, `junction`):
    gr_data[totalVar_,sName] := gr_data[totalVar_,metricName]:
  od:
  grJ_totalVar := gr_data[totalVar_,grG_metricName]: # used by jdiff and various definitions


  #
  # COORDINATE RELATIONS
  #
  # Enter the coordinate relations. These are used in the
  # routine unleash.
  # (i.e. we need expressions like r=R(tau) to eliminate references
  #       to the enveloping spacetimes for quantities on the
  #       surface)
  #
  grG_metricName := metricName:
  grcalc( xform(up)):
  grG_metricName := sName:

  #
  # determine if the normal is TL, SL or Null (calculate
  # the normal with simplify as the alteration function)
  #

  s := sprintf(`\n NORMAL TYPE: Please indicate the nature of the normal vector\n`);
  s := cat(s, sprintf(`   (-1 = timelike, 0 = null, 1= spacelike)`));
  s := cat(s, sprintf(` Enter +1,0 or -1 >`));
  # TODO - check input
  gr_data[ntype_,metricName] := grF_input(s , 1, `junction`):
  gr_data[utype_,metricName] := -1*gr_data[ntype_,metricName]:

  #
  # SURFACE CONSTRAINT -> becomes GRT constraint
  #
  # Indicate the Lagrangian equation, and prompt for the
  # req'd info
  #
  useC := 0:
  if gr_data[totalVar_,grG_metricName] <> 0 then
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
    for a to Ndim[grG_metricName] do
      for b to Ndim[grG_metricName] do
       c_rhs := c_rhs + gr_data[gdndn_,grG_metricName,a,b] *
                gr_data[uup_,grG_metricName,a] * gr_data[uup_,grG_metricName,b]:
      od:
    od:
    c_eqn := -1*gr_data[ntype_,grG_metricName] = normal(c_rhs):
    if not type(rhs(c_eqn), numeric) then
      print(`The constraint equation is:`);
      print( c_eqn);
      grG_constraint[grG_metricName] := grG_constraint[sName]:
      grG_constraint[sName] := [c_eqn]:
      grFc_mod_constraint( constraint, sName):
      grG_constraint[sName] := [op(grG_constraint[sName]),
		      seq( gr_data[xup_,grG_metricName,a] =
		      gr_data[xformup_,grG_metricName,a],a=1..Ndim[grG_metricName]) ]:
    else
      #
      # need this for explicit subs in junction
      #
      grG_constraint[grG_metricName] := []:
      grG_constraint[sName] := [seq( gr_data[xup_,grG_metricName,a] =
		gr_data[xformup_,grG_metricName,a],a=1..Ndim[grG_metricName]) ]:
      printf(`The rhs of the constraint equation is numeric\n`);
      printf(`and hence has no new information.\n`);
    fi:
  else
    grG_constraint[grG_metricName] := []:
    grG_constraint[sName] := [seq( gr_data[xup_,grG_metricName,a] =
		    gr_data[xformup_,grG_metricName,a],a=1..Ndim[grG_metricName]) ]:
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
  if gr_data[surface_,metricName] = 0 then
     s := `NORMAL VECTOR: Enter the components of the normal vector\n`;
     grJ_getComponents( s, metricName, n);
  fi: # null shell

  #
  # get the normal vector sign
  #
  s := sprintf(`\n NORMAL SIGN\n`);
  s := cat(s, sprintf(`   The definition of the normal vector is +/- grad(surface)\n`));
  s := cat(s, sprintf(`   please enter +1 or -1 to indicate the CHOICE of sign\n`));
  gr_data[nsign_,grG_metricName] := grF_input(s, 1, `junction`):


  #
  # NULL SURFACE: get the Lapse vector (either covariant or
  # contravariant)
  #
  if gr_data[ntype_,metricName] = 0 then
     s := `TRANSVERSE VECTOR\n`;
     grJ_getComponents( s, metricName, N):
  fi: # null shell

  #
  # CALCULATE THE SURFACE METRIC
  #
  # calculate g{i j}  n(dn)
  #
  grcalc( n(dn));

  # switch to surface
  grmetric(sName):
  # precalc for gdndn has special code to use ff1 if there is a partner
  # spacetime
  grcalc( g(dn,dn)): 
  #
  # naughty, but explicitly calc ds (since if goes through normal
  # it gets messy and this is best work around)
  #
  gr_data[ds_,sName] := grF_calc_ds(ds,[]):
  grF_assignedFlag(ds, set);
  #
  # ask if we can calculate g(up,up) for a null shell by inverting
  # the two metric
  #
  if gr_data[ntype_,metricName] = 0 and gr_data[totalVar_,metricName] <> 0 then
    s := sprintf(`\n nullg(up,up): Calculate nullg(up,up) automatically?\n`);
    s := cat(s, sprintf(`   (If N is orthogonal to those basis vectors on\n`));
    s := cat(s, sprintf(`    the surface which are *not* the null\n`));
    s := cat(s, sprintf(`    generator of the surface)\n`));
    s := cat(s, sprintf(`   y/n`\n));
    if grF_input(s, "y", `junction`) = 'y' then
       grcalc(nullg(up,up) );
    fi:
  fi:
  if gr_data[ntype_,metricName] = 0 then
    s := sprintf(` l{^a}: Enter the components for l{^a}\n`);
    s := cat(s, sprintf(`   y/n`\n));
    if grF_input(s, "y", `junction`) = 'y' then
       grJ_getComponents( s, sName, l);
    fi:
  fi:


  #
  # now display the result
  #
  grG_metricName := sName:
  grdisplay(surface[metricName],xform[metricName](up),ds);

  grOptionTrace := traceValue:

  printf(`The intrinsic metric and normal vector have been calculated.\n`);
  printf(`You may wish to simplify them further before saving the surface\n`);
  printf(`or calculating K(dn,dn) \n`);

end:

grJ_getComponents := proc(vec_prompt, metricName, vect)
    global gr_data, Ndim, grG_metricName;
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
      s := cat( s, sprintf(`%a`, gr_data[xup_,metricName,a]));
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
       gr_data[vect||updn||_,metricName, a] := op(a, Ncompts);
    od:
    print ( vect(updn) );
    grF_assignedFlag ( vect(updn), set, metricName ):

end:

#************************************************
# sload( metric, sName, fileName)
#
#************************************************

#sload := proc( metric, sName, fileName)
#
#global grG_metricSet, gr_data, grG_metricName:
#
#local mFile, sFile:
#
# if member( metric, grG_metricSet) then
#   ERROR(`Metric name `, metric, ` is already in use.`);
# elif member( sName, grG_metricSet) then
#   ERROR(`Metric name `, sName, ` is already in use.`);
# fi:
#
# grG_metricSet := grG_metricSet union {metric,sName}:
# gr_data[partner_,metric] := sName:
# gr_data[partner_,sName] := metric:
# mFile := convert( fileName.`.ju1`, string):
# grloadobj( metric, mFile):
# grG_metricName := metric:
# gr_data[ds_,metric] := grF_calc_ds(ds,[]):
# grdisplay(ds);
# sFile := convert( fileName.`.ju2`, string):
# grloadobj( sName, sFile):
# grG_metricName := sName:
# gr_data[ds_,sName] := grF_calc_ds(ds,[]):
# grdisplay(ds);
# printf(`The default metric is now %a\n`, sName);
#
#end:

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
   elif not assigned( gr_data[partner_,a]) then
     ERROR(outside, ` does not have an associated metric`):
   elif Ndim[ gr_data[partner_,a]] < Ndim[a] then
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

 gr_data[join_,outside] := inside:
 gr_data[join_,inside] := outside:

 gr_data[join_,gr_data[partner_,outside]] := gr_data[partner_,inside]:
 gr_data[join_,gr_data[partner_,inside]] := gr_data[partner_,outside]:

end:

#************************************************
# ssave(sName, fileName)
#
# - save all the objects associated with a surface:
#     Sigma: g(dn,dn) x(up) K(dn,dn)
#         M: g(dn,dn) n(dn) n(up) xform(up) ntype x(up)
#
#************************************************

#ssave := proc( sName, fileName)
#
#global grG_default_metricName, gr_data, Ndim:
#
#local  oldDefault, mFile, sFile:
#
# if not member(sName, grG_metricSet) then
#   ERROR(`Cannot find `,sName):
# elif not assigned( gr_data[partner_,sName] ) then
#   ERROR(sName, ` does not reference an enveloping spacetime.`):
# fi:
#
# # (use two files, one for M, one for Sigma, so we use grsaveobj)
#
# #
# # Save Manifold stuff to file.ju1
# #
# # use grsaveobj to save the values for the Enveloping space
# #
# oldDefault := grG_default_metricName:
# grG_default_metricName := gr_data[partner_,sName]:
# mFile := convert( fileName.`.ju1`, string):
# grsaveobj( g(dn,dn),x(up),xform(up),n(dn),u(up),
#            udot(up),ntype,ndiv, mFile):
# appendto(mFile);
# printf(`Ndim[grG_metricName] := %d:\n`, Ndim[grG_default_metricName]):
# printf(`Ndim[grG_metricName] := %d:\n`, Ndim[grG_default_metricName]):
# printf(`gr_data[totalVar_,grG_metricName] := %a:\n`,
#           gr_data[totalVar_,grG_default_metricName]):
# printf(`gr_data[partialVars_,grG_metricName] := %a:\n`,
#           gr_data[partialVars_,grG_default_metricName]):
# writeto(`terminal`):
#
# #
# # Save surface stuff to file.ju2
# #
# # for each object, set the metric name and any operands
# # grF_saveObj is a dummy function. Check for this fn name
# # in grcomponent.
# #
# grG_default_metricName := sName:
# sFile := convert( fileName.`.ju2`, string);
# grsaveobj( g(dn,dn), K(dn,dn), x(up), sFile);
#
# #
# # explicitly write out the constraints
# #
# appendto(sFile);
# lprint(`# additional stuff`);
# lprint(`gr_data[constraint,grG_metricName] :=`,
#            gr_data[constraint,sName],`:`);
#
# lprint(`Ndim[grG_metricName] := `, Ndim[grG_default_metricName],`:`):
# lprint(`Ndim[grG_metricName] := `, Ndim[grG_default_metricName],`:`):
#
# grG_default_metricName := oldDefault:
#
# writeto(`terminal`):
# printf(`Saved the spacetime %a in %s\n and surface %a in %s\n.`,
#           gr_data[partner_,sName], mFile,  sName, sFile):
#
#end:

