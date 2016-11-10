Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := z:
x4_ := phi:
sig_ := 2:
complex_ := {}:
eta11_ := -1:
eta22_ := 1:
eta33_ := 1:
eta44_ := 1:
bd11_ := exp(lambda(r,z)):
bd22_ := exp(nu(r,z))/exp(lambda(r,z)):
bd33_ := exp(nu(r,z))/exp(lambda(r,z)):
bd44_ := r/exp(lambda(r,z)):
constraint_ := [lambda(r,z) = -M/(r^2+z^2)^(1/2), nu(r,z) = -1/2*M^2*r^2/(r^2+z^2)^2]:
