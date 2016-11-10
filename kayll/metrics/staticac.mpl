Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   a(r)  :
g22_   :=   r^2   :
g33_   :=   r^2*sin(theta)^2   :
g44_   :=   -b(r)   :
constraint_ :=    [int(rho(x)*x^2,x = 0 .. r)=1/4*r*(4*r^2*p(r)^2*Pi+4*r^2*p(r)*Pi*rho(r)+r*diff(p(r),r)+2*p(r)-2*P(r))/Pi/(2*r*diff(p(r),r)-rho(r)+3*p(r)-4*P(r))]:
