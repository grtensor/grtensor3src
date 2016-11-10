Ndim_ := 5:
x1_ := w:
x2_ := t:
x3_ := h:
x4_ := theta:
x5_ := phi:
sig_ := 5:
complex_ := {}:
g11_ := h^alpha*A:
g22_ := -h^delta:
g33_ := 1/beta/(h^alpha)*h^2/(h^delta)/(-epsilon*h*h^(1/2*(1/epsilon/nu)^(1/2))+nu*h*h^(-1/2*(1/epsilon/nu)^(1/2)))^4:
g44_ := 1/beta/(h^alpha)*h^2/(h^delta)/(-epsilon*h*h^(1/2*(1/epsilon/nu)^(1/2))+nu*h*h^(-1/2*(1/epsilon/nu)^(1/2)))^2:
g55_ := 1/beta/(h^alpha)*h^2/(h^delta)/(-epsilon*h*h^(1/2*(1/epsilon/nu)^(1/2))+nu*h*h^(-1/2*(1/epsilon/nu)^(1/2)))^2*sin(theta)^2:
constraint_ := [nu = 1/epsilon/(alpha^2+delta^2+alpha*delta)]:
