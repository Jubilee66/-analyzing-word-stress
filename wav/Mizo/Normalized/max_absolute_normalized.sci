[y,fs,b]=wavread("C:\Users\HP\Desktop\wav\Assamese\ReadingAssamese_1.wav");

max_val=max(abs(y));

wavwrite(y,fs,'C:\Users\HP\Desktop\wav\Assamese\normalized_ReadingAssamese_1.wav')

