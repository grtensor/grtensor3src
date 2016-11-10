Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := z:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -exp(lambda(r,z))^2:
g22_ := exp(nu(r,z))^2/exp(lambda(r,z))^2:
g33_ := exp(nu(r,z))^2/exp(lambda(r,z))^2:
g44_ := r^2/exp(lambda(r,z))^2:
constraint_ := [lambda(r,z) = -m/R(r,z), nu(r,z) = -1/2*m^2*r^2/R(r,z)^4]:
