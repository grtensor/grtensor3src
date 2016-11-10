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
constraint_ := [nu(u) = int(epsilon*v(x)/x/(2*v(x)^2-1),x = 0 .. u), lambda(u) = int(1/x/(2*v(x)^2-1),x = 0 .. u), chi(u) = int(1/(2*v(x)^2-1),x = 0 .. u),epsilon^2=1]:
