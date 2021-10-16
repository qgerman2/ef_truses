function M = rigidez(lambda, L)
    M = [
        lambda(1)^2, lambda(1)*lambda(2), -lambda(1)^2, -lambda(1)*lambda(2);
        lambda(1)*lambda(2), lambda(2)^2, -lambda(1)*lambda(2), -lambda(2)^2;
        -lambda(1)^2, -lambda(1)*lambda(2), lambda(1)^2, lambda(1)*lambda(2);
        -lambda(1)*lambda(2), -lambda(2)^2, lambda(1)*lambda(2), lambda(2)^2;
    ] / L;
end