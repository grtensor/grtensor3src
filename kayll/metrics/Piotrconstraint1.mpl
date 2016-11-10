Ndim_ := 4:
x1_ := t:
x2_ := theta:
x3_ := x1:
x4_ := x2:
complex_ := {}:
g11_ := -exp(-1/2*gamma(t,theta))/t^(1/2):
g22_ := exp(-1/2*gamma(t,theta))/t^(1/2):
g33_ := t*exp(P(t,theta)):
g34_ := t*exp(P(t,theta))*Q(t,theta):
g44_ := t*exp(P(t,theta))*Q(t,theta)^2+t/exp(P(t,theta)):
constraint_ := [diff(gamma(t,theta),t) = -t*exp(P(t,theta))^2*diff(Q(t,theta),t)^2-t*diff(P(t,theta),t)^2
-t*exp(P(t,theta))^2*diff(Q(t,theta),theta)^2-t*diff(P(t,theta),theta)^2,diff(gamma(t,theta),theta) = 
-2*t*diff(P(t,theta),theta)*diff(P(t,theta),t)-2*t*exp(P(t,theta))^2*diff(Q(t,theta),t)*diff(Q(t,theta),theta)]:
