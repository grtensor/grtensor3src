Ndim_ := 4:
x1_ := T:
x2_ := R:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -32*G^3*M^3/r(T,R)*(1-1/2*r(T,R)/G/M)/(T^2-R^2):
g22_ := 32*G^3*M^3/r(T,R)*(1-1/2*r(T,R)/G/M)/(T^2-R^2):
g33_ := r(T,R)^2:
g44_ := r(T,R)^2*sin(theta)^2:
constraint_ := [diff(r(T,R),T) = -8*T*G^2*M^2/r(T,R)*(1-1/2*r(T,R)/G/M)/(T^2-R^2), diff(r(T,R),R) = 8*R*G^2*M^2/r(T,R)*(1-1/2*r(T,R)/G/M)/(T^2-R^2)]:
Info_ := `Equation 5.123, Schwarzschild, Kruskal coordinates, Carroll, Copyright GRTensor.org`:

