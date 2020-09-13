% Exp3 - Resposta em Frequência

%Nessa experiência vamos caracterizar o sistema a apartir de sua resposta
%em frequencia. Esse eh um metodo linear, ou melhor, linearizado ja que
%existem nao linearidades nos sinais tratados pelo metodo que modela
%SLIT (sistemas lineares invariantes no tempo) por meio da funcao de 
%transferencia entre entrada e saida. 

%Vantagens: Considera muitos pontos para o ajuste. Considera diferentes 
%frequencias de operacao.

% Foram realizados ajustes com "programacao nao linear" dentro da funcao
% bodefit.m de autoria dos professores do curso.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              Anlise                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Controle de Analise

Analise = 'r' % 'a' = assintotas , 'o' = Otimizacao Linear, 'r' resultados

Caso_que_quero_rodar = '4' % 'a' = 2v , 'b' = 4v

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                        Metodo das Assintotas                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if Analise == 'a'
    KKtoA = 0.9309
    ToA = 0.25
    % a) Analisando Excitação Senoidal |Vi| = 2v , frequencias variadas
    if Caso_que_quero_rodar == '2'
        
        seedata('respfreq_2V_data.mat',KKtoA,ToA);
        
        load('respfreq_2V_data.mat')
        
        wmin = 7
        wmax = 11
        rejmin = 0
        rejmax = 0
        Go = Gdata(1)
        
        pole = findpole(wdata,Gdata,wmin,rejmin,rejmax,wmax,Go);
       
        %Definindo os valores dos parametros
        T_2_ASS = 1/abs(pole) 
        kkt_2_ASS = 10.^(Gdata(1)/20)
         
        
    end
    
    
    
    % b) Analisando Excitação Senoidal |Vi| = 4v , frequencias variadas
    if Caso_que_quero_rodar == '4'
       
        seedata('respfreq_4V_data.mat',KKtoA,ToA);
        
        load('respfreq_4V_data.mat')
        
        wmin = 8
        wmax = 12
        rejmin = 0
        rejmax = 0
        Go = Gdata(1)
        
        pole = findpole(wdata,Gdata,wmin,rejmin,rejmax,wmax,Go);
       
        %Definindo os valores dos parametros
        T_4_ASS = 1/abs(pole) 
        kkt_4_ASS = 10.^(Gdata(1)/20)
        
        
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          Otimizacao Numerica                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Analise == 'o'

    % a) Analisando Excitação Senoidal |Vi| = 2v , frequencias variadas
    if Caso_que_quero_rodar == '2'

        load('respfreq_2V_data.mat')

        % Usaremos aqui os valores de T e KKt obtidos pelo metodo de modelagem
        % mais simples usados nas experiencias 1 e 2. Note que a abordagem de 
        % resposta em frequencia implementada numericamente depende da escolha
        % de parametros iniciais razoavelmente proximos dos valores reais deles.

        % Valores Inicias
        KKto = 54.955720*0.01694;
        To = 0.25;

        [KKt2_ON,T2_ON] = bodefit(KKto,To,wdata,Gdata,Fdata);

    end 

    % b) Analisando Excitação Senoidal |Vi| = 4v , frequencias variadas
    if Caso_que_quero_rodar == '4'

        load('respfreq_4V_data.mat')

        KKto = 54.955720*0.01694;
        To = 0.25;

        [KKt4_ON,T4_ON] = bodefit(KKto,To,wdata,Gdata,Fdata);
    end 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                              RESULTADOS                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if Analise == 'r'
    
    %%%%%%%%%%%%%%%
    %     G(jw)   %
    %%%%%%%%%%%%%%%
    
    %Valores referencia
    KKtoA = 0.9309;
    ToA = 0.25;

    %Criando o diagrama de bode referencia
    WW = logspace(floor(log10(min(wdata))),ceil(log10(max(wdata))),44);
    WW=WW(:);
    WW = squeeze(WW);

    % Vetores referencia
    sisref=tf(KKtoA,[ToA 1]); % G(s) = KKt/(sT + 1)
    [Gref,Fref] = bode(sisref,WW);   		
    Gref = squeeze(Gref);                                                    
    Fref = squeeze(Fref)*pi/180;          

    % Vetores transferencia Otimizacao Numerica
    sistransON=tf(KKt4_ON,[T4_ON 1]); % G(s) = KKt/(sT + 1)
    [GtransON,FtransON] = bode(sistransON,WW);   		
    GtransON = squeeze(GtransON);                                                    
    FtransON = squeeze(FtransON)*pi/180; 
    
    % Vetores transferencia Metodo das assintotas
    sistransASS=tf(kkt_4_ASS,[T_4_ASS 1]); % G(s) = KKt/(sT + 1)
    [GtransASS,FtransASS] = bode(sistransASS,WW);   		
    GtransASS = squeeze(GtransASS);                                                    
    FtransASS = squeeze(FtransASS)*pi/180; 

    %Plot
    subplot(2,1,1)
    semilogx(WW,20*log10(GtransON),'g',wdata,Gdata,'k--',WW,20*log10(GtransASS),'r-');
    title('Funcao de transferencia');
    ylabel('|G(w)| [dB]');
    legend('Funcao de transferencia Otimizacao Num','Experimental','Funcao de transferencia Assintotas')
    grid on;

    subplot(2,1,2)
    semilogx(WW,FtransON*180/pi,'g',wdata,Fdata,'k--',WW,FtransASS*180/pi ,'r-');
    xlabel('w [rad/s]');
    ylabel('fase(G(jw)) [º]');
    legend('Funcao de transferencia Otimizacao Num','Experimental','Funcao de transferencia Assintotas')
    grid on;
    
    % Validando modelo Linear obtido 
    [EONmedia,EONmediana] = validation(VtSimON,'Otimizacao Numerica');
    [EASSmedia,EASSmediana] = validation(VtSimASS,'Ajuste Assintotas');
   
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %     Kp não funciona, pq?   %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Criando o diagrama de bode referencia
    sis=tf(54.9557*1.38*0.11111,[0.25 1 0]); % G(s) = KKt/(sT + 1)
    WW = logspace(floor(log10(min(wdata))),ceil(log10(max(wdata))),44);
    WW=WW(:)
    WW = squeeze(WW);
    % Novos vetores
    [Gp,Fp] = bode(sis,WW);   		% GG,FF sao equivalentes a Gdata,Fdata
    Gp = squeeze(Gp);               % acerta dimensoes                                
    Fp = squeeze(Fp)*pi/180;          % acerta dimensoes
    %Vetores coluna
    wdata=wdata(:); Gdata=Gdata(:); Fdata=Fdata(:);

    %Plot
    figure
    subplot(2,1,1)
    semilogx(wdata,Gdata,'m',WW,20*log10(Gp),'b--');
    title('Gp(S) - Quando ha um polo em zero');
    ylabel('|G(w)| [dB]');
    legend('Dados do Lab','Gp(s)')
    grid on;

    subplot(2,1,2)
    semilogx(wdata,Fdata,'m',WW,Fp*180/pi,'b--');
    xlabel('w [rad/s]');
    ylabel('fase(G(jw)) [º]');
    legend('Dados do Lab','arg[Gp(s)]')
    grid on;
    
end       