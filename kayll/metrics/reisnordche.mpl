Ndim_ := 4:
x1_ := v:
x2_ := w:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g12_ := 32*r1^4/(r1-r2)^2*cosec(2*v)*cosec(2*w)-64*r1^4/(r1-r2)^2*cosec(2*v)*cosec(2*w)*m/r(v,w)+32*r1^4/(r1-r2)^2*cosec(2*v)*cosec(2*w)*e^2/r(v,w)^2:
g33_ := r(v,w)^2:
g44_ := r(v,w)^2*sin(theta)^2:
constraint_ := [diff(r(v,w),v) = 2*tan(w)*r1^2*(r(v,w)-r1)^(1/2)*(-r(v,w)+r2-tan(v)^2*r(v,w)+tan(v)^2*r2)/exp(1/2*(r1-r2)/r1^2*r(v,w))/((r(v,w)-r2)^(-1/2/r1^2*r2^2))/r(v,w)^2/(r1-r2), diff(r(v,w),w) = 2*tan(v)*r1^2*(r(v,w)-r1)^(1/2)*(-r(v,w)+r2-tan(w)^2*r(v,w)+tan(w)^2*r2)/exp(1/2*(r1-r2)/r1^2*r(v,w))/((r(v,w)-r2)^(-1/2/r1^2*r2^2))/r(v,w)^2/(r1-r2)]:
Info_ := `Equation 5.28, Reissner-Nordstrom, Hawking and Ellis, Copyright GRTensor.org`:


