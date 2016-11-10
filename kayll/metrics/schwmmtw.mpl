Ndim_ := 4:
x1_ := psi:
x2_ := xi:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -8*M^3*exp(-1/2*r/M)/r/(cos(1/2*psi)*cos(1/2*xi)-sin(1/2*psi)*sin(1/2*xi))^2/(cos(1/2*psi)*cos(1/2*xi)+sin(1/2*psi)*sin(1/2*xi))^2:
g22_ := 8*M^3*exp(-1/2*r/M)/r/(cos(1/2*psi)*cos(1/2*xi)-sin(1/2*psi)*sin(1/2*xi))^2/(cos(1/2*psi)*cos(1/2*xi)+sin(1/2*psi)*sin(1/2*xi))^2:
g33_ := r^2:
g44_ := r^2*sin(theta)^2:
constraint_ := [diff(r(psi,xi),psi) = -2*M^2*(tan(1/2*psi+1/2*xi)*tan(1/2*psi-1/2*xi)^2+tan(1/2*psi-1/2*xi)+tan(1/2*psi-1/2*xi)*tan(1/2*psi+1/2*xi)^2+tan(1/2*psi+1/2*xi))/exp(1/2*r/M)/r, diff(r(psi,xi),xi) = -2*M^2*(-tan(1/2*psi+1/2*xi)*tan(1/2*psi-1/2*xi)^2+tan(1/2*psi-1/2*xi)+tan(1/2*psi-1/2*xi)*tan(1/2*psi+1/2*xi)^2-tan(1/2*psi+1/2*xi))/exp(1/2*r/M)/r]:
Info_ := `Equation 34.3d, Schwarzschild, Misner-Thorne-Wheeler`:

