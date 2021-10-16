clc; clearvars; close all;


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
