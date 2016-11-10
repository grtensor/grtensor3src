Ndim_ := 3:
x1_ := theta:
x2_ := phi:
x3_ :=t:
complex_ := {}:
g11_ := 2*m^2*x(theta)/(x(theta)-1)^2:
g22_ := 2*m^2*sin(theta)^2*x(theta)+2*m^2*sin(theta)^4*A^2:
g23_ := -a*sin(theta)^2:
constraint_ := [x(theta) = 1+(1-A^2*cos(theta)^2)^(1/2)]:
Info_:=`Kerr SLS .`:
