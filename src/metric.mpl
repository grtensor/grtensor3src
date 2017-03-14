#
# Metric.mpl
#
# Command line metric creation
#
$undef DEBUG
#define DEBUG option trace;
$define DEBUG 

metric_params := {coord, ds, type, cons, bdn, bup, info};

metric_validate[type] := proc(name, stype)
DEBUG
  local errorStr;
  local validTypes;

  valifTypes := {metric, basis, NP};

  if not member(stype, validTypes) then
    errorStr := "Please enter type as one of: " || validTypes || "\n":
  else
    errorStr := "ok"; 
  fi:
  RETURN(errorStr):

end proc:

metric_validate[coord] := proc(name, stype)
DEBUG
  local errorStr;
  local validTypes;

  if not type(stype, list) then
    errorStr := "Please enter co-ordinates as a list: e.g. coord=[t,r,theta,phi]":
  else
    errorStr := "ok"; 
  fi:
  RETURN(errorStr):

end proc:

metric_validate[ds] := proc(name, stype)
DEBUG
  local errorStr;
  local validTypes;

  # grF_parse_ds will do error checking
  errorStr := "ok"; 
  RETURN(errorStr):

end proc:

#--------------------------------------------
# metric_checkargs 
#--------------------------------------------
metric_checkargs := proc()
DEBUG
  local args_by_name; 

  # screen all the input attributes
  # first arg is the metric name


  for i from 2 to nargs do
    if not type(args[i], equation) then
      printf("arg=%a\n", args[i]);
      ERROR("Arguments must be equations. See ?metric")
    elif not member(lhs(args[i]), metric_params) then
      printf("parameter %a\n", lhs(args[i]));
      printf("Not in parameter list: %a\n", metric_params);
      ERROR("Unknown parameter");
    else
      errString := metric_validate[lhs(args[i])](lhs(args[i]), rhs(args[i]));
      if errString <> "ok" then
         ERROR(errString);
      fi:
      args_by_name[lhs(args[i])] := rhs(args[i]):
    fi: 
  od:

  # check mandatory fields
  if not assigned(args_by_name[coord]) then
     ERROR("coordinates of the surface must be provided by coord=[<list of coords>] e.g coord=[t,r,theta,phi]");
  fi:

  return args_by_name;

end proc:

#--------------------------------------------
# metric
#--------------------------------------------

metric := proc()
DEBUG
  local args_by_name, metricName, metricArray, ndim; 
  global grG_default_metricName, grG_metricName, gr_data, Ndim, 
      grG_metricSet;


  metricName := args[1];
  if member( metricName, grG_metricSet) then
    ERROR(`The metric name `, metricName, ` is already in use.`):
  fi:
  args_by_name := metric_checkargs(args);

  ndim := nops(args_by_name[coord]):
  printf("ndim=%a\n", ndim):

  if assigned(args_by_name[ds]) then
    # metric is specified as a line element
    metricArray := grF_parse_ds( args_by_name[ds], args_by_name[coord]):
    grF_initg( ndim, metricArray, metricName)
  fi:

  # assign the co-ords
  grG_default_metricName := grG_metricName:
  for i to ndim do
	gr_data[xup_,grG_metricName,i] := args_by_name[coord][i]:
  od:
  grG_metricSet := {ops(grG_metricSet), metricName};

  grdisplay(ds):

 end proc:

$undef DEBUG
