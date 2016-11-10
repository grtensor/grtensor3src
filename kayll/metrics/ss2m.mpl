Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   exp(lambda(r*(a*t)^(-1/a)))   :
g22_   :=   S(r*(a*t)^(-1/a))^2*r^2   :
g33_   :=    S(r*(a*t)^(-1/a))^2*r^2 *sin(theta)^2   :
g44_   :=   -exp(delta(r*(a*t)^(-1/a)))   :
Info_ := `    Self-similar metric "comoving form"    `: 
constraint_ := [diff(S(xi),`$`(xi,2))=1/2*(-4*diff(S(xi),xi)+diff(lambda(xi),xi)*xi*diff(S(xi),xi)+diff(lambda(xi),xi)*S(xi)+diff(delta(xi),xi)*xi*diff(S(xi),xi))/xi]:
