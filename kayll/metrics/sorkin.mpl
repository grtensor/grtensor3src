Ndim_ := 5:
x1_ := t:
x2_ := r:
x3_ := z:
x4_ := theta:
x5_ := phi:
sig_ := 4:
complex_ := {}:
g11_ := -1:
g22_ := 1+2*m/rho(r)+m^2/rho(r)^2:
g33_ := 4*m^2*r^2/(rho(r)+m)^2:
g44_ := r^2:
g55_ := r^2*sin(theta)^2:
constraint_ := [rho(r) = (r^2+m^2)^(1/2)]:
