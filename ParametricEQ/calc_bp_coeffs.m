function [b,a] = calc_bp_coeffs(fc,Gdb,BW, fs)
    wc = 2*pi*(fc);
    Ts = 1/fs;
    k = tan(wc*Ts/2);
    Q = fc/BW;

    if(Gdb>=0)
        disp("BP BOOST");
        % boost bp shelving filter coeffs:

        v0 = 10^(Gdb/20);
        den = (1 + (1/Q)*k + k^2);
        
        b0 = (1 + (v0/Q)*k + k^2)/den;
        b1 = 2*(k^2-1)/den;
        b2 = (1 - (v0/Q)*k + k^2)/den;
        a1 = 2*(k^2-1)/den;
        a2 = (1 - (1/Q)*k + k^2)/den;

    else
        disp("BP CUT");
        %cut bp shelving filter coeffs:
        v0 = 10^(-Gdb/20);

        den = (1 + (v0/Q)*k + k^2);       
        b0 = (1 + (1/Q)*k + k^2)/den;
        b1 = 2*(k^2-1)/den;
        b2 = (1 - (1/Q)*k + k^2)/den;
        a1 = 2*(k^2-1)/den;
        a2 = (1 - (v0/Q)*k + k^2)/den;
    end


    a = [1 a1 a2]; b = [b0 b1 b2];
end