Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -1+2*M*r/(r^2+J^2/M^2*cos(theta)^2):
g14_ := -2*J*r*sin(theta)^2/(r^2+J^2/M^2*cos(theta)^2):
g22_ := 1/(r^2-2*M*r+J^2/M^2)*r^2+1/(r^2-2*M*r+J^2/M^2)*J^2/M^2*cos(theta)^2:
g33_ := r^2+J^2/M^2*cos(theta)^2:
g44_ := sin(theta)^2*r^2+sin(theta)^2*J^2/M^2+2*sin(theta)^4/M*r*J^2/(r^2+J^2/M^2*cos(theta)^2):
Info_ := `Equation 15.1, Kerr Metric of a Rotating Black Hole, Hartle`:

