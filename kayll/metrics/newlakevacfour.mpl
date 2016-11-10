Ndim_ := 4:
x1_ := t:
x2_ := h:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -h^delta:
g22_ := 1/beta/(h^alpha)*h^2/(h^delta)/(-epsilon*h*h^(1/2*(1/epsilon/nu)^(1/2))+nu*h*h^(-1/2*(1/epsilon/nu)^(1/2)))^4:
g33_ := 1/beta/(h^alpha)*h^2/(h^delta)/(-epsilon*h*h^(1/2*(1/epsilon/nu)^(1/2))+nu*h*h^(-1/2*(1/epsilon/nu)^(1/2)))^2:
g44_ := 1/beta/(h^alpha)*h^2/(h^delta)/(-epsilon*h*h^(1/2*(1/epsilon/nu)^(1/2))+nu*h*h^(-1/2*(1/epsilon/nu)^(1/2)))^2*sin(theta)^2:
constraint_ := [nu = 1/epsilon/(alpha^2+delta^2+alpha*delta)]:
