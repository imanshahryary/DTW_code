function [frame]=my_hamming(in_frame,L)
frame=zeros(L,1);
for n=0:L-1
    frame(n+1,1)=(0.54-0.46*cos((2*pi*n)/(L-1)))*in_frame(n+1,1);  
end
end
