Ndim_ := 4:
x1_ := t:
x2_ := rho:
x3_ := z:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -exp(U(rho,z))^2:
g22_ := 1/exp(U(rho,z))^2*exp(gamma(rho,z))^2:
g33_ := 1/exp(U(rho,z))^2*exp(gamma(rho,z))^2:
g44_ := 1/exp(U(rho,z))^2*rho^2:
constraint_ := [U(rho,z) = -m/(rho^2+z^2)^(1/2), gamma(rho,z) = -1/2*m^2*rho^2/(rho^2+z^2)^2]:
