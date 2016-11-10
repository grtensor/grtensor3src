Ndim_ := 3:
x1_ := u:
x2_ := v:
x3_ := theta:
complex_ := {}:
g12_ := -exp(sigma[0])^2*(r(u,v)/u)^(1-alpha):
g33_ := r(u,v)^2:
constraint_ := [r(u,v) = beta*(alpha*v)^(1/alpha)+gamma*u]:
