function [ErroMedio,ErroMediana] = validation(VtSim,tit)

load('modlin_val_data.mat')
% K, Kt
figure
subplot(3,1,1)
Vm_ones = ones(size(t));
plot(t, 5*Vm_ones, '--g', t, -5*Vm_ones, '--g', t, 0.25*Vm_ones, '--r', t, -0.25*Vm_ones, '--r', t, Vm, '-b');
title('Entrada')
xlabel('Tempo [s]');
ylabel('Vm [v]');
legend('Vm de saturação sup', 'Vm de saturação inf', 'Vm de atrito sup', 'Vm de atrito inf', 'Vm') 
grid on;
axis([0 30 -6 6]);

subplot(3,1,2)
lim = 5*ones(size(t));
plot(t,VtSim,'r',t,Vt,'b',t,Vm,'k',t,lim,'g--',t,-1*lim,'g--')

media = mean(VtSim - Vt)

title(tit)
xlabel('t[s]')
ylabel('Vt[V]')
legend('Vt Simulado','Vt Medido','Vm','limite superior','limite inferior')
axis([0 30 -6 6])
grid()
subplot(3,1,3)
plot(VtSim - Vt)
title('Erro VtSim - Vt')
xlabel('t[s]')
ylabel('Erro')
grid()

ErroMedio = mean(abs(VtSim - Vt))
ErroMediana = median(abs(VtSim - Vt))
end