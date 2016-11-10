Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1/(r^2+S^2/M^2*cos(theta)^2)*r^2+2/(r^2+S^2/M^2*cos(theta)^2)*M*r-1/(r^2+S^2/M^2*cos(theta)^2)*S^2/M^2-1/(r^2+S^2/M^2*cos(theta)^2)*Q^2+sin(theta)^2/(r^2+S^2/M^2*cos(theta)^2)*S^2/M^2:
g14_ := -2/(r^2+S^2/M^2*cos(theta)^2)*r*S*sin(theta)^2+1/(r^2+S^2/M^2*cos(theta)^2)*Q^2*S/M*sin(theta)^2:
g22_ := 1/(r^2-2*M*r+S^2/M^2+Q^2)*r^2+1/(r^2-2*M*r+S^2/M^2+Q^2)*S^2/M^2*cos(theta)^2:
g33_ := r^2+S^2/M^2*cos(theta)^2:
g44_ := -1/(r^2+S^2/M^2*cos(theta)^2)*r^2*S^2/M^2*sin(theta)^4+2/(r^2+S^2/M^2*cos(theta)^2)/M*r*S^2*sin(theta)^4-1/(r^2+S^2/M^2*cos(theta)^2)*S^4/M^4*sin(theta)^4-1/(r^2+S^2/M^2*cos(theta)^2)*Q^2*S^2/M^2*sin(theta)^4+sin(theta)^2/(r^2+S^2/M^2*cos(theta)^2)*r^4+2*sin(theta)^2/(r^2+S^2/M^2*cos(theta)^2)*r^2*S^2/M^2+sin(theta)^2/(r^2+S^2/M^2*cos(theta)^2)*S^4/M^4:
Info_ := `Equation 33.2, Kerr-Newman, Misner-Thorne-Wheeler`:

