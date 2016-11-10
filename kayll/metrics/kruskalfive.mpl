Ndim_ :=    5   :
x1_   :=   u   :
x2_   :=   v   :
x3_   :=   Theta   :
x4_   :=   Phi   :
x5_   :=   w:
g11_   :=   16*m^2/r(u,v)*(r(u,v)-2*m)/(u^2-v^2)   :
g22_   :=   -16*m^2/r(u,v)*(r(u,v)-2*m)/(u^2-v^2)   :
g33_   :=   r(u,v)^2   :
g44_   :=   r(u,v)^2*sin(Theta)^2   :
g55_   :=   f(u,v):
constraint_ :=   [diff(r(u,v),u) = 4*u*m/(-u^2+v^2)*(-r(u,v)+2*m)/r(u,v), diff(r(u,v),v) = -4*v*m/(-u^2+v^2)*(-r(u,v)+2*m)/r
(u,v)]   :

