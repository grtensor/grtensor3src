Ndim_ := 4:
x1_ := t:
x2_ := x:
x3_ := theta:
x4_ := phi:
sig_ := -2:
complex_ := {}:
g11_ := (2*R(t,x)-1)/(2*R(t,x)*(x^2-t^2)):
g22_ := -(2*R(t,x)-1)/(2*R(t,x)*(x^2-t^2)):
g33_ := -R(t,x)^2:
g44_ := -R(t,x)^2*sin(theta)^2:
constraint_ := [diff(R(t,x),t) = -1/2*(2*R(t,x)-1)/R(t,x)/(x^2-t^2)*t, diff(R(t,x),x) = 1/2*(2*R(t,x)-1)/R(t,x)/(x^2-t^2)*x]:
Info_ := `Equation 12.28, Kurskal, Rindler, Copyright GRTensor.org`:


