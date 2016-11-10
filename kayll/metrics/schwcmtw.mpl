Ndim_ := 4:
x1_ := t:
x2_ := x:
x3_ := y:
x4_ := z:
sig_ := 2:
complex_ := {}:
g11_ := -((1-M/(2*r(x,y,z)))/(1+M/(2*r(x,y,z))))^2:
g22_ := (1+M/(2*r(x,y,z)))^4:
g33_ := (1+M/(2*r(x,y,z)))^4:
g44_ := (1+M/(2*r(x,y,z)))^4:
constraint_:=[r(x,y,z)=sqrt(x^2+y^2+z^2)]:
Info_ := `Equation 19.23, Schwarzschild, Misner-Thorne-Wheeler, Copyright GRTensor.org`:


