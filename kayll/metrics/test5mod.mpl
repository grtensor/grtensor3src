Ndim_ := 4:
x1_ := t:
x2_ := theta:
x3_ := x1:
x4_ := x2:
complex_ := {}:
eta11_ := -1:
eta22_ := 1:
eta33_ := 1:
eta44_ := 1:
b11_ := exp(1/4*Gamma(t,theta))*t^(1/4):
b22_ := exp(1/4*Gamma(t,theta))*t^(1/4):
b33_ := -Q(t,theta)*(t^hv(theta)*exp(Z(t,theta)))^(1/2):
b34_ := (t^hv(theta)*exp(Z(t,theta)))^(1/2):
b43_ := 1/(t^2*t^hv(theta)*exp(Z(t,theta)))^(1/2):
constraint_ := [diff(Gamma(t,theta),t) = -t*exp((1+hv(theta))*ln(t)+Z(t,theta))^2*diff(Q(t,theta),t)^2-t*((1+hv(theta))/t+diff(Z(t,theta),t))^2-t*exp((1+hv(theta))*ln(t)+Z(t,theta))^2*diff(Q(t,theta),theta)^2-t*(diff(hv(theta),theta)*ln(t)+diff(Z(t,theta),theta))^2, diff(Gamma(t,theta),theta) = -2*t*(diff(hv(theta),theta)*ln(t)+diff(Z(t,theta),theta))*((1+hv(theta))/t+diff(Z(t,theta),t))-2*t*exp((1+hv(theta))*ln(t)+Z(t,theta))^2*diff(Q(t,theta),t)*diff(Q(t,theta),theta)]:
