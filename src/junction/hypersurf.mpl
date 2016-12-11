
#$define DEBUG option trace;
$define DEBUG 
#************************************************
# Input validators
#
# hypersurf routines can take input of the form:
#   type = <spacelike, timelike, null>
#   coord = [list of coordinates on the surface]
#   surf= <eqn of surface>
#   xform= [list of x{^a} = fn(xi{^a)}]
#   nup= list of components of n{^a} in x{^a}
#   ndn= list of components of n{a} in x{^a}
#************************************************

hs_fields := {type, coord, surf, xform, nup, ndn};

hs_validate[type] := proc(stype)
DEBUG
  local errorStr;

  if not member(stype, {spacelike, timelike, null}) then
    errorStr := "Please enter type as one of:  spacelike, timelike, null (no quotes)\n":
  else
    errorStr := "ok"; 
  fi:
  RETURN(errorStr):

end proc:

hs_validate[coord] := proc(coords)
DEBUG
  local errorStr;
  global grG_metricName;

  if not type(coords,list) then
    errorStr := "Please enter co-ords as a list (in [])\n":
  elif nops(coords) <> Ndim[grG_metricName]-1 then
    errorStr := sprintf("Number of co-ords is not %d\n", Ndim[grG_metricName]-1);
  else
    errorStr := "ok"; 
  fi:
  RETURN(errorStr):

end proc:

hs_validate[surf] := proc(coords)
DEBUG
  local errorStr;

  errorStr := "ok"; 
  RETURN(errorStr):

end proc:

hs_validate[xform] := proc(xform)
DEBUG
  local errorStr, eqn; 
  global grG_metricName, Ndim;

  errorStr := "ok"; 
  if not type(xform,list) then
    errorStr := "Please specify xforms as a list (in [])\n":
  elif nops(xform) <> Ndim[grG_metricName] then
    errorStr := sprintf("Number of xform entries is not %d\n", Ndim[grG_metricName]);
  else
    for eqn in xform do
      if not type(eqn, equation) then 
        errorStr := "Entries in xform must be equations coord = f(surface co-ordinates)";
        break;
      fi:
      # TODO: check LHS is a coord in space
    od:
  fi:
  RETURN(errorStr):

end proc:

hs_validate[nup] := proc(nup)
DEBUG
  local errorStr, eqn; 

  errorStr := "ok"; 
  if not type(nup,list) then
    errorStr := "Please enter n{^a} components as a list (in [])\n":
  elif nops(list) <> Ndim[grG_metricName] then
    errorStr := sprintf("Number of n{^a} entries is not %d\n", Ndim[grG_metricName]);
  fi:
  RETURN(errorStr):

end proc:

hs_validate[nup] := proc(ndn)
DEBUG
  local errorStr, eqn; 

  errorStr := "ok"; 
  if not type(nup,list) then
    errorStr := "Please enter n{a} components as a list (in [])\n":
  elif nops(list) <> Ndim[grG_metricName] then
    errorStr := sprintf("Number of n{a} entries is not %d\n", Ndim[grG_metricName]);
  fi:
  RETURN(errorStr):

end proc:

#--------------------------------------------
# hs_checkargs 
#--------------------------------------------
hs_checkargs := proc()
DEBUG
  local args_by_name; 

  # screen all the input attributes
  for i from 2 to nargs do
    if not type(args[i], equation) then
      printf("arg=%a\n", args[1]);
      ERROR("Arguments must be equations. See ?hypersurf")
    elif not member(lhs(args[i]), hs_fields) then
      printf("attribute %a\n", lhs(args[i]));
      printf("Not in attriture list: %a\n", hs_fields);
      ERROR("Unknown attribute");
    else
      errString := hs_validate[lhs(args[i])](rhs(args[i]));
      if errString <> "ok" then
         ERROR(errString);
      fi:
      args_by_name[lhs(args[i])] := rhs(args[i]):
    fi: 
  od:

  # check mandatory fields
  if not assigned(args_by_name[type]) then
    ERROR("Surface type must be specified by e.g. type=spacelike (or timelike or null)");
  fi:
  if not assigned(args_by_name[coord]) then
     ERROR("coordinates of the surface must be provided by coord=[<list of coords>] e.g coord=[theta,phi,tau]");
  fi:
  if not assigned(args_by_name[xform]) then
     ERROR("xform to coords on surface must be provided by xform=[<list of eqns>] e.g xform=[r=R(tau),theta=theta,phi,t=T(tau)]");
  fi:

  return args_by_name;

end proc:

#
# hyper-surface objects have common names u(up), n(up) that are sometimes used in 
# user-defined calculations. Rather than prohibiting these names in standard
# use check to see if they are defined before loading the hyper objects the first 
# time hyper is loaded
#

grG_hyperLoaded := false;

hs_load := proc()
  global grG_ObjDef;
  local hs_objects;

  if grG_hyperLoaded then
    RETURN;
  fi:
  #
  # check to see if any of the common vectors used in surfaces 
  # have been defined by the user in this session
  #
  hs_objects := [n(up), n(dn), u(up), u(dn), k(up), k(dn), N(up), N(dn)];
  for i in nops(hs_objects) do
    if assigned(grG_ObjDef[hs_objects[i]][grC_root]) then
       printf("grdef has been used to define %a. hypersurf needs to load a conflicting definition.\n,
            hs_objects[i]");
       printf("Please undefine with grundef()");
       ERROR("Conflicting definition in current session.");
    fi:
  od:

  # defined in build/griii.mpl 
  load_hypers_objects();
  grF_gen_rootSet():
  grF_gen_calcFnSet():

end proc:

#-------------------------------------------------
# hs_init_from_vector
# - init a vector from a list
#-------------------------------------------------

hs_init_from_vector := proc(vector, vlist)
DEBUG
  global gr_data, Ndim, grG_metricName, grG_ObjDef;
  local root;

  root := grG_ObjDef[vector][grC_root];

  if grF_assignedFlag(vector, test) then
    printf("The vector %a has already been assigned.\n", vector);
    ERROR("Vector already assigned");
  fi:
  for i to Ndim[grG_metricName] do
    gr_data[root, grG_metricName, i] := vlist[i]:
  od:
  grF_assignedFlag(vector, set):

end proc:


#################################################
# hypersurf()
# - allow a free form specification of the hyper-surface
#   with params of the form param=<stuff> so they can be
#   used in various combinations and any order
#
# Mandatory:
#   type, coord
#
# Configurations:
#
#################################################

hypersurf := proc()
DEBUG
  local args_by_name, sName, xform_rhs; 
  global grG_hyperLoaded, grG_metricName, gr_data, Ndim, 
      grG_metricSet;

  #hs_load();

  sName := args[1];
  if member( sName, grG_metricSet) then
    ERROR(`The metric name `, sName, ` is already in use.`):
  fi:
  args_by_name := hs_checkargs(args);
  printf("Surface is %s \n", args_by_name[type]):

  #....................................................
  # Setup a metric for the surface
  #....................................................
  #
  # link the surface to grG_metricName
  #
  grG_metricSet := grG_metricSet union {sName}:
  gr_data[partner_,sName] := grG_metricName:
  gr_data[partner_,grG_metricName] := sName:
  Ndim[sName] := Ndim[grG_metricName]-1:


  #....................................................
  # Set the surface tangent and normal type
  # timelike means normal is timelike
  #....................................................
  if args_by_name[type] = timelike then
    gr_data[ntype_, grG_metricName] := -1:
    gr_data[utype_, grG_metricName] := 1:
  elif args_by_name[type] = spacelike then
    gr_data[ntype_, grG_metricName] := 1:
    gr_data[utype_, grG_metricName] := -1:
  elif args_by_name[type] = null then
    # does this ever get used?
    gr_data[ntype_, grG_metricName] := 0:
    gr_data[utype_, grG_metricName] := 0:
  else
    # with arg checking should never happen
    ERROR("Unknown type of surface"):
  fi:

  #....................................................
  # assign the xform functions
  #....................................................
  for i to Ndim[grG_metricName] do
    xform_rhs[i] := rhs(args_by_name[xform][i]):
  od:
  hs_init_from_vector(xform(up), xform_rhs):

  #....................................................
  # Determine the normal vector 
  # - either explicitly provided or determined from surface eqn
  #....................................................
  if assigned(args_by_name[nup]) then
    hs_init_from_vector(n(up), args_by_name[nup]):
  elif assigned(args_by_name[ndn]) then
    hs_init_from_vector(n(dn), args_by_name[ndn]):
  elif assigned(args_by_name[surf]) then
    gr_data[surface_, grG_metricName ] := args_by_name[surf]:
    grF_assignedFlag(surface, set);
    grcalc(n(dn));
  fi:
  grdisplay(n(dn));

  #....................................................
  # assign the coords on the surface 
  #....................................................
  grmetric(sName):
  hs_init_from_vector(x(up), args_by_name[coord]):

  #....................................................
  # Determine the metric on the surface
  #....................................................
  # precalc for gdndn has special code to use ff1 if there is a partner
  # spacetime
  grcalc( g(dn,dn)): 
  #
  # naughty, but explicitly calc ds (since if goes through normal
  # it gets messy and this is best work around)
  #
  gr_data[ds_,sName] := grF_calc_ds(ds,[]):
  grF_assignedFlag(ds, set);
  grdisplay(ds);

end proc: