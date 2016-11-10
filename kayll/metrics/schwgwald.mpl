Ndim_ := 4:
x1_ := T:
x2_ := X:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -32*M^3*exp(-1/2*r/M)/r:
g22_ := 32*M^3*exp(-1/2*r/M)/r:
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(X,T),X) = X*M^2/exp(1/2*r/M)/r, diff(r(X,T),T) = 8*T*M^2/exp(1/2*r/M)/r, diff(t(X,T),X) = 4*T*M/(-X^2+T^2), diff(t(X,T),T) = -4*X*M/(-X^2+T^2)]:
Info_ := `Equation 6.4.29, Schwarzschild, Wald`:

