Ndim_ :=    4   :
x1_   :=   theta   :
x2_   :=   phi   :
x3_   :=   psi   :
x4_   :=   t   :
g11_   :=   cos(psi)^2*exp(a(t))^2+sin(psi)^2*exp(b(t))^2   :
g12_   :=   -sin(psi)*cos(psi)*sin(theta)*(exp(b(t))-exp(a(t)))*(exp(b(t))+exp(a(t)))   :
g22_   :=   sin(psi)^2*sin(theta)^2*exp(a(t))^2+cos(psi)^2*sin(theta)^2*exp(b(t))^2+cos(theta)^2*exp(c(t))^2   :
g23_   :=   exp(c(t))^2*cos(theta)   :
g33_   :=   exp(c(t))^2   :
g44_   :=   -exp(a(t))^2*exp(b(t))^2*exp(c(t))^2   :
Info_ := `    Mixmaster metric (e.g. MTW Box 30.1)   `: 

