Ndim_ := 4:
x1_ := t:
x2_ := theta:
x3_ := phi:
x4_ := psi:
sig_ := 2:
complex_ := {}:
g11_ := -1/(-1+2/(t^2+l^2)*m*t+2/(t^2+l^2)*l^2):
g22_ := t^2+l^2:
g33_ := -4*l^2*cos(theta)^2+8*l^2/(t^2+l^2)*m*t*cos(theta)^2+8*l^4/(t^2+l^2)*cos(theta)^2+t^2*sin(theta)^2+l^2*sin(theta)^2:
g34_ := -4*l^2*cos(theta)+8*l^2/(t^2+l^2)*m*t*cos(theta)+8*l^4/(t^2+l^2)*cos(theta):
g44_ := -4*l^2+8*l^2/(t^2+l^2)*m*t+8*l^4/(t^2+l^2):
Info_ := `Equation 5.32, Taub-NUT, Hawking and Ellis`:

