Ndim_ :=    4   :
x1_   :=   r   :
x2_   :=   theta   :
x3_   :=   phi   :
x4_   :=   t   :
g11_   :=   exp(lambda(r,t))   :
g22_   :=   exp(mu(r,t))  :
g33_   :=   exp(mu(r,t))*sin(theta)^2   :
g44_   :=   -exp(nu(r,t))   :
constraint_:=[diff(lambda(r,t),`$`(t,2))=-1/2*(-exp(mu(r,t))*diff(lambda(r,t),t)*exp(lambda(r,t))*diff(nu(r,t),t)+exp(mu(r,t))*diff(lambda(r,t),r)*diff(nu(r,t),r)*exp(nu(r,t))+exp(mu(r,t))*diff(lambda(r,t),t)^2*exp(lambda(r,t))-2*exp(mu(r,t))*diff(nu(r,t),`$`(r,2))*exp(nu(r,t))-exp(mu(r,t))*diff(nu(r,t),r)^2*exp(nu(r,t))+diff(mu(r,t),t)*exp(mu(r,t))*diff(nu(r,t),t)*exp(lambda(r,t))-2*diff(mu(r,t),`$`(t,2))*exp(mu(r,t))*exp(lambda(r,t))+2*diff(mu(r,t),`$`(r,2))*exp(mu(r,t))*exp(nu(r,t))-diff(mu(r,t),t)*exp(mu(r,t))*diff(lambda(r,t),t)*exp(lambda(r,t))-diff(mu(r,t),r)*exp(mu(r,t))*diff(lambda(r,t),r)*exp(nu(r,t))+diff(mu(r,t),r)*exp(mu(r,t))*diff(nu(r,t),r)*exp(nu(r,t))+4*exp(lambda(r,t))*exp(nu(r,t)))/exp(mu(r,t))/exp(lambda(r,t))]:
