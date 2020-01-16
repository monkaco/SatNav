%% Lista de Exercicios #3) Estimador MQ
% 
% Questao 4) 
%           i)  Fazer o exercicio 5.18 (4a edicao)
%           ii) Demonstracao

clear all
close all
clc

% Sinal u(k) PRBS com 500 valores
N = 500;  % Numero total amostras do sinal 
b = 8;     % # bits -> Periodo da sequencia = (2^n - 1)*Tb = 1023*Tb
Tb = 1;     % Periodo de duracao dos bits
u = (prbs(N,b,Tb))';
% u = u - mean(u);    % Entrada sem offset
n = N;

%% a) Simulacao do modelo ARX sem ruido
y1(1) = 0;  % C.I. y1(k-1) = 0
y1(2) = 0;  % C.I. y1(k-2) = 0
for k = 3 : n
    y1(k) = 1.5*y1(k-1) - 0.7*y1(k-2) + u(k-1) + 0.5*u(k-2);
end
figure;
subplot(2,1,1); stem(u); grid on
axis([-1 501 0 1.1]);
title('Entrada');
ylabel('Amplitude');
subplot(2,1,2); stem(y1); grid on
title('Saída - Modelo ARX');
xlabel('Tempo (s)');
ylabel('Amplitude');

%% b) Estimacao dos parametros do problema "quadrado" (n = N) sem ruido
% Caso 1) k = 5, 6, 7 e 8
l = 1;
for k = 5:8   
    mr1(l,:) = [y1(k-1) y1(k-2) u(k-1) u(k-2)];
    l = l + 1;
end
theta1_1 = inv(mr1' * mr1) * mr1' * y1(5:8)'
% Caso 2) k = 205, 206, 207 e 208
l = 1;
for k = 205:208   
    mr1(l,:) = [y1(k-1) y1(k-2) u(k-1) u(k-2)];
    l = l + 1;
end
theta1_2 = inv(mr1' * mr1) * mr1' * y1(205:208)'


%% c)
% Geracao do ruido
var_y = 0.05*var(y1);               % 5% da variancia do sinal y(k)
r = randn(1,n);                     % 
r = sqrt(var_y)*(r - mean(r));      % Ruido do sinal r
y2 = y1 + r;                        % y2: sinal de saida com ruido


%% d) Estimacao dos parametros do problema "quadrado" (n = N) com ruido
% Caso 1) k = 5, 6, 7 e 8
l = 1;
for k = 5:8   
    mr2(l,:) = [y2(k-1) y2(k-2) u(k-1) u(k-2)];
    l = l + 1;
end
theta2_1 = inv(mr2' * mr2) * mr2' * y2(5:8)'
% Caso 2) k = 205, 206, 207 e 208
l = 1;
for k = 205:208   
    mr2(l,:) = [y2(k-1) y2(k-2) u(k-1) u(k-2)];
    l = l + 1;
end
theta2_2 = inv(mr2' * mr2) * mr2' * y2(205:208)'



% 
% %% c) Simulacao do modelo ARX com ruido (5% do desvio-padrao de y)
% y2(1) = 0;  % C.I. y2(k-1) = 0
% y2(2) = 0;  % C.I. y2(k-2) = 0
% for k = 3 : n
%     y2(k) = 1.5*y2(k-1) - 0.7*y2(k-2) + u(k-1) + 0.5*u(k-2) + r(k);
% end
% 
% figure
% L = 15;
% cuu = [u u];
% [lu, ru, conf_u, Bu] = myccf2(cuu, L, 0, 1);    % FAC ru
% title('FAC r_{u}')
% 
% 
% figure%subplot(2,1,1)
% stem(u); hold on;
% stem(y1,'r*');
% title('Modelo ARX'); % Entrada vs Saida (sem offset)
% xlabel('Tempo (s)');
% ylabel('Amplitude');
% grid on
% 
