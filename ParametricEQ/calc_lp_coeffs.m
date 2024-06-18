function [b,a] = calc_lp_coeffs(fc,Gdb, fs)
    wc = 2*pi*fc;
    Ts = 1/fs;
    k = tan(wc*Ts/2);

    if(Gdb>=0)
        % boost lp shelving filter coeffs:
        v0 = 10^(Gdb/20);

        den = 1 + (sqrt(2)*k) + k^2;
        b0 = (1 + sqrt(2*v0)*k + v0*k^2)/den;
        b1 = 2*(v0*(k^2)-1)/den;
        b2 = (1 - sqrt(2*v0)*k + v0*k^2)/den;
        a1 = 2*(k^2-1)/den;
        a2 = (1-sqrt(2)*k+k^2)/den;

    else
        %cut hp shelving filter coeffs:
        v0 = 10^(-Gdb/20);

        den = 1 + sqrt(2*v0)*k + v0*k^2;
        b0 = (1 + sqrt(2)*k + k^2)/den;
        b1 = 2*((k^2)-1)/den;
        b2 = (1 - sqrt(2)*k + k^2)/den;
        a1 = 2*(v0*(k^2)-1)/den;
        a2 = (1-sqrt(2*v0)*k+v0*k^2)/den;
    end


    a = [1 a1 a2]; b = [b0 b1 b2];
end