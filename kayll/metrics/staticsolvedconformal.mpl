Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   1/(1-2*m(r)/r-A(r)/r)  :
g22_   :=   r^2   :
g33_   :=   r^2*sin(theta)^2   :
g44_   :=   -exp(2*Phi(r))   :
constraint_:=[m(r) = (int(r*exp(int((2*r^2*diff(Phi(r),`$`(r,2))+2*diff(Phi(r),r)^2*r^2-3*diff(Phi(r),r)*r-3)/r/(diff(Phi(r),r)*r+1),r))*(diff(Phi(r),`$`(r,2))*r+diff(Phi(r),r)^2*r-diff(Phi(r),r))/(diff(Phi(r),r)*r+1),r)+C)*exp(int((3-2*diff(Phi(r),r)^2*r^2+3*diff(Phi(r),r)*r-2*r^2*diff(Phi(r),`$`(r,2)))/r/(diff(Phi(r),r)*r+1),r))]:
