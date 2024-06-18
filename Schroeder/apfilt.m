function [y,buff] = apfilt(x,buff,n,d,G_linear)

    len = length(buff);
    curr = mod(n-1,len) + 1; %  
    delay_idx = mod(n-d-1,len) + 1; % 

    w = buff(delay_idx,1);
    v = x + (-G_linear*w);
    y = (G_linear * v) + w;
    
    % Store the current input to delay buffer
    buff(curr,1) = v;

end
