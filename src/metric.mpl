#
# Metric.mpl
#
# Command line metric creation
#
#$define DEBUG option trace;
$define DEBUG 

metric_params := {coord, ds, type, cons, bdn, bup, info};

hs_validate[type] := proc(name, stype)
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
      ERROR("Arguments must be equations. See ?hypersurf")
    elif not member(lhs(args[i]), hs_fields) then
      printf("attribute %a\n", lhs(args[i]));
      printf("Not in attriture list: %a\n", hs_fields);
      ERROR("Unknown attribute");
    else
      errString := hs_validate[lhs(args[i])](lhs(args[i]), rhs(args[i]));
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

metric := proc()
DEBUG
  local args_by_name, metricName, ndim; 
  global grG_hyperLoaded, grG_metricName, gr_data, Ndim, 
      grG_metricSet;

  #hs_load();


  metricName := args[1];
  if member( metricName, grG_metricSet) then
    ERROR(`The metric name `, metricName, ` is already in use.`):
  fi:
  args_by_name := hs_checkargs(args);

  ndim := nops(args_by_name[coord]):

  if assigned(args_by_name[ds]) then
    # metric is specified as a line element
    metric := grF_parse_ds( args_by_name[ds], args_by_name[coord]):
    grF_initg( ndim, metric, metricName)
  fi:

 end proc:

