Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := z:
x4_ := phi:
complex_ := {}:
g11_ := -1:
g22_ := R(t)^2:
g33_ := R(t)^2*sin(r+B)^2:
g44_ := R(t)^2*cos(r+A)^2:
constraint_ := [diff(diff(R(t),t),t) = -1/2*(diff(R(t),t)^2+1)/R(t)]:
