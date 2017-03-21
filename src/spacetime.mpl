#
# Spacetime.mpl
#
# Command line metric creation
#
$undef DEBUG
#$define DEBUG option trace;
$define DEBUG 

metric_params := {coord, ds, type, cons, info};

allowed_symbols := {edn, eup, g, l, n, m, mbar};

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

# used for any of allowed symbols
metric_validate[symbol] := proc(pname, stype)
DEBUG
  local errorStr;
  local s;

  errorStr := "ok"; 
  # get root symbol name
  if type(op(0,name), symbol) then 
  	s := op(0, pname);
  	if not member(s, allowed_symbols) then
  		errorStr := "Symbol not recognized: "||s; 
  	fi:
  else
  	errorStr := "Could not get root name for "||op(0,pname):
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
  args_by_name[indexed] := []; 

  for i from 2 to nargs do
    if not type(args[i], equation) then
      printf("arg=%a\n", args[i]);
      ERROR("Arguments must be equations. See ?metric")
    elif type(lhs(args[i]), indexed) then
      #
      # could be a metric, basis, eta or NP entry
      # indexed entries are added to the indexed list and treated as 
      # a standard argument
      #
      errString := metric_validate[symbol](lhs(args[i]), rhs(args[i]));
      if errString <> "ok" then
         ERROR(errString);
      fi:
      args_by_name[indexed] := [op(args_by_name[indexed]), lhs(args[i])];
      args_by_name[lhs(args[i])] := rhs(args[i]):
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
# grF_parse_g
# Extract the metric elements from the arg list
# and put in an array. 
#--------------------------------------------

grF_parse_g := proc(args_by_name)
DEBUG
local c, cnum, coordNum, entry, indexList, gdim, metricArray; 

  gdim := nops(args_by_name[coord]):

  # build a list of coord -> num
  cnum := 1;
  for c in args_by_name[coord] do
    coordNum[c] := cnum:
    cnum := cnum + 1;
  od:

  metricArray := array(1..gdim,1..gdim,[seq([seq(0,i=1..gdim)],i=1..gdim)]);

  for entry in args_by_name[indexed] do
    if nops(entry) <> 2 then
      ERROR( "entry" || entry || " does not have 2 arguments"):
    fi:
    # get number of entry in list
    indexList := [];
    for index in op(entry) do
      if not member(index, args_by_name[coord]) then
         ERROR("Unknown co-ordinate " || index || " not in " || args_by_name[coord]);
      fi:
      indexList := [op(indexList), coordNum[index]]:
    od:
    metricArray[op(indexList)] := args_by_name[entry]:
  od:

  RETURN(metricArray):

end proc:

#--------------------------------------------
# spacetime
#--------------------------------------------

spacetime := proc()
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

  elif nops(args_by_name[indexed]) > 0 then
    #
    # extract the metric from arguments
    #
    metricArray := grF_parse_g(args_by_name):
    grF_initg( ndim, metricArray, metricName)
  fi:

  # assign the co-ords
  grG_default_metricName := grG_metricName:
  for i to ndim do
	    gr_data[xup_,grG_metricName,i] := args_by_name[coord][i]:
  od:
  grF_assignedFlag ( x(up), set, grG_metricName ):
  grG_metricSet := {ops(grG_metricSet), metricName};

  grcalc(ds);
  grdisplay(ds):

 end proc:

$undef DEBUG
