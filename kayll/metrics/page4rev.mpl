Ndim_ := 4:
x1_ := t:
x2_ := u:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -exp(nu(u))^2:
g22_ := 1/4/exp(nu(u))^2*exp(lambda(u))^2/chi(u)/(w(u))^2:
g33_ := 1/exp(nu(u))^2*exp(lambda(u))^2*chi(u):
g44_ := 1/exp(nu(u))^2*exp(lambda(u))^2*chi(u)*sin(theta)^2:
constraint_ := [diff(nu(u),u) = sqrt((w(u)+1)/2)/u/(w(u)), diff(lambda(u),u) = 1/u/(w(u)), diff(chi(u),u) = 1/(w(u))]:
