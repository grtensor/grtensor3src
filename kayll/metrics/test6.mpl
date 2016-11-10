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
b11_ := exp(1/4*hg(t,theta)):
b22_ := exp(1/4*hg(t,theta)):
b33_ := -Q(t,theta)*(t^hv(theta)*exp(Z(t,theta)))^(1/2):
b34_ := (t^hv(theta)*exp(Z(t,theta)))^(1/2):
b43_ := 1/t/(t^hv(theta)*exp(Z(t,theta)))^(1/2):
constraint_ := [diff(hg(t,theta),t) = -1/t*(t^2*exp(ln(t)+hv(theta)*ln(t)+Z(t,theta))^2*diff(Q(t,theta),t)^2+2*hv(theta)+2*diff(Z(t,theta),t)*t+hv(theta)^2+2*hv(theta)*diff(Z(t,theta),t)*t+diff(Z(t,theta),t)^2*t^2+t^2*exp(ln(t)+hv(theta)*ln(t)+Z(t,theta))^2*diff(Q(t,theta),theta)^2+t^2*diff(hv(theta),theta)^2*ln(t)^2+2*t^2*diff(hv(theta),theta)*ln(t)*diff(Z(t,theta),theta)+t^2*diff(Z(t,theta),theta)^2), diff(hg(t,theta),theta) = -2*diff(hv(theta),theta)*ln(t)-2*diff(hv(theta),theta)*ln(t)*hv(theta)-2*diff(hv(theta),theta)*ln(t)*diff(Z(t,theta),t)*t-2*diff(Z(t,theta),theta)-2*diff(Z(t,theta),theta)*hv(theta)-2*diff(Z(t,theta),theta)*diff(Z(t,theta),t)*t-2*t*exp(ln(t)+hv(theta)*ln(t)+Z(t,theta))^2*diff(Q(t,theta),t)*diff(Q(t,theta),theta)]:
