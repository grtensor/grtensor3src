Ndim_ := 4:
x1_ := t:
x2_ := u:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -exp(nu(u))^2:
g22_ := 1/4/exp(nu(u))^2*exp(lambda(u))^2/chi(u)/(2*v(u)^2-1)^2:
g33_ := 1/exp(nu(u))^2*exp(lambda(u))^2*chi(u):
g44_ := 1/exp(nu(u))^2*exp(lambda(u))^2*chi(u)*sin(theta)^2:
constraint_ := [diff(nu(u),u) = epsilon*v(u)/u/(2*v(u)^2-1), diff(lambda(u),u) = 1/u/(2*v(u)^2-1), diff(chi(u),u) = 1/(2*v(u)^2-1),epsilon^2=1]:
