Ndim_ := 4:
x1_ := v:
x2_ := r:
x3_ := theta:
x4_ := xi:
sig_ := 2:
complex_ := {}:
g11_ := -1/(r^2-a^2*cos(theta)^2)*r^2+2/(r^2-a^2*cos(theta)^2)*M*r-1/(r^2-a^2*cos(theta)^2)*a^2+1/(r^2-a^2*cos(theta)^2)*a^2*sin(theta)^2:
g12_ := 1:
g14_ := -2*a*M*r*sin(theta)^2/(r^2-a^2*cos(theta)^2):
g24_ := -a*sin(theta)^2:
g33_ := r^2-a^2*cos(theta)^2:
g44_ := sin(theta)^2/(r^2-a^2*cos(theta)^2)*r^4+2*sin(theta)^2/(r^2-a^2*cos(theta)^2)*r^2*a^2+sin(theta)^2/(r^2-a^2*cos(theta)^2)*a^4-sin(theta)^4/(r^2-a^2*cos(theta)^2)*a^2*r^2+2*sin(theta)^4/(r^2-a^2*cos(theta)^2)*a^2*M*r-sin(theta)^4/(r^2-a^2*cos(theta)^2)*a^4:
Info_ := `5.7 Problem 8c, Poisson`:

