Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -exp(2*Phi(r)-2*B(r)):
g22_ := exp(2*B(r)):
g33_ := exp(2*B(r))*r^2:
g44_ := exp(2*B(r))*r^2*sin(theta)^2:
constraint_ := [B(r) = int(1/2*(2*r*diff(Phi(r),r)+epsilon*(-2*r*(-r*diff(Phi(r),r)^2+r*diff(Phi(r),`$`(r,2))-diff(Phi(r),r)))^(1/2))/r,r)+_C1]:
