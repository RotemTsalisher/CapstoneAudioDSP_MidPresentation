% Schroeder Algo audio .wav file demonstration:
clear;clc;

[x,fs] = audioread('hello.wav');
x = x(:,1);
N = length(x); Ts = 1/fs; T = N*Ts;
delay_upper_lim = ceil(.07*fs); % upper lim  

% initialize buffs
buffer1 = zeros(delay_upper_lim,1); buffer2 = zeros(delay_upper_lim,1); 
buffer3 = zeros(delay_upper_lim,1); buffer4 = zeros(delay_upper_lim,1); 
buffer5 = zeros(delay_upper_lim,1); buffer6 = zeros(delay_upper_lim,1); 

a = 1.25; b = 1.025; % tweaking factors
% NOTE: FACTORS ARE VERY SENSITIVE!!

% delays and gains
d1 = fix(a*.0297*fs); g1 = b*0.75;
d2 = fix(a*.0371*fs); g2 = -b*0.75;
d3 = fix(a*.0411*fs); g3 = b*0.7;
d4 = fix(a*.0437*fs); g4 = -b*0.75;
d5 = fix(a*.005*fs); g5 = b*0.7;
d6 = fix(a*.0017*fs); g6 = b*0.7;

for n = 1:N
    [w1,buffer1] = fbcomb(x(n,1),buffer1,n,d1,g1);
    [w2,buffer2] = fbcomb(x(n,1),buffer2,n,d2,g2);
    [w3,buffer3] = fbcomb(x(n,1),buffer3,n,d3,g3);
    [w4,buffer4] = fbcomb(x(n,1),buffer4,n,d4,g4);


    combPar = 0.25*(w1 + w2 + w3 + w4);

    % all pass

    [w5,buffer5] = apfilt(combPar,buffer5,n,d5,g5);
    [out(n,1),buffer6] = apfilt(w5,buffer6,n,d6,g6);
end

%% Show Spectrograms

M = 128;
g = hann(M,"periodic");
L = 0.75*M;
Ndft = 128;

subplot(211); spectrogram(x,g,L,Ndft,fs,"yaxis"); title("Spectrogram of Original Sig");
subplot(212); spectrogram(out,g,L,Ndft,fs,"yaxis"); title("Spectrogram of Processed Sig");

%% Play Raw and Processed Sound

sound(x,fs); pause(T);
sound(out,fs);

%% Save Processed Audio as .wav file

out_ = [out out];
audiowrite("ReverbedSound.wav", out,fs);
