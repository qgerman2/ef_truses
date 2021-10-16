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

barras = 4;
barra = [1,3;1,4;3,4;2,3];
nodos = 4;
nodo = [0,0;8,0;8,6;0,6];

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

%% Definir matrices
rigidezlocal = zeros(barras, 4, 4);
for i = 1:barras
    rigidezlocal(:, :, i) = rigidez([lambda(i, 1), lambda(i, 2)], L(i));
end
