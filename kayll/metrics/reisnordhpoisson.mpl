Ndim_ := 4:
x1_ := t:
x2_ := x:
x3_ := y:
x4_ := z:
sig_ := 2:
complex_ := {}:
g11_ := -1/(1+M/r)^2:
g22_ := 1+2*M/r+M^2/r^2:
g33_ := 1+2*M/r+M^2/r^2:
g44_ := 1+2*M/r+M^2/r^2:
constraint_ := [diff(r(x,y,z),x) = x/r, diff(r(x,y,z),y) = y/r, diff(r(x,y,z),z) = z/r]:
Info_ := `5.7 Problem 1d, Poisson`:

