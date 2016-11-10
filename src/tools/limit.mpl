head	1.1;
branch	1.1.1;
access;
symbols
	Rel-1-80-pre2-R6:1.1.1.1
	Rel-1-80-pre1-R6:1.1.1.1
	Rel-1-79:1.1.1.1
	Rel-1-79-R6:1.1.1.1
	Rel-1-79-pre5-R6:1.1.1.1
	Rel-1-79-pre4-R6:1.1.1.1
	Rel-1-79-pre3-R6:1.1.1.1
	Rel-1-79-pre3:1.1.1.1
	Rel-1-78:1.1.1.1
	Rel-1-78-R6:1.1.1.1
	Rel-1-79-pre1:1.1.1.1
	Rel-1-78-pre5-R6:1.1.1.1
	Rel-1-78-pre5:1.1.1.1
	Rel-1-78-pre4-R6:1.1.1.1
	Rel-1-78-pre4:1.1.1.1
	Rel-1-78-pre2-R6:1.1.1.1
	Rel-1-78-pre2:1.1.1.1
	Rel-1-78-pre1-R6:1.1.1.1
	Rel-1-78-pre1:1.1.1.1
	Rel-1-77:1.1.1.1
	R6:1.1.1.1.0.4
	Rel-1-77-R6:1.1.1.1
	Rel-1-77-pre1-R6:1.1.1.1
	Rel-1-77-pre1-R5:1.1.1.1
	Rel-1-76-R6:1.1.1.1.0.2
	Rel-1-75:1.1.1.1
	Rel-1-76:1.1.1.1
	Rel-1-76pre2:1.1.1.1
	Rel-1-74:1.1.1.1
	GRTensorII:1.1.1;
locks; strict;
comment	@# @;


1.1
date	99.08.17.12.49.42;	author dp;	state Exp;
branches
	1.1.1.1;
next	;

1.1.1.1
date	99.08.17.12.49.42;	author dp;	state Exp;
branches;
next	;


desc
@@



1.1
log
@Initial revision
@
text
@# limit.mpl
# a tool for taking limits in unspecified functions and applying
# L'Hopitals rule where necessary. NOTE: does not use maples limit() instead
# does substitution and applies L'Hopitals rule where required!
#      ^^^^^^^^^^^^
# grlimit(expr,var,limit,fnList,subList,LH_limit)
#   expr -  expression to evaluate in the limit
#   var  -  limiting variable
#   limit-  the limit point
#   fnList- list of functions involving the limit variable
#  subList- substitutions valid at the limit point (but expressed as fn of
#           r because it makes life much simpler
#           i.e. {r=0, b(r) = 1, diff(b(r),r)=0}
#
# e.g. grlimit(scalarR,r,0,[a(r),b(r)],[`a(0)`=0,`a(0)'` = 0] );
#
# Comments:
# There is one snag. Direct substitution of a condition like diff(a(r),r)=0
# will result in higher order derivitives evaluating to diff(0,0) which
# constitutes an error. So the higher order derivitives need to be altered
# before substitutions of this form can be done. All functions are sub'd
# to a string e.g. diff(diff(a(r),r)) -> `a(limit)''`. Then these same subs
# can be applied to subList.
#
#  Sept. 19 1994  Bug fix `. If result not a sum, then failed. Check
#                 for this. [pm]
#  Feb.  14 1998  Replace `string' to `name' data-type for R5 [dp]
#
grlimit := proc()
local a,b,l,
      var,   # 2nd
      limit, # 3rd
      fnList,# 4th
      indef,
      LH_limit,  # limit to the number of times L'Hopitals rule is to
                 # be applied
      numterms,  # number of terms in the expanded expression
      top,bot,   # numer and denom of terms
      etop,ebot, # above evalauted at limits
      result,    # result of the limit operation
      root,      # used in diff subList creation
      subList,   # substitutions to use at the limit point
      tic,
      diffSub,   # list of subs for differentiations
      x:

# don't do type checking. Wait for MapleV 1.2
if nargs < 4 then ERROR(`Too few parameters`); fi:
x := expand(args[1]);
var := args[2];
limit := args[3];
fnList := args[4]:
subList := args[5]:
if fnList = [] then
  ERROR(`No implicit functions. Use maple's limit() instead.`);
fi:
LH_limit := 8;
if nargs = 6 then LH_limit := args[6]: fi:

# prepatory work. Build subs list for derivitives of the functions
# have e.g. [a,[r],b,[r]] -> diff(a(r),r)=a(r)' etc.

