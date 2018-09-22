#================================================================-*-Maple-*-==
# contract.mpl
# Automatically build calculation functions for objects that are
# determined from other objects via a contraction of indices.
#
# Created by: Denis Pollney
# Date:       9 September 1999
#
# (This functionality used to be carried out by the individual functions
# grF_calc_sum0 ... grF_calc_sum4. The new version generalises these
# by allowing an arbitrary number of index contractions for spaces of
# n>4 dimensions.)
#
# Modifications:
#------------------------------------------------------------------------------
# 9 Sep 1999  Created [dp]
# May 2018 - Adapt to ToInert/FromInert since procmake is broken in Maple 2018
#
#==============================================================================

#------------------------------------------------------------------------------
# calc_scalar: Returns the value of a scalar (used to be named calc_sum0)
#------------------------------------------------------------------------------
grF_calc_scalar := proc(object, iList)
global grG_ObjDef:
#option `Copyright 1999 Denis Pollney`:
  RETURN(grG_ObjDef[object][grC_calcFnParms]):
end:

#------------------------------------------------------------------------------
# Build an inert for loop
#------------------------------------------------------------------------------

grF_inertFor := proc(loopVarName, inertFrom, body)
# loopVarName - global variable name
# toName   - name of global for to limit
# body     - inert form of body of for loop (_Inert_STATSEQ() )

  RETURN(
    _Inert_FORFROM(
      _Inert_NAME(loopVarName),   # loop variable
      inertFrom,                # from 
      _Inert_INTPOS(1),         # step
      _Inert_TABLEREF(_Inert_NAME("Ndim"), # limit
        _Inert_EXPSEQ(_Inert_NAME("grG_metricName"))),         
      _Inert_NAME("true", _Inert_ATTRIBUTE(_Inert_NAME("protected", 
         _Inert_ATTRIBUTE(_Inert_NAME("protected"))))), 
      body, 
      _Inert_NAME("false", _Inert_ATTRIBUTE(_Inert_NAME("protected",
         _Inert_ATTRIBUTE(_Inert_NAME("protected")))))
    )   
  )
  
end:

#------------------------------------------------------------------------------
# build_contractFn: Automatically build a function which carries out index
#   contractions of an object.
# Argument: n - the number of contractions
# Returns:  a procedure which carries out the index contraction
#------------------------------------------------------------------------------
#==================================================================
# Update in Maple 2018 to use FromInert
# (procmake was deprecated and has finally stopped working)
#==================================================================
grF_build_contractFn := proc (n)
option trace:
global Ndim, grG_metricName, grG_ObjDef, gr_data, grC_calcFnParms:
local contractFn, a, globalSeq:

  #
  # core of the contraction routine:
  #   s := s + grG_ObjDef [object][grC_calcFnParms]
  #
  #  contractFn := `&statseq`(`&:=` (`&local`[1], `&local`[1] +
  #    grG_ObjDef[`&args`[1]]['grC_calcFnParms'])):

  contractFn := 
  _Inert_STATSEQ(_Inert_ASSIGN(_Inert_NAME("s"), 
        _Inert_SUM(_Inert_NAME("s"), 
          ToInert( grG_ObjDef[object][grC_calcFnParms])
      )
    )
  );
        
      
  #
  # build a loop for each index contraction using the
  # global variables s1_ ... s.n._ 
  # 
#  for a from n to 1 by -1 do
#    contractFn := `&for` (s||a||_, 1, 1, 'Ndim[grG_metricName]', true,
#      `&statseq` (contractFn));
#  od:

  for a from n to 1 by -1 do
    contractFn := grF_inertFor(cat("s",a,"_"), _Inert_INTPOS(1), _Inert_STATSEQ(contractFn));
  od:  


  #
  # Add s:=0 initialisation, and return s at the end
  #
#  contractFn := `&statseq`( `&:=` (`&local`[1], 0), contractFn,
#    `&function`(RETURN,`&expseq`(s))):

  contractFn := _Inert_STATSEQ( _Inert_ASSIGN(_Inert_NAME("s"), _Inert_INTPOS(0)), contractFn );
  
  #
  # build the procecture
  #  
  globalSeq := seq (_Inert_NAME(cat("s",a,"_")), a=1..n), 
      _Inert_NAME("grG_ObjDef"),
      _Inert_NAME("grC_calcFnParams"), 
      _Inert_NAME("gr_data"):

  # globals Ndim and gr_data are inherited from calling routines
  
  contractFn := _Inert_PROC(
    _Inert_PARAMSEQ(_Inert_NAME("object"), _Inert_NAME("iList")),
    _Inert_LOCALSEQ(_Inert_NAME("s")),
    _Inert_OPTIONSEQ(_Inert_NAME("trace")), 
    _Inert_EXPSEQ(), 
    _Inert_STATSEQ(contractFn),
    _Inert_DESCRIPTIONSEQ(), 
    _Inert_GLOBALSEQ(globalSeq), 
    _Inert_LEXICALSEQ(), 
    _Inert_EOP(_Inert_EXPSEQ())
  ):
  RETURN (FromInert(contractFn)):
end:

#==================================================================

#
# generic contraction functions, kept for the time being since they
# are still referenced by tensors.mpl
#
grF_calc_sum0 := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global gr_data, Ndim, grG_metricName, grG_ObjDef;
  RETURN(grG_ObjDef[object][grC_calcFnParms]):
end:

# sum over one index
grF_calc_sum1 := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  s1_, Ndim, grG_metricName, grG_ObjDef, gr_data;
local s;
 s := 0;
 for s1_ to Ndim[grG_metricName] do
     s := s + grG_ObjDef[object][grC_calcFnParms]:
 od:
 RETURN(s);
end:

# sum over two indices
grF_calc_sum2 := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  s1_, s2_, Ndim, grG_metricName, grG_ObjDef, gr_data;
local s;
 s := 0;
 for s1_ to Ndim[grG_metricName] do
   for s2_ to Ndim[grG_metricName] do
     s := s + grG_ObjDef[object][grC_calcFnParms]:
   od:
 od:
 RETURN(s);
end:

# sum over two indices
grF_calc_sum3 := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  s1_, s2_, s3_, Ndim, grG_metricName, grG_ObjDef, gr_data;
local s;
 s := 0;
 for s1_ to Ndim[grG_metricName] do
   for s2_ to Ndim[grG_metricName] do
     for s3_ to Ndim[grG_metricName] do
       s := s + grG_ObjDef[object][grC_calcFnParms]:
     od:
   od:
 od:
 RETURN(s);
end:

# sum over four indices
grF_calc_sum4 := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global  s1_, s2_, s3_, s4_, Ndim, grG_metricName, grG_ObjDef, gr_data;
local s;
 s := 0;
 for s1_ to Ndim[grG_metricName] do
   for s2_ to Ndim[grG_metricName] do
     for s3_ to Ndim[grG_metricName] do
       for s4_ to Ndim[grG_metricName] do
	 s := s + grG_ObjDef[object][grC_calcFnParms]:
       od:
     od:
   od:
 od:
 RETURN(s);
end:





