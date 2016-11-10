Ndim_ := 5:
x1_ := w:
x2_ := t:
x3_ := h:
x4_ := theta:
x5_ := phi:
sig_ := 5:
complex_ := {}:
g11_ := A*h^alpha:
g22_ := B*h^delta:
g33_ := 16*h^2/(2*C)^2/(h^alpha)/(h^delta)/(h-1)^4/(h+1)^4:
g44_ := 4*h^2/(h-1)^2/(h+1)^2/(h^delta)/(h^alpha)/(2*C)^2:
g55_ := 4*h^2*sin(theta)^2/(h-1)^2/(h+1)^2/(h^delta)/(h^alpha)/(2*C)^2:
constraint_ := [alpha^2+delta^2+alpha*delta-4 = 0]:
