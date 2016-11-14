#******************************************************************
#
#  GRTENSOR II MODULE: Petrov.mpl
#
#  (C) 1992-94 Peter Musgrave, Kayll Lake, Denis Pollney
#
#  Routine object definitions to calculate the Petrov type of a spacetime.
#  Algorithm borrowed from 
#
#    F. W. Letniowski, R. G. McLenaghan, GRG, v20, no.5, 1988, p463.
#
#  File Created by: Denis Pollney
#             Date: August 25 1994
#
#  Revisions:
#  June 6, 1996	Changed report() to petrovr(). [dp]
#
#******************************************************************

#-----------------------------
# Petrov type using a general tetrad.
#-----------------------------
grG_ObjDef[Petrov][grC_header] := `Petrov Type`:
grG_ObjDef[Petrov][grC_root] := Petrov_:
grG_ObjDef[Petrov][grC_rootStr] := `Petrov Type `:
grG_ObjDef[Petrov][grC_indexList] := []:
grG_ObjDef[Petrov][grC_calcFn] := grF_calc_Petrov:
grG_ObjDef[Petrov][grC_calcFnParms] := [NULL]:
grG_ObjDef[Petrov][grC_symmetry] := grF_sym_scalar:
grG_ObjDef[Petrov][grC_depends] := { Psi0, Psi1, Psi2, Psi3, Psi4 }:

grF_calc_Petrov := proc(object, index)
local a, s:

  s := grpetrov (  gr_data[Psi0_,grG_metricName],
                   gr_data[Psi1_,grG_metricName],
                   gr_data[Psi2_,grG_metricName],
                   gr_data[Psi3_,grG_metricName],
                   gr_data[Psi4_,grG_metricName] ):
  RETURN(s):
end:

#===================================================
#
# Calculation routine
#
#===================================================

grpetrov := proc()
  local	i, mask, Psi, ptype, f1, f2, f3, t1, t2, t3, t4, 
        A, D, E, F, G, H, typeI, J, Q, S, U, V, W, Z, str, str1, str2, str3, str4:
  global grG_reportLine, grG_reportSize, grG_reportVline, grG_reportVsize:

  grG_reportSize := 0:
  grG_reportVsize := 0:

  Psi := array ( 0..4 ):
  for i from 0 to 4 do Psi[i] := args[i+1] od:

  mask := 0:
  for i from 0 to 4 do 
    str := `Weyl scalar Psi`.i:
    grF_report ( ``, str, Psi[i] ):
    if Psi[i] <> 0 then 
      mask := mask + 2^(4-i):
    fi:
  od:

  if mask = 0 then
    ptype := `O`:
  elif mask = 1 then
    ptype := `N (or simpler)`:
  elif mask = 2 then
    ptype := `III (or simpler)`:
  elif mask = 3 then
    ptype := `III (or simpler)`:
  elif mask = 4 then
    ptype := `D (or simpler)`:
  elif mask = 5 then
    ptype := `II (or simpler)`:
  elif mask = 6 then
    ptype := `II (or simpler)`:
  elif mask = 7 then
    str := `2*Psi[3]^2-3*Psi[2]*Psi[4]`:
    typeI := grF_pSimplify ( 2*Psi[3]^2 - 3*Psi[2]*Psi[4] ):
    if typeI = 0 then
      ptype := `D (or simpler)`: 
    else
      ptype := `II (or simpler)`:
    fi:
    grF_report ( ``, str, I ):
  elif mask = 8 then
    ptype := `III (or simpler)`:
  elif mask = 9 then
    ptype := `I (or simpler)`:
  elif mask = 10 then
    ptype := `I (or simpler)`:
  elif mask = 11 then
    str := `27*Psi[1]*Psi[4]^2 + 64*Psi[3]^3`:
    typeI := grF_pSimplify ( 27*Psi[1]*Psi[4]^2 + 64*Psi[3]^3 ):
    if  typeI = 0 then
      ptype := `II (or simpler)`:
    else 
      ptype := `I (or simpler)`:
    fi:
    grF_report ( ``, str, I ):
  elif mask = 12 then
    ptype := `II (or simpler)`:
  elif mask = 13 then
    str := `Psi[1]^2*Psi[4] + 2*Psi[2]^3`:
    typeI := grF_pSimplify ( Psi[1]^2*Psi[4] + 2*Psi[2]^3 ):
    if typeI = 0 then
      ptype := `II (or simpler)`:
    else
      ptype := `I (or simpler)`:
    fi:
    grF_report ( ``, str, I ):
  elif mask = 14 then
    str := `9*Psi[2]^2-16*Psi[1]*Psi[3]`:
    typeI := grF_pSimplify ( 9*Psi[2]^2-16*Psi[1]*Psi[3] ):
    if typeI = 0 then
      ptype := `II (or simpler)`:
    else 
      ptype := `I (or simpler)`:
    fi:
    grF_report ( ``, str, I ):
  elif mask = 15 then
    str1 := `3*Psi[2]^2 - 4*Psi[1]*Psi[3]`:
    str2 := `2*Psi[2]*Psi[3] - 3*Psi[1]*Psi[4]`:
    typeI  := grF_pSimplify ( 3*Psi[2]^2 - 4*Psi[1]*Psi[3] ):
    f1 := grF_pSimplify ( 2*Psi[2]*Psi[3] - 3*Psi[1]*Psi[4] ):
    grF_report ( ``, str1, typeI ):
    grF_report ( ``, str2, f1 ):
    if typeI = 0 then
      if f1 = 0 then 
        ptype := `III (or simpler)`:
      else
        ptype := `I (or simpler)`:
      fi:
    else
      if f1 = 0 then
        ptype := `I (or simpler)`:
      else
        str3 := `9*Psi[2]*Psi[4] - 8*Psi[3]^2`:
        f2 := grF_pSimplify ( 9*Psi[2]*Psi[4] - 8*Psi[3]^2 ):
        grF_report ( ``, str3, f2 ):
        if f2 = 0 then
          ptype := `I (or simpler)`:
        else
          str4 := `3*f1^2 + 2*I*f2`:
          f3 := grF_pSimplify ( 3*f1^2 + 2*I*f2 ):
          grF_report ( ``, str4, f3 ):
          if f3 = 0 then
            ptype := `II (or simpler)`:
          else
            ptype := `I (or simpler)`:
          fi:
        fi:
      fi:
    fi:
  elif mask = 16 then
    ptype := `N (or simpler)`:
  elif mask = 17 then
    ptype := `I (or simpler)`:
  elif mask = 18 then 
    ptype := `I (or simpler)`:
  elif mask = 19 then
    str := `Psi[0]*Psi[4]^3 - 27*Psi[3]^4`:
    typeI := grF_pSimplify ( Psi[0]*Psi[4]^3 - 27*Psi[3]^4 ):
    grF_report ( ``, str, typeI ):
    if I = 0 then
      ptype := `II (or simpler)`:
    else 
      ptype := `I (or simpler)`:
    fi:
  elif mask = 20 then
    ptype := `II (or simpler)`:
  elif mask = 21 then
    str := `9*Psi[2]^2 - Psi[0]*Psi[4]`:
    typeI := grF_pSimplify ( 9*Psi[2]^2 - Psi[0]*Psi[4] ):
    grF_report ( ``, str, typeI ):
    if  typeI = 0 then
      ptype := `D (or simpler)`:
    else
      ptype := `I (or simpler)`:
    fi:
  elif mask = 22 then
    str := `Psi[0]*Psi[4]^2 + 2*Psi[2]^3`:
    typeI := grF_pSimplify ( Psi[0]*Psi[4]^2 + 2*Psi[2]^3 ):
    grF_report ( ``, str, typeI ):
    if typeI = 0 then
      ptype := `II (or simpler)`:
    else
      ptype := `I (or simpler)`:
    fi:
  elif mask = 23 then
    str1 := `Psi[0]*Psi[4] + 3*Psi[2]^2`:
    str2 := `4*Psi[2]*Psi[4] - 3*Psi[3]^2`:
    typeI := grF_pSimplify ( Psi[0]*Psi[4] + 3*Psi[2]^2 ):
    J := grF_pSimplify ( 4*Psi[2]*Psi[4] - 3*Psi[3]^2 ):
    grF_report ( ` I`, str1, typeI ):
    grF_report ( ` J`, str2, J ):
    if typeI = 0 then
      if J = 0 then
        ptype := `III (or simpler)`:
      else
        ptype := `I (or simpler)`:
      fi:
    else 
      if J = 0 then 
        ptype := `I (or simpler)`:
      else 
        str3 := `Psi[0]*J - 2*Psi[2]*I`:
	f3 := grF_pSimplify ( Psi[0]*J - 2*Psi[2]*I ):
        grF_report ( ` f3`, str3, f3 ):
        if f3 = 0 then
          ptype := `I (or simpler)`:
        else
          str4 := `Psi[4]*I^2 - 3*J*f3`:
          D := grF_pSimplify ( Psi[4]*I^2 - 3*J*f3 ):
          grF_report ( ` D`, str4, D ):
          if D = 0 then
             ptype := `II (or simpler)`:
          else
             ptype := `I (or simpler)`:
          fi:
        fi:
      fi:
    fi:
  elif mask = 24 then
    ptype := `III (or simpler)`:
  elif mask = 25 then
    str := `Psi[4]*Psi[0]^3 - 27*Psi[1]^4`:
    typeI := grF_pSimplify ( Psi[4]*Psi[0]^3 - 27*Psi[1]^4 ):
    grF_report ( ``, str, typeI ):
    if  I = 0 then
      ptype := `II (or simpler)`:
    else 
      ptype := `I (or simpler)`:
    fi:
  elif mask = 26 then
    str := `27*Psi[3]*Psi[0]^2 + 64*Psi[1]^3`:
    typeI := grF_pSimplify ( 27*Psi[3]*Psi[0]^2 + 64*Psi[1]^3 ):
    grF_report ( ``, str, typeI ):
    if I = 0 then
      ptype := `II (or simpler)`:
    else 
      ptype := `I (or simpler)`:
    fi:
  elif mask = 27 then
    t1 := grF_pSimplify ( Psi[0]*Psi[4] ):
    t2 := grF_pSimplify ( Psi[1]*Psi[3] ):
    t3 := grF_pSimplify ( Psi[0]*Psi[3]^2 ):
    t4 := grF_pSimplify ( Psi[4]*Psi[1]^2 ):
    str := `Psi[0]*Psi[3]^2 -  Psi[4]*Psi[1]^2`:
    V  := grF_pSimplify ( t3 - t4 ):
    grF_report ( ` V`, str, V ):
    if V = 0 then
      str := `Psi[0]*Psi[4] + 2*Psi[1]*Psi[3]`:
      U := grF_pSimplify ( t1 + 2*t2 ):
      grF_report ( ` U`, str, U ):
      if U = 0 then
        ptype := `D (or simpler)`:
      else
        str := `Psi[0]*Psi[4] - 16*Psi[1]*Psi[3]`:
        W := grF_pSimplify ( t1 - 16*t2 ):
        grF_report ( ` W`, str, W ):
        if W = 0 then
          ptype := `II (or simpler)`:
        else
          ptype := `I (or simpler)`:
        fi:
      fi:
    else 
      str := `Psi[0]*Psi[4] - 4*Psi[1]*Psi[3]`:
      typeI := grF_pSimplify ( t1 - 4*t2 ):
      grF_report ( ` I`, str, typeI ):
      str := `-Psi[0]*Psi[3]^2 - Psi[4]*Psi[1]^2`:
      J := grF_pSimplify ( -t3 - t4 ):
      grF_report ( ` J`, str, J ):
      if I = 0 then
        if J = 0 then
          ptype := `III (or simpler)`:
        else
          ptype := `I (or simpler)`:
        fi:
      else
        if J = 0 then
          ptype := `I (or simpler)`:
        else
          str := `I^3 - 27*J^2`:
          D := grF_pSimplify ( I^3 - 27*J^2 ):
          grF_report ( ` D`, str, D ):
          if D = 0 then 
            ptype := `II (or simpler)`:
          else
            ptype := `I (or simpler)`:
          fi:
        fi:
      fi:
    fi:
  elif mask = 28 then
    str := `2*Psi[1]^2 - 3*Psi[2]*Psi[0]`:
    typeI := grF_pSimplify ( 2*Psi[1]^2 - 3*Psi[2]*Psi[0]):
    grF_report ( ``, str, typeI ):
    if typeI = 0 then
      ptype := `D (or simpler)`:
    else
      ptype := `II (or simpler)`:
    fi:
  elif mask = 29 then
    str := `Psi[4]*Psi[0] + 3*Psi[2]^2`:
    typeI := grF_pSimplify ( Psi[4]*Psi[0] + 3*Psi[2]^2 ):
    grF_report ( ` I`, str, typeI ):
    str := `4*Psi[2]*Psi[0] - 3*Psi[1]^2`:
    J := grF_pSimplify ( 4*Psi[2]*Psi[0] - 3*Psi[1]^2 ):
    grF_report ( ` J`, str, J ):
    if typeI = 0 then
      if J = 0 then
        ptype := `III (or simpler)`:
      else
        ptype := `I (or simpler)`:
      fi:
    else 
      if J = 0 then 
        ptype := `I (or simpler)`:
      else 
        str := `Psi[4]*J - 2*Psi[2]*I`:
	f3 := grF_pSimplify ( Psi[4]*J - 2*Psi[2]*I ):
        grF_report ( ` f3`, str, f3 ):
        if f3 = 0 then
          ptype := `I (or simpler)`:
        else
          str := `Psi[0]*I^2 - 3*J*f3`:
          D := grF_pSimplify ( Psi[0]*I^2 - 3*J*f3 ):
          grF_report ( ` D`, str, D ):
          if D = 0 then
             ptype := `II (or simpler)`:
          else
             ptype := `I (or simpler)`:
          fi:
        fi:
      fi:
    fi:
  elif mask = 30 then
    str := `3*Psi[2]^2 - 4*Psi[1]*Psi[3]`:
    typeI  := grF_pSimplify ( 3*Psi[2]^2 - 4*Psi[1]*Psi[3] ):
    grF_report ( ` I`, str, typeI ):
    str := `2*Psi[2]*Psi[1] - 3*Psi[3]*Psi[0]`:
    f1 := grF_pSimplify ( 2*Psi[2]*Psi[1] - 3*Psi[3]*Psi[0] ):
    grF_report ( ` f1`, str, f1 ):
    if typeI = 0 then
      if f1 = 0 then 
        ptype := `III (or simpler)`:
      else
        ptype := `I (or simpler)`:
      fi:
    else
      if f1 = 0 then
        ptype := `I (or simpler)`:
      else
        str := `9*Psi[2]*Psi[0] - 8*Psi[1]^2`:
        f2 := grF_pSimplify ( 9*Psi[2]*Psi[0] - 8*Psi[1]^2 ):
        grF_report ( ` f2`, str, f2 ):
        if f2 = 0 then
          ptype := `I (or simpler)`:
        else
          str := `3*f1^2 + 2*I*f2`:
          J := grF_pSimplify ( 3*f1^2 + 2*I*f2 ):
          grF_report ( ``, str, J ):
          if J = 0 then
            ptype := `II (or simpler)`:
          else
            ptype := `I (or simpler)`:
          fi:
        fi:
      fi:
    fi:
  else 
    str1 := `Psi[0]*Psi[2] - Psi[1]^2`:
    str2 := `Psi[0]*Psi[4] - Psi[2]^2`:
    str3 := `Psi[0]*Psi[3] - Psi[1]*Psi[2]`:
    H := grF_pSimplify ( Psi[0]*Psi[2] - Psi[1]^2 ):
    E := grF_pSimplify ( Psi[0]*Psi[4] - Psi[2]^2 ):
    F := grF_pSimplify ( Psi[0]*Psi[3] - Psi[1]*Psi[2] ):
    grF_report ( ` H`, str1, H ):
    grF_report ( ` E`, str2, E ):
    grF_report ( ` F`, str3, F ):
    if H = 0 then
      if F = 0 then
        if E = 0 then
          ptype := `N (or simpler)`:
        else
          ptype := `I (or simpler)`:
        fi:
      else
        if E = 0 then
          str := `37*Psi[2]^2+27*Psi[1]*Psi[3]`:
          Q := grF_pSimplify ( 37*Psi[2]^2+27*Psi[1]*Psi[3] ):
          grF_report ( ` Q`, str, Q ):
          if Q = 0 then
            ptype := `II (or simpler)`:
          else 
            ptype := `I (or simpler)`:
          fi:
        else
          str := `E - 4*(Psi[1]*Psi[3] - Psi[2]^2)`:
          A := grF_pSimplify ( Psi[1]*Psi[3] - Psi[2]^2 ):
          typeI := grF_pSimplify ( E - 4*A ):
          grF_report ( ` I`, str, typeI ):
          if typeI = 0 then 
            ptype := `I (or simpler)`:
          else
            str := `Psi[2]*(Psi[1]*Psi[3] - Psi[2]^2) - Psi[3]*F`:
            J := grF_pSimplify ( Psi[2]*A - Psi[3]*F ):
            grF_report ( ` J`, str, J ):
            str := `I^3 - 27*J^2`:
            D := grF_pSimplify ( I^3 - 27*J^2 ):
            grF_report ( ` D`, str, D ):
            if D = 0 then
              ptype := `II (or simpler)`:
            else 
              ptype := `I (or simpler)`:
            fi:
          fi:
        fi:
      fi:
    else 
      str := `Psi[1]*Psi[3] - Psi[2]^2`:
      A := grF_pSimplify ( Psi[1]*Psi[3] - Psi[2]^2 ):
      grF_report ( ` A`, str, A ):
      str := `E - 4*A`:
      typeI := grF_pSimplify ( E - 4*A ):
      grF_report ( ` I`, str, typeI ):
      if typeI = 0 then
        str := `Psi[2]*A - Psi[3]*F + Psi[4]*H`:
        J := grF_pSimplify ( Psi[2]*A - Psi[3]*F + Psi[4]*H ):
        grF_report ( ` J`, str, J ):
        if J = 0 then
          ptype := `III (or simpler)`:
        else 
          ptype := `I (or simpler)`:
        fi:
      else 
        str := `Psi[0]*F - 2*Psi[1]*H`;
        G := grF_pSimplify ( Psi[0]*F - 2*Psi[1]*H ):
        grF_report ( ` G`, str, G ):
        if G = 0 then
          str := `Psi[0]^2*I - 12*H^2`:
          Z := grF_pSimplify ( Psi[0]^2*I - 12*H^2 ):
          grF_report ( ` Z`, str, Z ):
          if Z = 0 then 
            ptype := `D (or simpler)`:
          else
            str := `Psi[0]^2*I - 3*H^2`:
            S := grF_pSimplify ( Psi[0]^2*I - 3*H^2 ):
            grF_report ( ` S`, str, S ):
            if S = 0 then
              ptype := `II (or simpler)`:
            else
              ptype := `I (or simpler)`:
            fi:
          fi:
        else
          str := `Psi[2]*A - Psi[3]*F + Psi[4]*H`:
          J := grF_pSimplify ( Psi[2]*A - Psi[3]*F + Psi[4]*H ):
          grF_report ( ` J`, str, J ):
          if J = 0 then
            ptype := `I (or simpler)`:
          else 
            str := `I^3 - 27*J^2`:
            D := grF_pSimplify ( I^3 - 27*J^2 ):
            grF_report ( ` D`, str, D ):
            if D = 0 then 
              ptype := `II (or simpler)`:
            else
              ptype := `I (or simpler)`:
            fi:
          fi:
        fi:
      fi:
    fi:
  fi:

  RETURN ( ptype ):

end:

#-----------------------------------------
#
# Simplification to be carried out through calculation.
#
#-----------------------------------------

grF_pSimplify := proc( expr )
global	grG_simpHow, grG_preSeq, grG_postSeq:

  grG_simpHow ( grG_preSeq, expr, grG_postSeq ):

end:



