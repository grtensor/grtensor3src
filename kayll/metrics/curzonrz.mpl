Ndim_ := 2:
x1_ := r:
x2_ := z:
sig_ := 2:
complex_ := {}:
g11_ := exp(nu(r,z))^2/exp(lambda(r,z))^2:
g22_ := exp(nu(r,z))^2/exp(lambda(r,z))^2:
constraint_ := [lambda(r,z) = -M/(r^2+z^2)^(1/2), nu(r,z) = -1/2*M^2*r^2/(r^2+z^2)^2]:
