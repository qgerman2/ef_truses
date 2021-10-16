clc; clearvars; close all;

%{
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
for i = 1:barras
    fprintf("BARRA %d primer nodo: ", i);
    barra(i, 1) = input("");
    fprintf("BARRA %d segundo nodo: ", i);
    barra(i, 2) = input("");
end
%}

nodos = 4;
nodo = [0,0;8,0;8,6;0,6];
barras = 4;
barra = [1,3;1,4;3,4;2,3];
barrastemp = 2;
barratemp = [1, 4];
alpha = 1*10^(-5);
deltaT = 40;
variablesfijas = 4;
variablefija = [1,1;1,2;2,1;2,2];

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
    rigidezlocal(:, :, i) = rigidez([lambda(i, 1), lambda(i, 2)], L(i));
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
vtemp = zeros(nodos * 2, barrastemp);
for i = 1:barrastemp
    n1 = barra(barratemp(i), 1);
    n2 = barra(barratemp(i), 2);
    V = vectortemp(1, 1, alpha, deltaT, [lambda(i, 1), lambda(i, 2)]);
    vtemp(n1 * 2 - 1, i) = V(1);
    vtemp(n1 * 2, i) = V(2);
    vtemp(n2 * 2 - 1, i) = V(3);
    vtemp(n2 * 2, i) = V(4);
end

%% Reducir sistema
rigidez(2 * variablefija(:, 1) - 1 + variablefija(:, 2) - 1, :) = [];
rigidez(:, 2 * variablefija(:, 1) - 1 + variablefija(:, 2) - 1) = [];
