[y,fs,b]=wavread("E:\TU_mtech\4_SEMESTER\Jubilee_Project\Mizo\Normalized\More_Data_2\adjDisyll_sp1.wav");

max_val=max(abs(y));

wavwrite(y,fs,'E:\TU_mtech\4_SEMESTER\Jubilee_Project\Mizo\Normalized\More_Data_2\adjDisyll_sp1.wav')

