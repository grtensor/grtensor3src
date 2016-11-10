Ndim_ := 4:
x1_ := t:
x2_ := F:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := B*F^delta:
g22_ := 1/(C*F^(alpha+delta-2))/(F^(1/2)*(F-1))^4:
g33_ := 1/(C*F^(alpha+delta-2))/(F^(1/2)*(F-1))^2:
g44_ := 1/(C*F^(alpha+delta-2))/(F^(1/2)*(F-1))^2*sin(theta)^2:
constraint_ := [alpha^2+delta^2+alpha*delta = 1]:
