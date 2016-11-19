
#
# difftool
#
# Developed By: Peter Musgrave
#
# July 21, 1994
#
# Allow the first derivatives of some arbitrary
# function to be set to zero while keeping
# higher order derivatives intact.
#
# The idea:
#
# Maple distinguishes between Diff and diff. Scan the
# expression and convert and terms with diff(diff(..)..)
# to Diff(Diff(..)..)
#

difftool := proc(expr)

local retVal:

 retVal := expr:
 if type( expr, {`*`,`+`,`^`} ) then
   retVal := map( difftool, expr);

 elif type(expr,function) then
   if op(0,expr) = diff then
     #
     # found an instance of diff, is it a diff(diff ?
     # If so then convert to Diff
     #
     if type( op(1,expr), function) then
       if op(0,op(1,expr)) = diff then
         retVal := subs( diff=Diff, expr):
       fi:
     fi:
   else
     retVal := op(0,expr)(op(map(difftool,[op(expr)]))):

   fi:
 fi:

 retVal;

end:
