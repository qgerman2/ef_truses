clc; clearvars; close all;

%% Ejemplos de entrada
%Proyecto 1 de elementos finitos
%{
nodos = 4;
nodo = [0,0;8,0;8,6;0,6];
barras = 4;
barra = [1,3;1,4;3,4;2,3];
EA = [2E7*1000*20*10E-4;2E6*1000*0.15;2E6*1000*0.15;2E7*1000*20*10E-4];
barrastemp = 2;
barratemp = [1, 4];
alpha = 1*10^(-5);
deltaT = 40;
variablesfijas = 4;
variablefija = [2,2;1,2;2,1;1,1];
%}

%Ejemplo structural analysis
%{
nodos = 4;
nodo = [0,0;0,10;10,0;10,10];
barras = 6;
barra = [1,3;1,4;1,2;2,4;2,3;3,4];
EA = [21750000;21750000;21750000;21750000;21750000;21750000];
barrastemp = 1;
barratemp = [2];
alpha = 6.5*10^(-6);
deltaT = 150;
variablesfijas = 3;
variablefija = [4,1;4,2;3,1];
%}

%% Entrada del usuario
nodos = input("Cuantos nodos hay? : ");
nodo = zeros(nodos, 2);
for i = 1:nodos
    fprintf("NODO %d X: ", i);
    nodo(i, 1) = input("");
    fprintf("NODO %d Y: ", i);
    nodo(i, 2) = input("");
end

barras = input("Cuantas barras hay? : ");
barra = zeros(barras, 2);
EA = zeros(barras, 1);
for i = 1:barras
    fprintf("BARRA %d primer nodo: ", i);
    barra(i, 1) = input("");
    fprintf("BARRA %d segundo nodo: ", i);
    barra(i, 2) = input("");
    fprintf("BARRA %d MODULO DE YOUNG: ", i);
    E = input("");
    fprintf("BARRA %d AREA: ", i);
    A = input("");
    EA(i) = E*A;
end

barrastemp = input("Cuantas barras sufren temperatura? : ");
barratemp = zeros(barrastemp, 1);
for i = 1:barrastemp 
    barratemp(i, 1) = input("Barra: ");
end

if barrastemp > 0
	alpha = input("Calor especifico de barras: ");
	deltaT = input("Diferencia de temperatura en las barras: ");
else
	alpha = 0;
	deltaT = 0;
end

variablesfijas = input("Cuantos desplazamientos están fijos? : ");
for i = 1:variablesfijas
    variablefija(i,1) = input("En que nodo? : ");
    fprintf("NODO %d ", variablefija(i, 1));
    variablefija(i,2) = input("Fijo horizontal (1) o vertical (2)? : ");
end

%% Calcular largos
L = zeros(barras, 1);
for i = 1:barras
    n1 = barra(i, 1);
    n2 = barra(i, 2);
    L(i) = sqrt((nodo(n2, 1) - nodo(n1, 1))^2 + (nodo(n2, 2) - nodo(n1, 2))^2);
end

%% Calcular lambdas
lambda = zeros(barras, 2);
for i = 1:barras
    n1 = barra(i, 1);
    n2 = barra(i, 2);
    lambda(i, 1) = (nodo(n2, 1) - nodo(n1, 1)) / L(i);
    lambda(i, 2) = (nodo(n2, 2) - nodo(n1, 2)) / L(i);
end

%% Definir rigideces de 4x4
rigidezlocal = zeros(4, 4, barras);
for i = 1:barras
    rigidezlocal(:, :, i) = rigidez([lambda(i, 1), lambda(i, 2)], L(i)) * EA(i);
end

%% Ajustar matrices a tamaño de nodos*2 x nodos*2
rigidezexpandida = zeros(nodos*2, nodos*2, barras);
for i = 1:barras
    n1 = barra(i, 1);
    n2 = barra(i, 2);
    %%4x4 superior izquierda
    rigidezexpandida(n1 * 2 - 1, n1 * 2 - 1, i) = rigidezlocal(1, 1, i);
    rigidezexpandida(n1 * 2, n1 * 2 - 1, i) = rigidezlocal(2, 1, i);
    rigidezexpandida(n1 * 2 - 1, n1 * 2, i) = rigidezlocal(1, 2, i);
    rigidezexpandida(n1 * 2, n1 * 2, i) = rigidezlocal(2, 2, i);
    %%4x4 inferior izquierda
    rigidezexpandida(n2 * 2 - 1, n1 * 2 - 1, i) = rigidezlocal(3, 1, i);
    rigidezexpandida(n2 * 2, n1 * 2 - 1, i) = rigidezlocal(4, 1, i);
    rigidezexpandida(n2 * 2 - 1, n1 * 2, i) = rigidezlocal(3, 2, i);
    rigidezexpandida(n2 * 2, n1 * 2, i) = rigidezlocal(4, 2, i);
    %%4x4 superior derecha
    rigidezexpandida(n1 * 2 - 1, n2 * 2 - 1, i) = rigidezlocal(1, 3, i);
    rigidezexpandida(n1 * 2, n2 * 2 - 1, i) = rigidezlocal(2, 3, i);
    rigidezexpandida(n1 * 2 - 1, n2 * 2, i) = rigidezlocal(1, 4, i);
    rigidezexpandida(n1 * 2, n2 * 2, i) = rigidezlocal(2, 4, i);
    %%4x4 inferior derecha
    rigidezexpandida(n2 * 2 - 1, n2 * 2 - 1, i) = rigidezlocal(3, 3, i);
    rigidezexpandida(n2 * 2, n2 * 2 - 1, i) = rigidezlocal(4, 3, i);
    rigidezexpandida(n2 * 2 - 1, n2 * 2, i) = rigidezlocal(3, 4, i);
    rigidezexpandida(n2 * 2, n2 * 2, i) = rigidezlocal(4, 4, i);
end

%% Matriz de rigidez completa
rigidez = zeros(nodos * 2, nodos * 2);
for i = 1:barras
   rigidez = rigidez + rigidezexpandida(:, :, i);
end

%% Vector de efecto de temperatura
vtemp = zeros(nodos * 2, 1);
for i = 1:barrastemp
    n1 = barra(barratemp(i), 1);
    n2 = barra(barratemp(i), 2);
    V = vectortemp(alpha, deltaT, [lambda(barratemp(i), 1), lambda(barratemp(i), 2)]) * EA(barratemp(i));
    vtemp(n1 * 2 - 1) = vtemp(n1 * 2 - 1) + V(1);
    vtemp(n1 * 2) = vtemp(n1 * 2) + V(2);
    vtemp(n2 * 2 - 1) = vtemp(n2 * 2 - 1) + V(3);
    vtemp(n2 * 2) = vtemp(n2 * 2) + V(4);
end


%% Reducir matriz rigidez
reductor = 2 * variablefija(:, 1) - 1 + variablefija(:, 2) - 1;

rigidez(reductor, :) = [];
rigidez(:, reductor) = [];

%% Reducir vector temperatura
vtemp(reductor, :) = [];

%% Ecuacion simbolica
variables = sym("v", [1 2*nodos]);
variables(:, reductor) = [];

eq = zeros(2*nodos - variablesfijas, 1) == rigidez * variables' + vtemp;
S = vpasolve(eq, variables);

%% Imprimir resultados
mm = [1:2*nodos];
mm(:, reductor) = [];
for i = 1:length(mm)
   if mod(mm(i), 2) ~= 0 
       fprintf("x%d: %f", ceil(mm(i)/2), S.("v"+mm(i)));
   else
       fprintf("y%d: %f", ceil(mm(i)/2), S.("v"+mm(i)));
   end
   fprintf("\n");
end
fprintf("\n")
