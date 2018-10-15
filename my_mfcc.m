function [c,I] = my_mfcc( name )
%use two other function in this function   my_hamming   &  wave2frame

% c is ceptrals number
% I is number of frame

%function wave2frame variable
    is_last_frame=0;
    frame_overlap = 10; %ms
    frame_length = 25; %ms
    flag=1; %the number that we start splite wave to frames
    frame_number=1; %the frame that we want
    wave_name=name;%wave word    set in MFCC function
    alfa=0.95 ; %zarib pishtakid
    
% set some variable that is necessary set out of the while loop
    firstloop=1;

while is_last_frame~=1
    %part 1 & 2  is in this function
    [frame,is_last_frame,N,M,wave_length,fs]=wave2frame(frame_overlap,frame_length,flag,frame_number,wave_name,alfa);
    
    %-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------    
    %part 3  is in this function
    frame=my_hamming(frame,N);
    %-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    %part 4
    NFFT=512;
    fft_frame=zeros(NFFT,1);
    fft_frame(1:NFFT,1)=fft(frame,NFFT);
    %-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------   
    %part 5
    % made filter in first loop then only use it
    if firstloop==1
    % each column represent one filter in mel space
    % sakhte filter bank
    % i=filter number
    % filter1=ghesmat ba shibe + mosalas
    % filter2=ghesmat  ba shibe - mosalas   
    filter_number_i=zeros(2900,25);

          for i=0:24
            filter1=zeros(2900,1);
            filter2=zeros(2900,1);
     
            n=80+(i*100):180+(i*100);
            filter1(n)=((1/100)*n-((80+(100*i))/100));
     
            n=181+(i*100):280+(i*100);
            filter2(n)=((-1/100)*n+((280+(100*i))/100));
            filter_number_i(1:2900,i+1)=filter1+filter2;
          end
          % I map every frequency that fft made into mel space and name it melf
          f(1:NFFT/2+1,1) = fs/2*linspace(0,1,NFFT/2+1);
          melf(1:NFFT/2+1,1)=2595*log10(1+(f/700));
         % for limited of sample in filter         melf=round(melf);
         % in this program I choose 2900 sample per filter
         % filter from mel to frequency
         filter_i_mel=zeros(NFFT/2+1,25);
         melf=round(melf);
          for i=1:25
                 for n=2:NFFT/2+1
                      filter_i_mel(n,i)=filter_number_i(melf(n),i);
                 end       
         end

    end


    
    
    % calculate output for each filter in one frame
     output_filter_i=zeros(NFFT/2+1,25);
     for i=1:25
         for n=1:NFFT/2+1
              output_filter_i(n,i)=filter_i_mel(n,i)*abs(fft_frame(n)); 
         end
     end
     
    % calculate log10(enrgy) for each filter in one frame     
     mj=zeros(25,1);
     energy=zeros(25,1);
     for i=1:25
         for n=1:NFFT/2+1
        energy(i)=energy(i)+(output_filter_i(n,i))^2;
         end
     mj(i)=log10(energy(i));
     end
    %-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     
    %part 6
    
    %c1-c12
    if firstloop==1
    c=zeros(12,fix((wave_length-N)/M)+1);
    end
     for i=1:12
             for j=1:25
                 c(i,frame_number)=c(i,frame_number)+sqrt(2/25)*mj(j)*(cos(((pi*i)/25)*(j-0.5)));
             end
     end
     


    firstloop=0;
    frame_number=frame_number+1;
   
end

I=fix((wave_length-N)/M)+1;
end

