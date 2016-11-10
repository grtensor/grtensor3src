Ndim_ := 5:
x1_ := w:
x2_ := t:
x3_ := F:
x4_ := theta:
x5_ := phi:
sig_ := 5:
complex_ := {}:
g11_ := A*F^alpha:
g22_ := B*F^delta:
g33_ := 1/(C*F^(alpha+delta-2))/(F^(1/2)*(F-1))^4:
g44_ := 1/(C*F^(alpha+delta-2))/(F^(1/2)*(F-1))^2:
g55_ := 1/(C*F^(alpha+delta-2))/(F^(1/2)*(F-1))^2*sin(theta)^2:
constraint_ := [alpha^2+delta^2+alpha*delta = 1]:
