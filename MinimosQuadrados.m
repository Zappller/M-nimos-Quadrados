# Regressao linear multipla passo a passo (Equacoes Normais)
# Modelo: y = b0 + b1*Area + b2*Quartos
clear; clc;
format short g;

# 1. Dados de 8 imoveis (Area em m², Numero de quartos, Aluguel em R$)
areas  = [35; 50; 62; 70; 85; 100; 120; 150];
quartos = [ 1;  1;  2;  2;  3;   3;   3;   4];
precos   = [1250; 1650; 2150; 2400; 3050; 3500; 4100; 5200];

n = length(areas);
A = [ones(n,1), areas, quartos];   # coluna de 1s = intercepto
b = precos;

printf("Matriz A (%dx%d) e Vetor b (%dx1):\n", rows(A), columns(A), rows(b));
A
b

#Passo 1: A^T A 
printf("\nPasso 1: Calcular A^T A (Matriz 3x3)\n");
AtA = A' * A
printf("(Onde %d e o numero de imoveis, %d e a soma das areas, %d a soma dos quartos, etc.)\n", ...
       AtA(1,1), AtA(1,2), AtA(1,3));

# Passo 2: A^T b 
printf("\nPasso 2: Calcular A^T b (Vetor 3x1)\n");
Atb = A' * b

# Passo 3: resolver o sistema
printf("\nPasso 3: Resolver o sistema (Equacoes Normais)  (A^T A) * beta = A^T b\n");
beta = AtA \ Atb
printf("beta0 = %.2f  (Intercepto)\n",        beta(1));
printf("beta1 = %.2f  (Valor por m^2)\n",     beta(2));
printf("beta2 = %.2f  (Valor por quarto)\n",  beta(3));

#Passo 4: modelo ajustado 
printf("\nPasso 4: O Modelo Ajustado\n");
printf("y = %.2f + %.2f * (Area) + %.2f * (Quartos)\n", beta(1), beta(2), beta(3));

#Passo 5: previsao
area_nova   = 90;
quartos_novo = 2;
printf("\nPasso 5: Fazendo a Previsao\n");
printf("Imovel com %d m^2 e %d quartos:\n\n", area_nova, quartos_novo);
printf("y = %.2f + %.2f * (%d) + %.2f * (%d)\n", beta(1), beta(2), area_nova, beta(3), quartos_novo);
printf("y = %.2f + %.2f + %.2f\n", beta(1), beta(2)*area_nova, beta(3)*quartos_novo);
y = beta(1) + beta(2)*area_nova + beta(3)*quartos_novo;
printf("Previsao = R$ %.2f\n", y);

# Passo 6: erro 
printf("\nPasso 6: Calcular o Erro  E = || b - A*beta ||^2\n");
printf("Como nao ha solucao exata (A*x = b), medimos a qualidade da aproximacao\n");
printf("pela norma euclidiana ao quadrado (o quadrado elimina a raiz e facilita a minimizacao).\n\n");

b_prev = A * beta;          # A*beta (precos previstos)
r      = b - b_prev;        # residuo (vetor erro)

printf("r = b - A*beta (residuo) =\n");          r
printf("r.^2 (erro quadratico de cada imovel) =\n"); r.^2

E = r' * r;                 # ||b - A*beta||^2
printf("E = ||b - A*beta||^2 = %.4f\n", E);
printf("||b - A*beta||       = %.4f\n", sqrt(E));
printf("Erro quadratico medio (E/n)     = %.4f\n", E/n);
printf("Raiz do erro quad. medio (RMSE) = R$ %.2f\n", sqrt(E/n));

# Graficos do erro 
figure;
b1 = linspace(beta(2)-3, beta(2)+3, 200);
Ecurva = zeros(size(b1));
for k = 1:length(b1)
  rk = b - A * [beta(1); b1(k); beta(3)];
  Ecurva(k) = rk' * rk;
end
plot(b1, Ecurva, 'b-', 'linewidth', 2); hold on;
plot(beta(2), E, 'ro', 'markerfacecolor', 'r', 'markersize', 9);
xlabel('\beta_1 (valor por m^2)'); ylabel('E = ||b - A\beta||^2');
title('Erro em funcao de \beta_1');
legend('E(\beta_1)', sprintf('Minimo: E = %.0f', E), 'location', 'north');
grid on; hold off;

figure(2);
y_prev = A * beta;
plot(precos, y_prev, 'bo', 'markerfacecolor', 'b'); hold on;
plot([min(precos) max(precos)], [min(precos) max(precos)], 'k--');
xlabel('Preco real (R$)'); ylabel('Preco previsto (R$)');
title('Real x Previsto'); grid on; hold off;

disp('Pressione Enter para fechar as figuras...');
pause;