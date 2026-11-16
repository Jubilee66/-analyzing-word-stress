[y,fs,b]=wavread("E:\TU_mtech\4_SEMESTER\Jubilee_Project\wav\Mizo\Unnormalized\sp1_ch1.wav");

max_val=max(abs(y));

wavwrite(y,fs,'E:\TU_mtech\4_SEMESTER\Jubilee_Project\wav\Mizo\Normalized\max_abs_sp1_ch1.wav')

