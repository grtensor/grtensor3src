Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   a^2/(1-2*m(r)/r)  :
g22_   :=   a^2*r^2   :
g33_   :=   a^2*r^2*sin(theta)^2   :
g44_   :=   -a^2*exp(2*Phi(r))   :
constraint_:=[m(r) = (int(r*exp(int((2*r^2*diff(Phi(r),`$`(r,2))+2*diff(Phi(r),r)^2*r^2-3*diff(Phi(r),r)*r-3)/r/(diff(Phi(r),r)*r+1),r))*(diff(Phi(r),`$`(r,2))*r+diff(Phi(r),r)^2*r-diff(Phi(r),r))/(diff(Phi(r),r)*r+1),r)+_C1)*exp(int((3-2*diff(Phi(r),r)^2*r^2+3*diff(Phi(r),r)*r-2*r^2*diff(Phi(r),`$`(r,2)))/r/(diff(Phi(r),r)*r+1),r))]:
