Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := z:
x4_ := phi:
sig_ := -2:
complex_ := {}:
eta12_ := 1:
eta34_ := -1:
bd11_ := r:
bd14_ := -r^2/exp(lambda(r,z))^2:
bd21_ := 1/2/r*exp(lambda(r,z))^2:
bd24_ := 1/2:
bd32_ := -1/2*2^(1/2)*exp(nu(r,z))/exp(lambda(r,z)):
bd33_ := -1/2*I*2^(1/2)*exp(nu(r,z))/exp(lambda(r,z)):
bd42_ := -1/2*2^(1/2)*exp(nu(r,z))/exp(lambda(r,z)):
bd43_ := 1/2*I*2^(1/2)*exp(nu(r,z))/exp(lambda(r,z)):
constraint_ := [lambda(r,z) = -M/(r^2+z^2)^(1/2), nu(r,z) = -1/2*M^2*r^2/(r^2+z^2)^2]:
