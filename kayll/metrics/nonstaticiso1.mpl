Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -exp(2*Phi(t,r)-2*B(t,r)):
g22_ := exp(2*B(t,r)):
g33_ := exp(2*B(t,r))*r^2:
g44_ := exp(2*B(t,r))*r^2*sin(theta)^2:
constraint_ := [B(t,r) = Phi(t,r)+1/2*epsilon*int((diff(Phi(t,r),r)^2-diff(Phi(t,r),`$`(r,2))+diff(Phi(t,r),r)/r)^(1/2),r)*2^(1/2)+_F1(t)]:
