% Laboratório de Controle Poli Usp
% Experiência 1 - Modelagem da planta

% a) 
% Calculo da relação V_armadura_motor x V_tacogerador (tacometro)
load('KKt_data.mat')
% As variaveis imporatadas são: DisplayRPM , Vm  ,Vt 
% Levantamento da curva
Vma = Vm
Vta = Vt
figure
plot(Vm,Vt)
title('Tensão Motor (Vm) x Tensão Tacogerador (Vt)')
xlabel('Vm')
ylabel('Vt')
%gtext('Saturação +5v)')
%gtext('Saturação -5v)')
%gtext('Não linearidade: Atrito estático seco ou de Coulumb')
grid()


% b) 
% Levantamento de kt onde Omega_m(s) = Kt*Vt(s)
% Denotando Omega_m(s) por Oms vem que
Ops = (2*pi/60)*DisplayRPM;
n = 1/3;
Oms = Ops/(n^2);

figure
plot(Oms,Vt)
title('Rotação motor (Omega_m) x Tensão Tacogerador (Vt)')
xlabel('Omega_m [rad/s] ')
ylabel('Vt [V]')
%Como é linear calulamos Kt pelo coeficiente angular
%Para lidarmos com possíveis imprecisões de medida vamos usar um ajuste
%polinômial
p1 = polyfit(Oms,Vt,1);
Kt = p1(1)

% a) Continuação
% Levantamento de K*Kt , Vt[V] = K*Kt * Vm
% Vamos selecionar os Vm entre 3 e 4 e outros Vm entre -3 e -4 e aproximar
% Uma reta a apartir dai
% minmod = 1
% maxmod = 4
% 
% for i = 1:59
%     if (Vt(i)<(-minmod) && Vt(i) > (-maxmod)) || (Vt(i) < maxmod && Vt(i) > minmod)
%         VtSel = Vt(i);
%         index_arr(i) = i;
%     end
% end
% 
% for j = length(index_arr)
%     VmSel = Vm(index_arr(j));
% end
% 
% p2 = polyfit(VmSel,VtSel,1);
% KKt = p2(1)
% K = KKt/Kt
p2 = polyfit(Vm,Vt,1); %Com esse polyfit ficou ajustado em torno de 2.5v
KKt = p2(1)
K = KKt/Kt

polivrau = polyval(p2,Vma)

figure
plot(Vma,Vta,Vma,polivrau)
title('Tensão Motor (Vm) x Tensão Tacogerador (Vt)')
xlabel('Vm')
ylabel('Vt')

% c)
% Determinação do Kp, coeficinete de transformação angulo -> tensão
% no potênciômetro

load('Kp_data.mat')
figure
plot(t,Vp)
title('Tempo(t) x Tensão potenciômetro (Vp)')
xlabel('t[s]')
ylabel('Vp[V]')
grid()

%Do gráfico
%Ponto de máximo
ta_DT = 19.41
tb = 19.37 
Vmax = 4.896
ta = 18.26 
Vmin = -4.835

Dt = ta_DT - ta

% Transformando tempo em angulo
d_phi = (2*pi)*(tb - ta)/Dt

%Achando o Kp
Kp = (Vmax - Vmin)/d_phi
Kp_linear = Kp
% d)
load('T_data.mat')
% t,Vm,Vp,Vt
figure
plot(t,Vt)
hold
plot(t,Vm)
title('Tempo(t) x Tensão Tacogerador (Vt)')
xlabel('t[s]')
ylabel('Vt[V]')
grid()

i_min = 1
menor = 1;
for index = 1:length(t)
    
    if (t(index)> 3.5) && menor
        i_min = index;
        menor = 0;
    end
end
 
plato_de_tensao = mean(Vt(i_min:length(Vt)))

V_tal = (63/100)*plato_de_tensao 

i_min = 1;
menor = 1;
for index = 1:length(t)
    
    if (Vt(index)>= V_tal) && menor
        i_min = index;
        menor = 0;
    end
end

tal = t(i_min) - 1
T = tal



% Laboratório de Controle Poli Usp
% Experiência 2 - Validação Modelagem Linear da planta

%======== Otimizando os parâmetros =========
%Valores Alterados em função da comparação com os valores medidos
T = 0.25
Kp = 1.38

%===========================================


load('modlin_val_data.mat')
% K, Kt
figure
subplot(3,1,1)
Vm_ones = ones(size(t));
plot(t, 5*Vm_ones, '--g', t, -5*Vm_ones, '--g', t, 0.25*Vm_ones, '--r', t, -0.25*Vm_ones, '--r', t, Vm, '-b');
title('Sinal de Entrada');
xlabel('Tempo [s]');
ylabel('Vm [v]');
legend('Vm de saturação sup', 'Vm de saturação inf', 'Vm de atrito sup', 'Vm de atrito inf', 'Vm') 
grid on;
axis([0 30 -6 6]);

subplot(3,1,2)
lim = 5*ones(size(t));
plot(t,VtSim,'r',t,Vt,'b',t,Vm,'k',t,lim,'g--',t,-1*lim,'g--')

title('Validação Modelo Linear: t x Vt')
xlabel('t[s]')
ylabel('Vt[V]')
legend('Vt Simulado','Vt Medido','Vm','limite superior','limite inferior')
axis([0 30 -6 6])
grid()
subplot(3,1,3)
plot(VtSim - Vt)
title('Erro VtSimulado - VtMedido')
xlabel('t[s]')
ylabel('Vt[V]')
grid()

tmaxErP = 180

% K,Kp
figure
subplot(2,1,1)

plot(t(1:tmaxErP),VpSim(1:tmaxErP),t(1:tmaxErP),Vp(1:tmaxErP),t(1:tmaxErP),Vm(1:tmaxErP))
title('Validação Modelo Linear: t x Vp')
xlabel('t[s]')
ylabel('Vp[V]')
legend('Vp Simulado','Vp Medido','Vm')
grid()

subplot(2,1,2)
plot(t(1:tmaxErP),VpSim(1:tmaxErP)-Vp(1:tmaxErP))
title('Erro VpSimulado - VpMedido')
xlabel('t[s]')
ylabel('Vp[V]')
grid()
ERRO_POTENCIOMETRO = abs(mean(VpSim(1:tmaxErP)-Vp(1:tmaxErP)))
