Ndim_ := 4:
x1_ := V:
x2_ := U:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -32*m^3/R(V,U)*exp(-1/2*R(V,U)/m):
g22_ := 32*m^3/R(V,U)*exp(-1/2*R(V,U)/m):
g33_ := R(V,U)^2:
g44_ := R(V,U)^2*sin(theta)^2:
constraint_ := [R(V,U) = 2*(LambertW(-(V-U)*(V+U)*exp(-1))+1)*m]:
