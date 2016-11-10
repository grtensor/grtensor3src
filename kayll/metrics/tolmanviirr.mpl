Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
complex_ := {}:
g11_ := -B^2*sin(ln(((a(r)^(1/2)+b(r))/C)^(1/2)) )^2:
g22_ := 1/a(r):
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [a(r) = 1-r^2/K^2+4*r^4/A^4, b(r) = 2*r^2/A^2-1/4*A^2/K^2]:
