Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -diff(B(t,r),t)^2*exp(-2*F1(t)):
g22_ := exp(2*B(t,r)):
g33_ := exp(2*B(t,r))*r^2:
g44_ := exp(2*B(t,r))*r^2*sin(theta)^2:
constraint_ := [B(t,r) = int(1/2*(2*r*diff(Phi(t,r),r)+(-2*r*(-r*diff(Phi(t,r),r)^2-diff(Phi(t,r),r)+r*diff(Phi(t,r),`$`(r,2))))^(1/2))/r,r)+_F1(t)]:
