function seedata(dataname,KKtoA,ToA)
load(dataname)
% Titulo do grafico
if dataname == 'respfreq_2V_data.mat'
    tit = 'Dados expeirmentais -> 2v'
else
    tit = 'Dados expeirmentais -> 4v'
end

%KKtoA , ToA referencias

%Criando o diagrama de bode referencia
sis=tf(KKtoA,[ToA 1]); % G(s) = KKt/(sT + 1)
WW = logspace(floor(log10(min(wdata))),ceil(log10(max(wdata))),44);
WW=WW(:)
WW = squeeze(WW);
% Novos vetores
[GG,FF] = bode(sis,WW);   		% GG,FF sao equivalentes a Gdata,Fdata
GG = squeeze(GG);               % acerta dimensoes                                
FF = squeeze(FF)*pi/180;          % acerta dimensoes
%Vetores coluna
wdata=wdata(:); Gdata=Gdata(:); Fdata=Fdata(:);

%Plot
subplot(2,1,1)
semilogx(wdata,Gdata,'m',WW,20*log10(GG),'b--');
title(tit);
ylabel('|G(w)| [dB]');
legend('Experimental','Teorico')
grid on;

subplot(2,1,2)
semilogx(wdata,Fdata,'m',WW,FF*180/pi,'b--');
xlabel('w [rad/s]');
ylabel('fase(G(jw)) [º]');
legend('Experimental','Teorico')
grid on;
end       