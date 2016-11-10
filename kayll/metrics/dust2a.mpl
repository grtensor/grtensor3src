Ndim_ := 4 :
x1_ := r :
x2_ := theta :
x3_ := phi :
x4_ := t :
g11_ := diff(R(r,t),r)^2/(w(r)) :
g22_ := R(r,t)^2 :
g33_ := R(r,t)^2*sin(theta)^2 :
g44_ := -1 :

constraint_ := [

diff(R(r,t), r, t, t) = 2*M(r)*diff(R(r,t), r)/R(r,t)^3
                      - diff(M(r), r)/R(r,t)^2 ,

diff(R(r,t), r, t) = ( 2*diff(M(r), r)/R(r,t) 
                     - 2*M(r)*diff(R(r,t), r)/R(r,t)^2
                     + diff(w(r), r) ) 
                          / ( 2*diff(R(r,t), t) ), 

diff(R(r,t), t, t) = - M(r)/R(r,t)^2, 

diff(R(r,t), t)^2 =  2*M(r)/R(r,t) + w(r)-1,

diff(R(r,t), r) = 1/4*diff(M(r),r)/pi/rho(r,t)/R(r,t)^2

]:
Info_:=`Tolman metric with constraints by C.W.Hellaby`:

