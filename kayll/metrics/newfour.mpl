Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := B*(1-1/(c*r))^delta:
g22_ := 1/(1-1/(c*r))^(alpha+delta):
g33_ := r^2/(1-1/(c*r))^(alpha+delta-1):
g44_ := r^2/(1-1/(c*r))^(alpha+delta-1)*sin(theta)^2:
constraint_ := [alpha^2+delta^2+alpha*delta-1 = 0]:
