pkg load signal
pkg load communication

# Input parameters
f=20
t=0:0.01:10;

randn(size(t,1))

# Get sine wave
y=sin(2*pi*f*t)
y=awgn(y,0.1)
subplot(2,1,1);
plot(t,y);

# fft it
freq = fft(y,100);
subplot(2,1,2);
plot(abs(freq));

