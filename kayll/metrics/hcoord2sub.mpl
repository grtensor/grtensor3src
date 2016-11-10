Ndim_ := 4:
x1_ := t:
x2_ := h:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := B*h^delta:
g22_ := 16*h^2/(2*C)^2/(h^alpha)/(h^delta)/(h-1)^4/(h+1)^4:
g33_ := 4*h^2/(h-1)^2/(h+1)^2/(h^delta)/(h^alpha)/(2*C)^2:
g44_ := 4*h^2*sin(theta)^2/(h-1)^2/(h+1)^2/(h^delta)/(h^alpha)/(2*C)^2:
constraint_ := [alpha^2+delta^2+alpha*delta-4 = 0]:
