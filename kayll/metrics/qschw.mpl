Ndim_ := 4:

x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:

g11_ := 1/(1-2*m/r)*(1+(epsilon*h[2](r,t)+epsilon^2*H[2](r,t))*(3*cos(theta)^2-1)/2):
g12_ := 0:
g13_ := 0:
g14_ := (epsilon*h[1](r,t)+epsilon^2*H[1](r,t))*(3*cos(theta)^2-1)/2:
g22_ := r^2*(1+(epsilon*k(r,t)+epsilon^2*K(r,t))*(3*cos(theta)^2-1)/2):
g23_ := 0:
g24_ := 0:
g33_ := r^2*sin(theta)^2*(1+(epsilon*k(r,t)+epsilon^2*K(r,t))*(3*cos(theta)^2-1)/2):
g34_ := 0:
g44_ := -(1-2*m/r)*(1-(epsilon*h[0](r,t)+epsilon^2*H[0](r,t))*(3*cos(theta)^2-1)/2):

complex_ := {}:

lperts := {h[0](r,t),h[1](r,t),k(r,t),
   diff(h[0](r,t),r),diff(h[1](r,t),r),diff(k(r,t),r),
   diff(h[0](r,t),t),diff(h[1](r,t),t),diff(k(r,t),t),
   diff(h[0](r,t),r,r),diff(h[1](r,t),r,r),diff(k(r,t),r,r),
   diff(h[0](r,t),t,t),diff(h[1](r,t),t,t),diff(k(r,t),t,t),
   diff(h[0](r,t),r,t),diff(h[1](r,t),r,t),diff(k(r,t),r,t)
   }:

qperts := {H[0](r,t),H[1](r,t),H[2](r,t),K(r,t),
   diff(H[0](r,t),r),diff(H[1](r,t),r),diff(K(r,t),r),
   diff(H[0](r,t),t),diff(H[1](r,t),t),diff(K(r,t),t),
   diff(H[0](r,t),r,r),diff(H[1](r,t),r,r),diff(K(r,t),r,r),
   diff(H[0](r,t),t,t),diff(H[1](r,t),t,t),diff(K(r,t),t,t),
   diff(H[0](r,t),r,t),diff(H[1](r,t),r,t),diff(K(r,t),r,t)
   }:

zfuncs := {eta(r,t),chi(r,t),diff(eta(r,t),r),diff(chi(r,t),r),
   diff(eta(r,t),r,r),diff(chi(r,t),r,r),diff(eta(r,t),t),diff(chi(r,t),t),
   ldiff(eta(r,t),t,t),diff(chi(r,t),t,t),diff(eta(r,t),r,t),diff(chi(r,t),r,t)
   }:

make_s := proc()

   local lambda, mu, loop, s_ren, tmp_term:

   lambda := (2*r+3*m):

   mu := (r-2*m):

   tmp_term[1] := -12*(r^2+m*r+m^2)^2/r^4/mu^2/lambda*(diff(psi(r,t),t))^2 :
   tmp_term[2] := -4*(2*r^3+4*r^2*m+9*r*m^2+6*m^3)/r^6/lambda*psi(r,t)*diff(psi(r,t),r,r):
   tmp_term[3] := (112*r^5+480*r^4*m+692*r^3*m^2+762*r^2*m^3+441*r*m^4+144*m^5)/r^5/mu^2/lambda^3*psi(r,t)*diff(psi(r,t),t):
   tmp_term[4] := -1/3/r^2*diff(psi(r,t),t)*diff(psi(r,t),r,r,r):
   tmp_term[5] := (18*r^3-4*r^2*m-33*r*m^2-48*m^3)/3/r^4/mu^2/lambda*diff(psi(r,t),r)*diff(psi(r,t),t):
   tmp_term[6] := (12*r^3+36*r^2*m+59*r*m^2+90*m^3)/3/r^6/mu*(diff(psi(r,t),r))^2:
   tmp_term[7] := 12*(2*r^5+9*r^4*m+6*r^3*m^2-2*r^2*m^3-15*r*m^4-15*m^5)/r^8/mu^2/lambda*psi(r,t)^2:
   tmp_term[8] := -4/r^3/mu^2*(r^2+r*m+m^2)*diff(psi(r,t),t)*diff(psi(r,t),t,r):
   tmp_term[9] := -2/r^7/mu/lambda^2*(32*r^5+88*r^4*m+296*r^3*m^2+510*r^2*m^3+561*r*m^4+270*m^5)*psi(r,t)*diff(psi(r,t),r):
   tmp_term[10] := 1/3/r^2*diff(psi(r,t),r)*diff(psi(r,t),t,r,r):
   tmp_term[11] := -(2*r^2-m^2)/r^3/mu/lambda*diff(psi(r,t),t)*diff(psi(r,t),r,r):
   tmp_term[12] := (8*r^2+12*r*m+7*m^2)/r^4/mu/lambda*psi(r,t)*diff(psi(r,t),t,r):
   tmp_term[13] := (3*r-7*m)/3/r^3/mu*diff(psi(r,t),r)*diff(psi(r,t),t,r):
   tmp_term[14] := -m/r^3/lambda*psi(r,t)*diff(psi(r,t),t,r,r):
   tmp_term[15] := 4*(3*r^2+5*r*m+6*m^2)/3/r^5*diff(psi(r,t),r)*diff(psi(r,t),r,r):
   tmp_term[16] := mu*lambda/3/r^4*(diff(psi(r,t),r,r))^2:
   tmp_term[17] := -lambda/3/r^2/mu*(diff(psi(r,t),r,t))^2:

   s_ren := 0:

   for loop from 1 to 17 do

      s_ren := s_ren + tmp_term[loop]:

   od:

   s_ren := 12/7*mu^3/lambda*s_ren:

   RETURN(s_ren):

end:

make_s_mu := proc()

   local lambda, mu, loop, s_ren, tmp_term:

   lambda := (2*r+3*m):

   mu := (r-2*m):

   tmp_term[1] := -12*(r^2+m*r+m^2)^2/r^4/mu^3/lambda*(diff(psi(r,t),t))^2 :
   tmp_term[2] := -4*(2*r^3+4*r^2*m+9*r*m^2+6*m^3)/r^6/lambda*psi(r,t)*diff(psi(r,t),r,r):
   tmp_term[3] := (112*r^5+480*r^4*m+692*r^3*m^2+762*r^2*m^3+441*r*m^4+144*m^5)/r^5/mu^2/lambda^3*psi(r,t)*diff(psi(r,t),t):
   tmp_term[4] := -1/3/r^2*diff(psi(r,t),t)*diff(psi(r,t),r,r,r):
   tmp_term[5] := (18*r^3-4*r^2*m-33*r*m^2-48*m^3)/3/r^4/mu^2/lambda*diff(psi(r,t),r)*diff(psi(r,t),t):
   tmp_term[6] := (12*r^3+36*r^2*m+59*r*m^2+90*m^3)/3/r^6/mu*(diff(psi(r,t),r))^2:
   tmp_term[7] := 12*(2*r^5+9*r^4*m+6*r^3*m^2-2*r^2*m^3-15*r*m^4-15*m^5)/r^8/mu^2/lambda*psi(r,t)^2:
   tmp_term[8] := -4/r^3/mu^2*(r^2+r*m+m^2)*diff(psi(r,t),t)*diff(psi(r,t),t,r):
   tmp_term[9] := -2/r^7/mu/lambda^2*(32*r^5+88*r^4*m+296*r^3*m^2+510*r^2*m^3+561*r*m^4+270*m^5)*psi(r,t)*diff(psi(r,t),r):
   tmp_term[10] := 1/3/r^2*diff(psi(r,t),r)*diff(psi(r,t),t,r,r):
   tmp_term[11] := -(2*r^2-m^2)/r^3/mu/lambda*diff(psi(r,t),t)*diff(psi(r,t),r,r):
   tmp_term[12] := (8*r^2+12*r*m+7*m^2)/r^4/mu/lambda*psi(r,t)*diff(psi(r,t),t,r):
   tmp_term[13] := (3*r-7*m)/3/r^3/mu*diff(psi(r,t),r)*diff(psi(r,t),t,r):
   tmp_term[14] := -m/r^3/lambda*psi(r,t)*diff(psi(r,t),t,r,r):
   tmp_term[15] := 4*(3*r^2+5*r*m+6*m^2)/3/r^5*diff(psi(r,t),r)*diff(psi(r,t),r,r):
   tmp_term[16] := mu*lambda/3/r^4*(diff(psi(r,t),r,r))^2:
   tmp_term[17] := -lambda/3/r^2/mu*(diff(psi(r,t),r,t))^2:

   s_ren := 0:

   for loop from 1 to 17 do

      s_ren := s_ren + tmp_term[loop]:

   od:

   s_ren := 12/7*mu^3/lambda*s_ren:

   RETURN(s_ren):

end:

constraint_ := { epsilon^3 = 0, epsilon^4 = 0, epsilon^5 = 0, epsilon^6 = 0,
   epsilon^7 = 0, epsilon^8 = 0, epsilon^9 = 0, epsilon^10 = 0 }:

