#=================================================================-*-Maple-*-==
# autoAlias: alias functions so that their derivatives appear as
#   subscripts. Based on an idea by Roberto Sussman and modified by
#   Peter Musgrave for GRTensorII. Rewritten for R5 by Denis Pollney
#   based on a suggestion by Joe Riel [MUG].
#
#  9 Feb 1999  Rewritten from scratch. Adds zeroth-order aliasing and
#              fixes problems with R5 use of alias. [dp]
# 27 Jul 1999  Checked if the aliased function also corresponds to a
#              grtensor object, in which case it is not aliased. [dp]
#==============================================================================
autoAlias := proc (expr)
global dlist_, grG_usedNameSet:
local a, fn, f, x, df, aset, warnedSet:
  aset := {alias()}:
  dlist_ := NULL:

  # the following sets the global dlist_ variable:
  eval (subs(diff = `autoAlias/dlist`, expr)):

  warnedSet := {}:
  for a in {dlist_} do
    fn := op(1,a):
    f := `autoAlias/extractname` (fn):
    x := `autoAlias/extractvars` (fn), op(op(2,a)):
    if not member (op(0,f)[x], aset) then
      aset := {alias (eval (op(0,f)[x] = subs (diff=''diff'', `$`=''`$`'',
        eval (`print/diff`)(f, x))))}:
    fi:
    if not member (op(0,f), aset) then
      if not member (op(0,f), grG_usedNameSet) then
	aset := {alias (op(0,f) = f)}:
      else
	  if not member (op(0,f), warnedSet) then
	    printf (`Warning: %a corresponds to a previously defined GRTensor object -- to avoid ambiguities, only its derivatives have been aliased.\n`, op(0,f)):
	    warnedSet := warnedSet union {op(0,f)}:
	  fi:
      fi:
    fi:
  od:
  dlist_ := 'dlist_':
  expr;
end:

`autoAlias/dlist` := proc (expr, d)
global dlist_:
  dlist_ := dlist_, [expr,{d}]:
  RETURN (diff(expr, d)):
end:

`autoAlias/diff` := proc (expr, diffby)
local varSeq, f, df, fname:
  varSeq := diffby:
  if type (expr, {function,procedure}) then
    f := expr:
    while type (f,{function,procedure}) and op (0,f) = ''diff'' do
      varSeq := op (2,f), varSeq:
      f := op (1,f):
    od:
    fname := `autoAlias/extractname` (f):
    print (expr, {varSeq}, {diffby});
#    if not member (fname,{alias()}) then
#      alias (fname=f):
#    fi:
    if grG_Release >= 5 then
      df := subs (diff=''diff'', `$`=''`$`'',
### WARNING: persistent store makes one-argument readlib obsolete
        readlib (`print/diff`)(f,diffby)):
      alias (fname[varSeq] = subs (diff=''diff'', `$`=''`$`'',
### WARNING: persistent store makes one-argument readlib obsolete
        readlib (`print/diff`)(f,diffby))):
      RETURN (fname[varSeq]):
    else
      alias (fname[varSeq] = diff(fname,diffby)):
    fi:
  fi:
  RETURN (diff(fname,diffby)):
end:

`autoAlias/extractname` := proc (f)
  if op(0,f)=diff then
    RETURN (`autoAlias/extractname` (op(1,f))):
  fi:
  RETURN (f):
end:

`autoAlias/extractvars` := proc (f)
local a, v:
  if op(0,f)='diff' then
    v := NULL:
    for a from 2 to nops(f) do
      v := v, op(a,f):
    od:
    RETURN (`autoAlias/extractvars`(op(1,f)), v):
  else
    RETURN(NULL):
  fi:
end:

