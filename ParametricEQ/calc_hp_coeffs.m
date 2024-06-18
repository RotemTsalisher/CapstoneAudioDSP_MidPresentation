function [b,a] = calc_hp_coeffs(fc,Gdb, fs)
    wc = 2*pi*fc;
    Ts = 1/fs;
    k = tan((wc*Ts)/2);
    c_ = sqrt(2);
    if(Gdb>=0)
        % boost hp shelving filter coeffs:
        v0 = 10^(Gdb/20);
        
        den = 1 + c_*k + (k^2);
        b0 = (v0 + sqrt(2*v0)*k + (k^2))/den;
        b1 = 2*((k^2)-v0)/den;
        b2 = (v0 - sqrt(2*v0)*k + (k^2))/den;

        a1 = 2*((k^2)-1)/den;
        a2 = (1-c_*k+(k^2))/den;

    else
        %cut hp shelving filter coeffs:
        v0 = 10^(-Gdb/20);

        den_b = v0 + sqrt(2*v0)*k + k^2;
        den_a = 1 + sqrt(2/v0)*k + (k^2)/v0;
        b0 = (1 + c_*k + k^2)/den_b;
        b1 = 2*((k^2)-1)/den_b;
        b2 = (1 - c_*k + k^2)/den_b;
        a1 = 2*(((k^2)/v0)-1)/den_a;
        a2 = (1-sqrt(2/v0)*k+(k^2)/v0)/den_a;
        
    end
    a = [1 a1 a2]; b = [b0 b1 b2];

end