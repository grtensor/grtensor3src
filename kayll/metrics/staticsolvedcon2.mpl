Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   f(r)^2/(1-2*m(r)/r)  :
g22_   :=   f(r)^2*r^2   :
g33_   :=   f(r)^2*r^2*sin(theta)^2   :
g44_   :=   -f(r)^2*exp(2*Phi(r))   :
constraint_:=[m(r) = (Int(-1/2*r*exp(-Int((3*diff(f(r),r)*r*f(r)+3*r*f(r)^2*diff(Phi(r),r)-2*r^2*f(r)^2*diff(Phi(r),r)^2-2*f(r)*r^2*diff(f(r),`$`(r,2))+3*diff(f(r),r)^2*r^2-2*r^2*f(r)^2*diff(Phi(r),`$`(r,2))+3*f(r)^2)/f(r)/r/(f(r)*diff(Phi(r),r)*r+diff(f(r),r)*r+f(r)),r))*(-2*r*f(r)^2*diff(Phi(r),r)^2-2*f(r)*r*diff(f(r),`$`(r,2))+2*f(r)^2*diff(Phi(r),r)+3*diff(f(r),r)^2*r-2*r*f(r)^2*diff(Phi(r),`$`(r,2))+2*f(r)*diff(f(r),r))/f(r)/(f(r)*diff(Phi(r),r)*r+diff(f(r),r)*r+f(r)),r)+_C1)*exp(Int((3*diff(f(r),r)*r*f(r)+3*r*f(r)^2*diff(Phi(r),r)-2*r^2*f(r)^2*diff(Phi(r),r)^2-2*f(r)*r^2*diff(f(r),`$`(r,2))+3*diff(f(r),r)^2*r^2-2*r^2*f(r)^2*diff(Phi(r),`$`(r,2))+3*f(r)^2)/f(r)/r/(f(r)*diff(Phi(r),r)*r+diff(f(r),r)*r+f(r)),r))]:
