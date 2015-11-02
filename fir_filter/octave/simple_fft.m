
# Input parameters
f=2
t=0:0.01:10;

# Get sine wave
y=sin(2*pi*f*t);
subplot(2,1,1);
plot(t,y);

# fft it
freq = fft(y,100)
subplot(2,1,2);
plot(abs(freq))

# Wait for user to bail
input("exit?")
