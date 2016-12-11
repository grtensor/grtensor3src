#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: project (the verb not the noun)
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: July 28, 1994
#
# Contains: unleash + support
#
#
# Revisions:
#
# Aug  6, 1994  unleash_Diff now does Diff( x, r(tau)) -> Diff(x,r)
#
# Dec 12, 1994  Add do_unchain parameter
#
# April 12, 1995 Remove all references to unchain and partial Vars
#                (leave in a dummy fourth arg for now so we can 
#                 go back to unchain if we have to)
#
# Aug   8, 95  Change to project. Allow diff( blah, r) to stay
#              inactive instead of causing diff( blah, R(tau) )
#
# Oct   5, 95  Major changes to protecting diff's prior to subs
#
# Oct  12, 95  Bug fix to above.
#
# Oct  30, 95  Fix bug in projecting mixed partials with one
#	       bad variable (depending on order could get 0 back)
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


#-------------------------------------------------
# juncF_project(expr, metricName, surfaceName)
#
# convert all coordinates to intrinsic coordinates
# by using the xform(up) values
#
# Then allow any Diff's w.r.t. the total deriv variable
# to change to active form.
#
# We get caught in a catch-22 here since we given a
# term like diff( T(tau), tau$2) we need to put in the
# diff(T(tau), tau) from the constraint and realize
# that some of the resulting
#-------------------------------------------------

juncF_project := proc(expr, gname, sName)
#
# gname: Manifold
# sname: surface
#
#option trace;
local newExpr, a, holdXform:

global grJ_badVars, grJ_holdCoords, grJ_badFuns, grJ_badValues, 
  grG_constraint, gr_data, Ndim:

  if Ndim[gname] < Ndim[sName] then
     ERROR(`Metric names backwards`):
  fi:
  newExpr := expr;
  #
  # assign to grJ_badVars the names of those coordinates
  # which have a non-trivial projection onto the surface
  #
  # We want to leave e.g. diff( u(r), r) in this form if
  #  r= R(tau). To do this we first build a sequence
  # of "bad coordinates" (those whose transformations are not
  # to names).
  #  
  # Functions in derivatives involving bad coordinates are
  # detected in juncF_diff which changes the derivative from 
  # diff to Diff
  #
 
  grJ_badVars := NULL;
  grJ_badValues := NULL:
  grJ_holdCoords := NULL;  # seq. of e.g. r = grJ_hold1
  for a to Ndim[gname] do 
     #
     # those coordinates which do not transform into
     # a name will cause problems if arbitrary functions
     # of those coordinates exist in the metric
     #
    if not type(gr_data[xformup_,gname,a], name) then
       grJ_badVars := grJ_badVars, gr_data[xup_,gname,a]:
       # keep a parallel seq with the bad value
       grJ_badValues := grJ_badValues, gr_data[xformup_,gname,a]:
    fi:
  od:

  # 
  # if we have diff( u(r,theta), r), r) and r= R(tau) then
  # the a naive projection produces diff( u(R(tau), theta), R(tau))
  # which is an *error* in Maple (diff by a function).
  #
  # In these cases we want to leave the diff by r, but make the
  # derivative inactive (i.e. Diff). 
  #
  # In addition we may have diff( diff( T(tau), tau), tau) where
  # dif(T(tau) , tau) contains functions like u(r,theta).
  # Here we will get D[1](u)(R(tau), theta) arising naturally
  #
  grJ_badFuns := NULL:
  newExpr := eval( subs( diff=juncF_diff, Diff=juncF_Diff, expr));

  if assigned( grG_constraint[sName]) then
      #
      # use the u{a} u{^a} constraint plus the coordinate
      # transformations (all of which are in the surface constraint list)
      #
      # (do it twice since u{a} u{^a} may involve terms which need 
      # subbing into etc.)
      #
      newExpr := subs(grG_constraint[sName],newExpr):
      newExpr := eval(subs(grG_constraint[sName],newExpr));

      #
      # as a result of evaluating some D(F)(R(tau)) 's will have crept
      # in for consistency we need to convert these to inert Diff's.
      # Before we do that we need to hold all the diff's so they
      # don't get hit by this.
      #
      # Since the diff by is an argument we'll end up with &where's
      # so we need to use these to switch things back to the
      # "normal form" we desire.
      #
      newExpr :=  subs( diff= juncF_diffFreeze, newExpr);
      newExpr :=  eval(subs( diff= juncF_diffFreeze, newExpr));
      newExpr :=  eval( subs( `&where` = juncF_where, convert( newExpr, Diff)));
      #
      # now we want to convert the inactive Diff's to diff but
      # we have frozen some diff's of the form diff( f(r), r)
      # when in fact we might have r=R(t). If we don't do something
      # about this then subsequent t derivatives would give 0 (wrong)
      # So some of the inert Diff's will get converted to D(f)(R(t))
      # 
      # Why no just use D's throughout? Cause it offends my sense of aesthetics!
      #
      newExpr := eval( subs( holdDiff = diff, Diff=juncF_unDiff, thaw( eval(thaw(newExpr))) ));
      #
      # use the coordinate relations on last time so that D(f)(r) -> D(f)(R(t))
      #
      newExpr := eval( subs(grG_constraint[sName],newExpr) ):
  fi:
  RETURN(newExpr);
end:

#-------------------------------------------------
# juncF_diff
#
# in a function such as diff( u(r,theta), r)
# if r will project to something
# which is not a name then wrap the coordinate in 
# a juncF_holdCoord (using coordinate number as an
# argument so that it's immune to the projection
# substitutions.)
#
#-------------------------------------------------

juncF_diffFreeze := proc(a,b)

   holdDiff( freeze(a), freeze(b) );

end:

juncF_diff := proc( a, b)

global grJ_badVars, grJ_holdCoords, grJ_addCoords:

local newOps, i;

  if member(b, {grJ_badVars}) or thaw(a) <> a then
      #
      # why the thaw(a) clause ? Because...
      # if the operand is already frozen then we can't
      # let any of the outer diffs go through (since
      # we'll get trivial zeros)
      #         
      RETURN( freeze( Diff( a, b)) );
  else
      RETURN( diff(a,b) );
  fi:

end: 
#-------------------------------------------------
# juncF_Diff
#
# a Diff( F,r) must not become a Diff( F,R(tau) ) so we
# freeze these before applying coordinate substitutions
#
#--------------------------------------------------

juncF_Diff := proc(a,b) freeze( Diff(a,b) ); end:

#-------------------------------------------------
# juncF_unDiff
#-------------------------------------------------

juncF_unDiff := proc( a,b)

global grJ_badVars, grJ_coordXforms;

local retVal;

  if member( b, {grJ_badVars}) then
     retVal := convert( Diff(a,b), D):
  else
     retVal := diff(a,b);
  fi:

 retVal;

end:

#-------------------------------------------------
# juncF_where
#
#--------------------------------------------------


juncF_where := proc( expr, value)
#
# typical call is where( 2*Diff( f(t1), t1), { t1 = R(tau) });
#

local badValue, badVar, a, b, newExpr:

 newExpr := expr:
 for b to nops(value) do
  badValue := rhs(value[b]):
  #
  # find the coordinate name corresponding to the bad value
  #
  if not member( badValue, {grJ_badValues}) then 
     ERROR(`Internal error - cannot find bad value`);
  fi:
  for a to nops([grJ_badValues]) do
    if badValue = op(a,[grJ_badValues]) then
       badVar := op(a, [grJ_badVars]):
       break;
    fi:
  od:
  newExpr := subs( lhs(value[b]) = badVar, newExpr); 
 od:
 newExpr:
end:
