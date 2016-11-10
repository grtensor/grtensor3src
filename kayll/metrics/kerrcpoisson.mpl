Ndim_ := 4:
x1_ := v:
x2_ := r:
x3_ := theta:
x4_ := xi:
sig_ := 2:
complex_ := {}:
g11_ := -1+2*M*r/(r^2-a^2*cos(theta)^2):
g12_ := 1:
g14_ := -2*M*r/(r^2-a^2*cos(theta)^2)*a*sin(theta)^2:
g24_ := -a*sin(theta)^2:
g33_ := r^2-a^2*cos(theta)^2:
g44_ := sin(theta)^2*r^2+sin(theta)^2*a^2+2*M*r/(r^2-a^2*cos(theta)^2)*a^2*sin(theta)^4:
Info_ := `Equation 5.65b, Kerr, Poisson`:

