Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1/(r^2+a^2*cos(theta)^2)*r^2-1/(r^2+a^2*cos(theta)^2)*a^2-1/(r^2+a^2*cos(theta)^2)*exp(2)+2/(r^2+a^2*cos(theta)^2)*M*r+1/(r^2+a^2*cos(theta)^2)*a^2*sin(theta)^2:
g14_ := a*sin(theta)^2/(r^2+a^2*cos(theta)^2)*exp(2)-2*a*sin(theta)^2/(r^2+a^2*cos(theta)^2)*M*r:
g22_ := 1/(r^2+a^2+exp(2)-2*M*r)*r^2+1/(r^2+a^2+exp(2)-2*M*r)*a^2*cos(theta)^2:
g33_ := r^2+a^2*cos(theta)^2:
g44_ := sin(theta)^2/(r^2+a^2*cos(theta)^2)*r^4+2*sin(theta)^2/(r^2+a^2*cos(theta)^2)*r^2*a^2+sin(theta)^2/(r^2+a^2*cos(theta)^2)*a^4-sin(theta)^4/(r^2+a^2*cos(theta)^2)*a^2*r^2-sin(theta)^4/(r^2+a^2*cos(theta)^2)*a^4-sin(theta)^4/(r^2+a^2*cos(theta)^2)*a^2*exp(2)+2*sin(theta)^4/(r^2+a^2*cos(theta)^2)*a^2*M*r:
Info_ := `Equation 12.3.1, Kerr, Wald`:

