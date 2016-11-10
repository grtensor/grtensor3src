Ndim_ := 4:
x1_ := t:
x2_ := theta:
x3_:= x1:
x4_:= x2:
complex_ := {}:
eta11_ := -1:
eta22_ := 1:
eta33_ := 1:
eta44_ := 1:
b11_ := exp(1/4*gamma(t,theta))*t^(1/4):
b22_ := exp(1/4*gamma(t,theta))*t^(1/4):
b33_ := -Q(t,theta)*(exp(P(t,theta))/t)^(1/2):
b34_ := (exp(P(t,theta))/t)^(1/2):
b43_ := 1/(t*exp(P(t,theta)))^(1/2):
constraint_ := [diff(gamma(t,theta),t)=-t*exp(P(t,theta))^2*diff(Q(t,theta),t)^2
-t*diff(P(t,theta),t)^2-t*exp(P(t,theta))^2*diff(Q(t,theta),theta)^2-t*diff(P(t,theta),theta)^2,
diff(gamma(t,theta),theta)=-2*t*diff(P(t,theta),theta)*diff(P(t,theta),t)-
2*t*exp(P(t,theta))^2*diff(Q(t,theta),t)*diff(Q(t,theta),theta),diff(P(t,theta),`$`(t,2)) = diff(P(t,theta),`$`(theta,2))-diff(P(t,theta),t)/t+exp(2*P(t,theta))*(diff(Q(t,theta),t)^2-diff(Q(t,theta),theta)^2),
diff(Q(t,theta),`$`(t,2)) = diff(Q(t,theta),`$`(theta,2))-diff(Q(t,theta),t)/t-2*diff(P(t,theta),t)*diff(Q(t,theta),t)+2*diff(P(t,theta),theta)*diff(Q(t,theta),theta)]:
