Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   F(r)/(1-2*m(r)/r)  :
g22_   :=   F(r)*r^2  :
g33_   :=  F(r)*r^2*sin(theta)^2   :
g44_   :=   -exp(2*Phi(r))*exp(2*xi(r))*F(r)   :
constraint_:=[m(r) = (Int(r*exp(Int((-2*R(r)*diff(R(r),r)*diff(Phi(r),r)*r-diff(Phi(r),r)*R(r)^2+2*R(r)*diff(R(r),`$`(r,2))*r-R(r)*diff(R(r),r)+2*diff(Phi(r),r)^2*r*R(r)^2-2*diff(R(r),r)^2*r+2*diff(Phi(r),`$`(r,2))*r*R(r)^2)/R(r)/r/(diff(Phi(r),r)*R(r)+diff(R(r),r)),r))*(1-R(r)*diff(R(r),r)*diff(Phi(r),r)+R(r)*diff(R(r),`$`(r,2))-diff(R(r),r)^2+diff(Phi(r),`$`(r,2))*R(r)^2+diff(Phi(r),r)^2*R(r)^2)/R(r)/(diff(Phi(r),r)*R(r)+diff(R(r),r)),r)+_C1)*exp(Int((2*R(r)*diff(R(r),r)*diff(Phi(r),r)*r+diff(Phi(r),r)*R(r)^2-2*R(r)*diff(R(r),`$`(r,2))*r+R(r)*diff(R(r),r)-2*diff(Phi(r),r)^2*r*R(r)^2+2*diff(R(r),r)^2*r-2*diff(Phi(r),`$`(r,2))*r*R(r)^2)/r/(diff(Phi(r),r)*R(r)+diff(R(r),r))/R(r),r))]:
