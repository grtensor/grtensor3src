Ndim_ := 5:
x1_ := w:
x2_ := t:
x3_ := r:
x4_ := theta:
x5_ := phi:
sig_ := 5:
complex_ := {}:
g11_ := A*(1-1/(C*r))^(alpha):
g22_ := B*(1-1/(C*r))^(delta):
g33_ := F*1/(1-1/(C*r))^(epsilon):
g44_ := F*r^2/(1-1/(C*r))^(epsilon-1):
g55_ := F*r^2/(1-1/(C*r))^(epsilon-1)*sin(theta)^2:
constraint_ := [alpha^2+delta^2+alpha*delta-1 = 0]:
