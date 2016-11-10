Ndim_ := 4:
x1_ := t:
x2_ := r1:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1+2*G*M/r:
g22_ := 1-2*G*M/r:
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(r1),r1) = diff(r(r1,r),r1)+2*diff(G(r1,r),r1)*M(r1,r)*ln(1/2*r/G/M-1)(r1,r)+2*G(r1,r)*diff(M(r1,r),r1)*ln(1/2*r/G/M-1)(r1,r)+2*G(r1,r)*M(r1,r)*D[1](ln(1/2*r/G/M-1))(r1,r)]:
Info_ := `Equation 5.109, Schwarzschild, tortoise coordinates, Carroll`:

