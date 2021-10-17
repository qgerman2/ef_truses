function [V] = vectortemp(alpha, deltaT, lambda)
    V = alpha*deltaT*[
        lambda(1);
        lambda(2);
        -lambda(1);
        -lambda(2)
    ];
end
