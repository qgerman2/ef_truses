function [V] = vectortemp(A, E, alpha, deltaT, lambda)
    V = A*E*alpha*deltaT*[
        lambda(1);
        lambda(2);
        -lambda(1);
        -lambda(2)
    ];
end