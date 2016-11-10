Ndim_ := 4:
x1_ := r:
x2_ := theta:
x3_ := phi:
x4_ := u:
sig_ := 2:
complex_ := {}:
g13_ := -a*sin(theta)^2:
g14_ := 1:
g22_ := r^2+a^2*cos(theta)^2:
g33_ := 1/(r^2+a^2*cos(theta)^2)*sin(theta)^2*r^4+2/(r^2+a^2*cos(theta)^2)*sin(theta)^2*r^2*a^2+1/(r^2+a^2*cos(theta)^2)*sin(theta)^2*a^4-1/(r^2+a^2*cos(theta)^2)*sin(theta)^4*a^2*r^2+2/(r^2+a^2*cos(theta)^2)*sin(theta)^4*a^2*m*r-1/(r^2+a^2*cos(theta)^2)*sin(theta)^4*a^4:
g34_ := -2*a/(r^2+a^2*cos(theta)^2)*m*r*sin(theta)^2:
g44_ := -1+2*m*r/(r^2+a^2*cos(theta)^2):
Info_ := `Equation 5.31, Kerr, Hawking and Ellis`:

