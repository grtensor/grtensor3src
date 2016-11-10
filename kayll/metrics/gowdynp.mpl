Ndim_ := 4:
x1_ := tau:
x2_ := x:
x3_ := y:
x4_ := z:
complex_ := {}:
eta12_ := 1:
eta34_ := -1:
bd11_ := exp(1/2*lambda(tau,x))*exp(-3/2*tau):
bd12_ := exp(lambda(tau,x)-tau)^(1/2):
bd21_ := 1/2*exp(1/2*lambda(tau,x))^2*exp(1/2*tau)/exp(lambda(tau,x)-tau)*exp(-3/2*tau):
bd22_ := -1/2/exp(lambda(tau,x)-tau)^(1/2)*exp(1/2*lambda(tau,x))*exp(1/2*tau):
bd33_ := -1/2*I*2^(1/2)/(exp(P)*exp(tau))^(1/2)*exp(P):
bd34_ := -1/2*2^(1/2)*(I*exp(P)*Q+1)/(exp(P)*exp(tau))^(1/2):
bd43_ := 1/2*I*2^(1/2)/(exp(P)*exp(tau))^(1/2)*exp(P):
bd44_ := 1/2*2^(1/2)*(I*exp(P)*Q-1)/(exp(P)*exp(tau))^(1/2):
constraint_ := [diff(P[tau],tau) = exp(2*P)*Q[tau]^2+exp(-2*tau)*(diff(P[x],x)-exp(2*P)*Q[x]^2), diff(Q[tau],tau) = -2*P[tau]*Q[tau]+exp(-2*tau)*(diff(Q[x],x)+2*P[x]*Q[x]), diff(lambda(tau,x),tau) = -P[tau]^2-exp(2*P)*Q[tau]^2-exp(-2*tau)*(P[x]^2+exp(2*P)*Q[x]^2), diff(lambda(tau,x),x) = -2*P[tau]*P[x]-2*exp(2*P)*Q[tau]*Q[x]]:
