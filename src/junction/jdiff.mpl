#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#
# GRTENSOR II MODULE: jdiff.MPL
#
# (C) 1992-1994 Peter Musgrave and Kayll Lake
#
# File Created By: Peter Musgrave
#            Date: July 23, 1994
#
#
# Purpose: Do some derivative tricks
#
# Revisions:
#
#
#>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# jdiff(expr, diffBy)
#
# Convert to total derivatives where possible.
#
# e.g. if total derivative is w.r.t. tau:
#
# diff(r(t),t) -> diff(r(tau),tau)/diff(t(tau),tau)
#
# leave any others unaffected
#
# (This routine makes reference to the global variable
#  totalVar which indicates that TOTAL derivatives
#  are to be expressed w.r.t to this variable)
#

jdiff := proc(expr, diffBy)
option trace;
global grG_metricName, gr_data;
local newExpr, a, fun, totalVar:

  totalVar := gr_data[totalVar_, grG_metricName]:

  newExpr := diff(expr, diffBy):
  if type(expr, function) and not totalVar = 0 then
    #
    # operand could be sin(x) or jdiff() even
    # leave these alone
    #
    if not type(op(0,expr),procedure) and nops(expr) = 1 then
      #
      # check the variable list of the function, and
      # see if we have a total. For now we only care
      # about single argument functions
      #
      if op(1,expr) = diffBy then
        if diffBy <> totalVar then
	  #
	  # change e.g. diff(R(t),t) -> diff(R(tau),tau)/ diff(T(tau),tau)
	  # (where we use grxform to get t -> T(tau) )
	  #
	  # Find the coordinate number for diffBy
	  #
	  fun := diffBy(totalVar):
	  for a to Ndim[grG_metricName] do
	    if gr_data[xup_,grG_metricName, a] = diffBy then
	       fun := gr_data[xformup_,grG_metricName,a]:
	       break:
	    fi:
	  od:
          #
          # may have diff( f(u),u) (u a coordinate on Sigma)
          # and expanding into tau's produces a division by
          # zero - since u != u(tau). Catch this case
          #
          if diff(fun, totalVar) <> 0 then
            newExpr := diff( op(0,expr)(totalVar), totalVar)/
                       diff( fun, totalVar):
          fi:
        fi:
      fi:
    fi:
  fi:
  RETURN( newExpr):

end:
