#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: chain
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: July 18, 1994
#
#
# Purpose: Chain rule for derivatives adapted to the
#          needs of GRTensor II
#
# Revisions:
#
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#-------------------------------------------------
# chain( expr, diffBy, excludeList)
#
# Take a derivative, but use the chain rule to expand
# any functions of variables not in the chain list.
#
# This requires the introduction of new functions.
#
# i.e. chain( r-r(tau,lambda), t, [ [t,[tau,lambda]] ])
#        -> diff(r(tau,lambda),tau)/diff(t(tau,lambda),tau)
#           + diff(r(tau,lambda),lambda)/diff(t(tau,lambda),lambda)
#
#-------------------------------------------------

chain := proc( expr, diffBy, chainList)

local a, b, newExpr, varSeq;

 for a to nops(chainList) do
   if chainList[a][1] = diffBy then
     #
     # chain
     #
     newExpr := 0:
     varSeq := op(chainList[a][2]): # e.g. tau,lambda
     for b in chainList[a][2] do
       newExpr := newExpr + diff(expr,b)/diff( diffBy(varSeq),b):
     od:
     RETURN( newExpr):
   fi:
 od:

 diff( expr, diffBy):

end:




# i.e.  d/dr -> dtau/dr d/dtau -> 1/diff(r(tau),tau) d/dtau
#
# Examples:  chain( r - r(tau), t, [r,t]) -> diff(r(tau),tau)/diff(t(tau),tau)
#
#   chain( r - r(tau.lambda), t, [r,t])
#        -> diff(r(tau,lambda),tau)/diff(t(tau,lambda),tau)
#           + diff(r(tau,lambda),lambda)/diff(t(tau,lambda),lambda)

chain_old := proc( expr, diffBy, chainList)

local a, b, prod, indexFn, dummy, newExpr, varSeq;

 if not has(chainList, diffBy) then
   newExpr := diff(expr, diffBy):

 elif type(expr, function) then
   varSeq := op(expr);
   #
   # are the arguments to the function in the
   # chainList ? If yes than just take diff
   # (they're excluded from chaining)
   #
   # For now assume they're either all in or all out
   #
   if {op(chainList)} intersect {varSeq} = {varSeq} then
     newExpr := diff(expr, diffBy):

   else
     #
     # do the chain rule expansion
     #
     newExpr := 0:
     for a in varSeq do
       newExpr := newExpr + diff(expr,a)/diff(diffBy(varSeq),a);
     od:
   fi:

 elif type( expr, `*`) then
  #
  # (division is represented as a * b^-1, so it's covered here)
  #
  # do the standard calculus stuff  D( a*b) = D(a)*b + a*D(b) etc.
  # Is there some clever functional way to do this ?
  #
  newExpr := 0;
  for a to nops(expr) do
     prod := 1;
     for b to nops(expr) do
       if a = b then
         #
         # note expr[b] doesn't work for all cases -> use op()
         #
	 prod := prod * chain( op(b,expr), diffBy, chainList):
       else
	 prod := prod * op(b,expr);
       fi:
     od:
     newExpr := newExpr + prod:
  od:


 elif type( expr, {`+`,set,list} ) then
  newExpr := map(chain, expr, diffBy, chainList):

 else

  newExpr := diff(expr,diffBy);

 fi:

 newExpr;

end:
