clear; clc;


%% Read File and Calc Parameters
[xt,fs] = audioread(['EQExample.wav']);
xt = xt(:,1);
N = length(xt); Ts = 1/fs; T = N*Ts; t_ = [0:N-1]*Ts;
f_ = fs/2*(0:N-1)/N;

%% EQ Part
% calc coeffs 
hp1.Gdb = -25; hp1.fc = 500;
[hp1.b,hp1.a] = calc_lp_coeffs(hp1.fc,hp1.Gdb ,fs);
hp2.Gdb = 10; hp2.fc = 23500;
[hp2.b,hp2.a] = calc_hp_coeffs(hp2.fc,hp2.Gdb,fs);

hp3.Gdb = 18; hp3.fc = 2500; hp3.BW = 1000;
[hp3.b,hp3.a] = calc_bp_coeffs(hp3.fc,hp3.Gdb,hp3.BW,fs);

hp4.Gdb = -20; hp4.fc = 5000; hp4.BW = 1000;
[hp4.b,hp4.a] = calc_bp_coeffs(hp4.fc,hp4.Gdb,hp4.BW,fs);

hp5.Gdb = 10; hp5.fc = 10000; hp5.BW = 2000;
[hp5.b,hp5.a] = calc_bp_coeffs(hp5.fc,hp5.Gdb,hp5.BW,fs);

hp6.Gdb = -17; hp6.fc = 13800; hp6.BW = 500;
[hp6.b,hp6.a] = calc_bp_coeffs(hp6.fc,hp6.Gdb,hp6.BW,fs);

hp7.Gdb = 15; hp7.fc = 15000; hp7.BW = 1000;
[hp7.b,hp7.a] = calc_bp_coeffs(hp7.fc,hp7.Gdb,hp7.BW,fs);

%% Filter Sound Bite

if(hp1.Gdb == 0)
else
    y1 = filter(hp1.b,hp1.a,xt);
end
if(hp2.Gdb == 0)
else
    y2 = filter(hp2.b,hp2.a,y1);
end
if(hp3.Gdb == 0)
else
    y3 = filter(hp3.b,hp3.a,y2);
end
if(hp4.Gdb == 0)
else
    y4 = filter(hp4.b,hp4.a,y3);
end
if(hp5.Gdb == 0)
else
    y5 = filter(hp5.b,hp5.a,y4);
end
if(hp6.Gdb == 0)
else
    y6 = filter(hp6.b,hp6.a,y5);
end
if(hp7.Gdb == 0)
else
    y7 = filter(hp7.b,hp7.a,y6);
end
y = y7;

%% Display Spectrograms

M = 128;
g = hann(M,"periodic");
L = 0.75*M;
Ndft = 128;

subplot(211); spectrogram(xt,g,L,Ndft,fs,"yaxis"); title("Spectrogram of Original Sig");
subplot(212); spectrogram(y,g,L,Ndft,fs,"yaxis"); title("Spectrogram of Processed Sig");

%% Display Filter
% calc freq response for display
h1 = freqz(hp1.b,hp1.a,N,fs);
h2 = freqz(hp2.b,hp2.a,N,fs);
h3 = freqz(hp3.b,hp3.a,N,fs);
h4 = freqz(hp4.b,hp4.a,N,fs);
h5 = freqz(hp5.b,hp5.a,N,fs);
h6 = freqz(hp6.b,hp6.a,N,fs);
h7 = freqz(hp7.b,hp7.a,N,fs);

%disp combined frequency response of filter
if(hp1.Gdb == 0)
    mag_H1 = 0;
else
    mag_H1 = 20*log10(abs(h1));
end
if(hp2.Gdb == 0)
    mag_H2 = 0;
else
    mag_H2 = 20*log10(abs(h2));
end
if(hp3.Gdb == 0)
    mag_H3 = 0;
else
    mag_H3 = 20*log10(abs(h3));
end
if(hp4.Gdb == 0)
    mag_H4 = 0;
else
    mag_H4 = 20*log10(abs(h4));
end
if(hp5.Gdb == 0)
    mag_H5 = 0;
else
    mag_H5 = 20*log10(abs(h5));
end
if(hp6.Gdb == 0)
    mag_H6 = 0;
else
    mag_H6 = 20*log10(abs(h6));
end
if(hp7.Gdb == 0)
    mag_H7 = 0;
else
    mag_H7 = 20*log10(abs(h7));
end


%show eq freq response
figure(2); plot(f_,mag_H1+mag_H3+mag_H2 + mag_H4 + mag_H5 + mag_H6+ mag_H7); xlim([0,24*10^3]); 
title("Combined Frequency Response of EQ"); xlabel("Frequency [hz]"); ylabel("|H_e_q(f)|");
yline(0,"--"); grid on;
%% Play Raw and Processed Sound
y = RelativeRMS(0,xt,y); % normalize y(t)'s power to have aprox. the same the power of x(t)
y_ = [y y];
audiowrite("EQOutStereo.wav",y_,fs);
sound(xt,fs); 
pause(1.05*T);
sound(y,fs);