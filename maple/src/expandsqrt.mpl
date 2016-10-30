#=================================================================-*-Maple-*-==
# expandsqrt - some helper functions for maple.
#
# Denis Pollney
# 2.2.1997
# Feb   14, 97   Switch convert(x,string) to convert(x,name) for R5 [dp]
#==============================================================================

#------------------------------------------------------------------------------
# expandsqrt - simplify functions of the form sqrt( x^(2f) ).
#   usage: > expandsqrt ( f );  # f a function.
#------------------------------------------------------------------------------
expandsqrt := proc ( s )
local a, t, cexpr, cterm, newterm, nm:
  cexpr := s:
### WARNING: note that `I` is no longer of type `radical`
  if type ( cexpr, radical ) then
    if not type ( 2*op(2,cexpr), fraction ) then
      nm := numer ( op(2,cexpr) ):
      cterm := op ( 1, cexpr ):
      newterm := factor(sqrt(factor(expand(cterm)),symbolic)):
      if type ( op(1,newterm), `*` ) then
        t := 1:
        for a in op(1,newterm) do
	  t := t*factor(sqrt(factor(expand(a)),symbolic)):
        od:
	newterm := t:
      fi:
      cexpr := newterm^nm:
    fi:
  elif nops ( cexpr ) > 1 then
    for cterm in cexpr do
      newterm := expandsqrt ( cterm ):
      cexpr := subs ( cterm=newterm, cexpr ):
    od:
  fi:
  RETURN ( cexpr ):
end:

#------------------------------------------------------------------------------
# simplify an object by expanding the numerator over the denominator
#------------------------------------------------------------------------------
expandtb := proc (a)
  RETURN (expand (numer (a))/ expand (denom (a))):
end:

#------------------------------------------------------------------------------
# A new specification of complex functions
#
# The following set of functions define a new specification of complex
# functions for Maple. It has the following properties:
#
#  - complex functions/variables are those listed in the global set
#      complexSet_.
#
#  - functions/variables not listed in complexSet_ are regarded as real.
#
#  - conjugates of complex variables are given names corresponding to
#      the name of the original variable with the string `bar' appended.
#      Thus the conjugate of z becomes zbar, the conjugate of f(x) becomes
#      fbar(x).
#
#  - complex conjugation is carried out via the conj() function which
#      automatically performs the required z<-->zbar name switching.
#      conj() also creates a companion set, conjSet_, listing the
#      names of the complex conjugate variables.
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# conj - complex conjugation assuming variables are real unless specified by
#        the global variable complexSet_.
#        [based on the MapleV.3 function conjugate().]
#------------------------------------------------------------------------------
conj := proc ( a )
global conjSet_:
local s, t, x, y, f, conjSet, complexSet:
  if assigned ( complexSet_ ) then
    complexSet := complexSet_:
    conjSet := createConjSet ( complexSet ):
    conjSet_ := conjSet:
  else
    complexSet := {}:
    conjSet := {}:
  fi:

  if nargs <> 1 then
    ERROR ( `expecting 1 argument, got `||nargs ):
  elif type ( a, 'complex(numeric)' ) then
    subs ( I = -I, a ):
  elif type ( a, `*` ) then
    s := 1:
    for x in a do
      s := s*conj(x):
    od:
    s:
  elif type ( a, `+` ) then
    s := 0:
    for x in a do
      s := s + conj(x):
    od:
    s:
### WARNING: note that `I` is no longer of type `^`
  elif type (a, `^` ) and ( type ( op ( 2, a ), 'numeric' ) 
    or type ( signum ( op ( 2, a ) ), 'numeric' ) ) then
    conj ( op ( 1, a ) )^op ( 2, a ):
  elif traperror ( sign(a) ) = -1 then
    -conj(-a):
  elif Im(a) = 0 or type ( a, 'realcons' ) 
    or type ( signum(a), 'numeric' ) then
    a:
  elif type ( a, 'function' ) and type ( op ( 0, a ), name ) then
    if member ( op ( 0, a ), '{O,cos,cot,csc,erf,exp,Beta,hypergeom,cosh,
      coth,csch,erfc,GAMMA,sech,signum,sinh,tanh,Psi,Si,sin,tan,
      Ssi,Shi,diff}' ) then
      map ( conj, a ):
    elif not member ( op(0,a), complexSet ) then
      if not member ( op(0,a), conjSet ) then
        a:
      else
        ``||unconjname (op(0,a))(op(a)):
      fi:
    else
      f := `conj/`||(op(0,a)):
      if not type ( f, 'procedure' ) then
### WARNING: persistent store makes one-argument readlib obsolete
        traperror ( readlib(f) )
      fi:
      if f <> lasterror and type ( f, 'procedure' ) then
        f ( op ( a ) ):
      else 
        ``||(op(0,a))||bar(op(a))
      fi:
    fi:
  else
    if member ( a, complexSet ) then
      ``||a||bar
    elif member ( a, conjSet ) then
      unconjname ( a ):
    else
      a:
    fi:
  fi:
end:

#------------------------------------------------------------------------------
# createConjSet - creates a set containing names of the conjugate variables.
#------------------------------------------------------------------------------

createConjSet := proc ( s )
local z, cset:
  cset := {}:
  for z in s do
    cset := cset union {``||z||bar}:
  od:
  RETURN ( cset ):
end:

#------------------------------------------------------------------------------
# unconjname - converts conjugate names into their normal form, ie. zbar --> z.
#------------------------------------------------------------------------------

unconjname := proc ( s )
local a:
  for a in complexSet_ do
    if ``||a||bar = s then
      RETURN ( a ):
    fi:
  od:
end:

#==============================================================================

