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
#
#==============================================================================

#------------------------------------------------------------------------------
# calc_scalar: Returns the value of a scalar (used to be named calc_sum0)
#------------------------------------------------------------------------------
grF_calc_scalar := proc(object, iList)
option `Copyright 1999 Denis Pollney`:
  RETURN(grG_ObjDef[object][grC_calcFnParms]):
end:

#------------------------------------------------------------------------------
# build_contractFn: Automatically build a function which carries out index
#   contractions of an object.
# Argument: n - the number of contractions
# Returns:  a procedure which carries out the index contraction
#------------------------------------------------------------------------------
grF_build_contractFn := proc (n)
option `Copyright 1999 Denis Pollney`:
global Ndim, grG_metricName, grG_ObjDef, gr_data:
local contractFn, a, globallist:

  #
  # core of the contraction routine:
  #   s := s + grG_ObjDef [object][grC_calcFnParms]
  #
  contractFn := `&statseq`(`&:=` (`&local`[1], `&local`[1] +
    grG_ObjDef[`&args`[1]]['grC_calcFnParms'])):

  #
  # build a loop for each index contraction using the
  # global variables s1_ ... s.n._ 
  # 
  for a from n to 1 by -1 do
    contractFn := `&for` (s||a||_, 1, 1, 'Ndim[grG_metricName]', true,
      `&statseq` (contractFn));
  od:
  
  #
  # Add s:=0 initialisation, and return s at the end
  #
  contractFn := `&statseq`( `&:=` (`&local`[1], 0), contractFn,
    `&function`(RETURN,`&expseq`(s))):
  
  #
  # build the procecture
  #  
  globallist := seq (s||a||_, a=1..n):

  contractFn := `&proc`(
    `&expseq`(object, iList),
    `&expseq`(s),
    `&expseq`(),
    `&expseq`(),
    `&statseq`(contractFn), 
    `&expseq`(),
    `&expseq`(globallist),
    `&expseq`()
  ):
  RETURN (procmake (contractFn)):
end:

#
# generic contraction functions, kept for the time being since they
# are still referenced by tensors.mpl
#
grF_calc_sum0 := proc(object, iList)
option `Copyright 1994 by Peter Musgrave, Denis Pollney and Kayll Lake`;
global gr_data, Ndim, grG_metricName;
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





