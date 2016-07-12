function dvdt = model_Iz_zeros_paperform(v, I, a, b, A, B, C, T)
    u = b.*v; % as dudt = 0 = a(bv - u)
    dvdt = A.*T.*v.*v + B.*T.*v + C.*T - u.*T + I.*T;
    % Now fzero can find where dvdt crosses 0
end
