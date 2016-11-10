Ndim_ := 4:
x1_ := t:
x2_ := r:
x3_ := theta:
x4_ := phi:
sig_ := 2:
complex_ := {}:
g11_ := -r^2:
g22_ := 1/(1-k*r^2):
g33_ := f(t)*r^2:
g44_ := f(t)*r^2*sin(theta)^2:
constraint_ := [f(t) = 1/2+1/2*G*exp(2*t)+1/2*H*exp(-2*t)]:
Info_ := `Gutman Bespal'ko space `:
Ref_:=["Gutman, sspgt, p201, (1967)","Wesson, jmp, v19, p2283, (1978)","Lake, grg, v15, p357, (1983)"]:
Archive1_:=`(14.67) p173`: 
Archive2_:=`GutmanBespalko.dia `:
