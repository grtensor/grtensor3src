Ndim_ := 4:

x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := t:

g11_ := 1/(1-2*m/r)*(1+epsilon*H[2](r,t)*u(theta)):
g12_ := 0:
g13_ := 0:
g14_ := epsilon*H[1](r,t)*u(theta):
g22_ := r^2*(1+epsilon*K(r,t)*u(theta)):
g23_ := 0:
g24_ := 0:
g33_ := r^2*sin(theta)^2*(1+epsilon*K(r,t)*u(theta)):
g34_ := 0:
g44_ := -(1-2*m/r)*(1-epsilon*H[0](r,t)*u(theta)):

complex_ := {}:

lperts := {H[0](r,t),H[1](r,t),H[2](r,t),K(r,t),
   diff(H[0](r,t),r),diff(H[1](r,t),r),diff(H[2](r,t),r),diff(K(r,t),r),
   diff(H[0](r,t),t),diff(H[1](r,t),t),diff(H[2](r,t),t),diff(K(r,t),t),
   diff(H[0](r,t),r,r),diff(H[1](r,t),r,r),diff(H[2](r,t),r,r),diff(K(r,t),r,r),
   diff(H[0](r,t),t,t),diff(H[1](r,t),t,t),diff(H[2](r,t),t,t),diff(K(r,t),t,t),
   diff(H[0](r,t),r,t),diff(H[1](r,t),r,t),diff(H[2](r,t),r,t),diff(K(r,t),r,t)
   }:

ufuncs := {u(theta), diff(u(theta),theta), diff(u(theta),theta$2) }:

constraint_ := { epsilon^2 = 0, epsilon^3 = 0, epsilon^4 = 0, epsilon^5 = 0, 
   epsilon^6 = 0, epsilon^7 = 0, epsilon^8 = 0, epsilon^9 = 0, 
   epsilon^10 = 0 } :
   
