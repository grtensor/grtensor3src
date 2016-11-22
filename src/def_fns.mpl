#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE:
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#
# Purpose: Functions which can be used in the definition of
#          tensor formulae in grdefine().
#
# CoD
# Geod
# grF_preEnterComp
# grF_enterComp
# Sym
#
# Revisions:
#
# Jan  1 1994    Added LieD
# Jun 25 1994    Removed LieD (use LieD[] operator instead)
# Aug  6 1994    use dispStr3
# Oct 25 1995    Add symLists to Sym/Asym [pm]
# Sep 16 1997    Removed R3 type specifiers in proc headers [dp]
# Aug 18 1999    Switched readstat and grF_my_readstat to grF_readstat [dp]
# Aug 20 1999   Changed use of " to ` for R4 compatibility [dp]
#
#################################################


#-----------------------------------
# Tdiff_( expr, operator, operand)
#
# Either Tdiff_( expr, CoD, index)
#     or Tdiff_( expr, LieD, vector)
#
# Routine for `generic` tensor differentiation
# Does map and chain rule. Calls a operator
# specific routine grF_.operator when it gets
# a Tensor_, DIFF, or function to work on
#-----------------------------------

Tdiff_ := proc( expr, diffOp, operand)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, newExpr:
 #
 # what have we been passed ?
 # If it's a: `+` -> map
 #            `*` -> chain rule
 #            Tensor -> get down to work
 #            function -> get down to buisiness
 #
 if type(expr, function) then
   #
   # is it a Tensor ? DIFF ?   If so then get down to work
   #
   if member( op(0,expr), {Tensor_}) then
	 #
	 # parse (to generate the index lists) and then
	 # do the diffOp specific part
	 #
	 grF_parse( expr):
	 grF_||diffOp( expr, operand, true);

   elif member( op(0,expr), {DIFF}) then
      ERROR(`CoD of DIFF not coded yet`):

   else
	 #
	 # must be some scalar function
	 #
	 grF_||diffOp( expr, operand, false);
   fi:

 elif type( expr, name) then
	 grF_||diffOp( expr, operand, false);

 elif type( expr, {`+`} ) then
   map(procname, expr, diffOp, operand);

 elif type( expr, `*`) then
   #
   # chain rule
   #
   newExpr := 0;
   for a to nops(expr) do
	 newExpr := newExpr +
		subsop(a=Tdiff_(op(a,expr),diffOp,operand), expr);
   od:

### WARNING: note that `I` is no longer of type `^`
 elif type( expr, `^`) then
   #
   # don't apply to the exponent
   #
   ERROR(`Exponent encountered in Tensor differentation`):
 elif type( expr, numeric) then
   0;
 else
   ERROR(`Unknown object in Tdiff_`=op(0,expr) ):
 fi:

end:

#-----------------------------------
# grF_CoD
#
# Called when Tdiff_ encounters some
# Tensor_, DIFF or scalar.
#
# Take the covariant derivitive. Parse has
# been called prior to this, so use the index
# lists set by parse.
#
#-----------------------------------

grF_CoD := proc(expr, index, isTensor)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;

global  grG_CoD_count;
local a,  dummy, newExpr; # x is intentially global (Tensor name)

 if isTensor then
    #
    # add a cdn to the index list
    #
    newExpr := Tensor_( op(1,expr), [op(op(2,expr)),cdn],
                    [op(op(3,expr)),index], op(4,expr) ):

 else
    newExpr := DIFF( expr, Tensor_( x, [up], [index], 0));
 fi:

 newExpr;

end:

#--------------------------------------
# grF_checkExplicitIndex
# - find coord number for the specified coord name
#--------------------------------------

grF_checkExplicitIndex := proc(metric, coord)
local num,a:
global grG_metricName, gr_data:

  if not assigned(grG_metricName) then
    RETURN('grF_checkExplicitIndex'(metric,coord));
  fi:
  # if coord is already an integer then life is easy
  if type( coord, integer) then RETURN(coord): fi: 
  num := 0:
  for a to Ndim[metric] do
    if gr_data[xup_,metric,a] = coord then
       num := a:
       break:
    fi:
  od:
  if num = 0 then
    printf("type=%a\n", whattype(coord));
    ERROR(`Explicit coordinate `||coord||` not found in metric `||metric);
  fi;
  num;
end:



#--------------------------------------
# grF_preEnterComp
# - just print a buncha stuff
#--------------------------------------

grF_preEnterComp := proc( object)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
  printf ("\nEnter components for object %a\n", object);
  printf ("  If you wish to quit at any point and leave this object\n");
  printf ("  uninitialized, enter the string exit.\n");
end:

#--------------------------------------
# grF_enterComp
# - enter a single component of a tensor
#--------------------------------------

grF_enterComp := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local result, prompt:
  if iList <> [] then
    print(grF_dispStr3(object, iList, false));
  else
    print(object):
  fi:
  cList := map( grF_coordName, iList):
  prompt := sprintf("Enter component %a:", cList);
  result := eval (grF_input (prompt, [], `grcalc`));
  if result = `oops` or result = `exit` then
	 # add to record, so grclear() will clear it
         grF_assignedFlag(object, set);
	 grclear(grG_metricName, object);
	 ERROR(`Calculation aborted`);
  fi:
  result;
end:

#-------------------------------------------------------------------
# Map function to get coordinate name (used in Maplet prompt)
#-------------------------------------------------------------------
grF_coordName := proc( index)
# index - number of the entry in the coord list
global grG_metricName, gr_data;
  return gr_data[xup_, grG_metricName, index];
end proc:

#--------------------------------------
# Symmetrize and Antisymmetrize
#
# grG_symList must be init'd to a null list before
# using this
#--------------------------------------

Sym := proc(a, b)
global grG_symList;
  grG_symList := [ op(grG_symList), a]:
  grF_symGuts(a, b, 0);

end:

Asym := proc(a, b)
global grG_asymList;

  grG_asymList := [ op(grG_asymList), a]:
  grF_symGuts(a, b, 1);

end:

#--------------------------------------
# grF_symGuts(iType, expr, flag)
# - symmetrize over the indices in iList.
#     flag = 1 indicates asym, else sym.
#--------------------------------------

grF_symGuts := proc( iList, expr, mode)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
local a, b, s, psign, pList, dummy, newExpr, dumExpr;

newExpr := expr:        # make a modifiable copy
#
# now create a sum with the indices shifted around
# - then generate the perm lists and add a term for each
# entry in the perm list (but use a dummy name to avoid
# stuff like a=b b=c etc.)
# - finally revert the indices to their original names
#
array( dummy, 1..nops(iList) ):
dumExpr := expr:     # expression with dummy's subbed in
for a to nops(iList) do
 dumExpr := subs( iList[a] = dummy[a], dumExpr):
od:

psign := 1;

s := 0:
pList := combinat[permute](iList):
for a in pList do
  newExpr := dumExpr:
  for b to nops(iList) do
	newExpr := subs( dummy[b] = a[b], newExpr);
  od:
  if mode = 1 then
	 psign := grF_permSign( iList, a):
  fi:
  s := s + psign * newExpr:
od:

for a to nops(iList) do
  s := subs( dummy[a] = iList[a], s):
od:

# return the resulting expression (divided by n! of course)
s/nops(iList)!;
end:




