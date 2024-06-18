function [y,buff] = fbcomb(x,buff,n,d,G_linear)
    len = length(buff);
    curr = mod(n-1,len) + 1; %  
    delay_idx = mod(n-d-1,len) + 1; % 

    y = buff(delay_idx,1);
    
    %additional: filter y signal with LPF
    buff(curr,1) = x + G_linear*y;
end