diffSub := {}:
for a to nops(fnList) do
  root := convert( subs(var=limit, fnList[a]), string):
  tic := `'`:
  # for each function add f(var) = limit
  diffSub := diffSub union {fnList[a] = root}:
  for b to LH_limit+2 do
     diffSub := diffSub union
                { diff(fnList[a],var$b) = cat(root,tic) }:
     tic := cat(tic,`'`):
  od:
od:

# supplement the sub list with var=limit
subList := [op(subList),var=limit]:

# now expand expression into simple terms
if type(x,`+`) then
   numterms := nops(x):
else
   numterms := 1:
fi:

# now loop through each term, evaluate the numer and denom,
# apply L'Hopitals rule for 0/0 and set aside x/0 terms for later
result := 0:
indef := 0:

for a to numterms do
   l := 0; # number of L'Hopitals
   etop := 0; # seed values to get into the while loop
   ebot := 0;
   if numterms = 1 then
     top := numer(x):
     bot := denom(x):
   else
     top := numer(op(a,x)):
     bot := denom(op(a,x)):
   fi:
   while (etop = 0 and ebot = 0 and l <= LH_limit) do
       etop := eval(subs( subList, subs( diffSub, top))):
       ebot := eval(subs( subList, subs( diffSub, bot))):
       top := diff(top, var):
       bot := diff(bot, var):
       l := l + 1:
   od:
   if l >= LH_limit then
      print(`LHopital limit reached and still indeterminate. Leaving term unaltered`);
      result := result + op(a,x);
      next: # go on to the next term
   elif ebot = 0 then
      # if indeterminate lump in with the others
      indef := indef + op(a,x);
   elif etop <> 0 then
      # perfectly ok term
      result := result + etop/ebot:
   fi:
od: # term by term loop

# now deal with the indefinate terms
indef := factor(indef); # rearrange
   l := 0; # number of L'Hopitals
   etop := 0;
   ebot := 0;
   top := numer(indef):
   bot := denom(indef):
   while (etop = 0 and ebot = 0 and l <= LH_limit) do
       etop := eval(subs( subList, subs( diffSub, top))):
       ebot := eval(subs( subList, subs( diffSub, bot))):
       top := diff(top, var):
       bot := diff(bot, var):
       l := l + 1;
   od:
   if l >= LH_limit then
      print(`LHopital limit reached and still indeterminate.`);
      result := result + indef;
   elif ebot = 0 then
      result := infinity:
   elif etop <> 0 then
      result := result + etop/ebot:
   fi:

result; # return result

end:

# help screen

`help/text/grlimit` := TEXT(

`HELP FOR: grlimit`,
``,
`CALLING SEQUENCE: grlimit(expr,var,limit,fnList,valueList, <LHlimit> )`,
``,
`PARAMETERS: expr      - an expression`,
`            var       - limiting variable`,
`            limit     - limiting value of var`,
`            fnList    - unspecified functions in expr`,
`            valueList - values of functions and/or their derivitives`,
`                        w.r.t var at the limit point`,
`            LHlimit   - (optional) limit to number of times L'Hopital's`,
`                        rule should be applied (default = 8)`,
``,
`SYNOPSIS: `,
``,
` - evaluates expr at the limit point. If indeterminate forms arise then`,
`   L'Hopital's rule is applied (repeatedly) until the limit is resolved`,
`   or LH_limit is exceeded. If LH_limit is exceeded the indeterminate`,
`   portion is returned unevalated`,
``,
` - grlimit works by SUBSTITUTION it does not concern itself with how`,
`   rapidly functions approach the limit point.`,
``,
` - elements of valueList must consist of equations. The lhs of these`,
`   must be a STRING containing the function at the limit point. Denote`,
`   derivitives w.r.t. the limiting variable by a forward quote (').`,
`   See the example below for details.`,
``,
` - grlimit first expands expression and then evaluates term by term.`,
`   divergent terms are then lumped together, factored into a single`,
`   expression and that is then evaluated. This way divergent terms can`,
`   cancel in some cases. If the final result diverges grlimit returns`,
`   infinity (regardless of whether it's -infinity or not).`,
``,
`EXAMPLES:`,
`# if expr contains a(r) and b(r) and limiting values at r=0 are`,
`# a(0) = b(0) = 1 and diff(b(0),r) = diff(a(0),r) = 0 then the command is:`,
`>grlimit(expr,r,0,[a(r),b(r)],[``a(0)``=1,``a(0)'``=0,``b(0)``=1,``b(0)'``=0]);`,
``
):
@


1.1.1.1
log
@Initial import to CVS repository
@
text
@@
