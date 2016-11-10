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
constraint_ := [a(r) = 1-(r/K)^2+(3/5)*(1/alpha^2)*(r/K)^4, b(r) = (1/alpha)*sqrt(3/5)*((r/K)^2-5*alpha^2/6)]:
