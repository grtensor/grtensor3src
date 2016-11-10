Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1+2*G*M*r/(r^2+a^2*cos(theta)^2)^2:
g14_ := -2*G*M*a*r*sin(theta)^2/(r^2+a^2*cos(theta)^2)^2:
g22_ := 1/(r^2-2*G*M*r+a^2)*r^4+2/(r^2-2*G*M*r+a^2)*a^2*cos(theta)^2*r^2+1/(r^2-2*G*M*r+a^2)*a^4*cos(theta)^4:
g33_ := r^4+2*a^2*cos(theta)^2*r^2+a^4*cos(theta)^4:
g44_ := sin(theta)^2*r^4+2*a^2*sin(theta)^2*r^2+a^4*sin(theta)^2-sin(theta)^4*a^2*r^2+2*sin(theta)^4*a^2*G*M*r-sin(theta)^4*a^4:
Info_ := `Equation 6.70, Kerr, Carroll`:

