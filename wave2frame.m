function [frame,is_last_frame,N,M,wave_length,fs]=wave2frame(frame_overlap,frame_length,flag,frame_number,wave_name,alfa)

% input
% frame_overlap: ms       number N;
% frame_length: ms          number N;
% flag:where the first fram want to be start numberN<wave_length - fs*(frame_length/1000);
% frame number : number of the frame that you want
% wave name       str;
% alfa      preemphasis    number N<1;


%internal function variable
%wave : the input wave in it
%start_frame_from : the sample number that  the frame start from that
%                                     = flag + (frame_number-1)*M
%frame_kham:frame befor preemphasis
%                          =zeros(fs*(frame_length/1000),1)



%output
% frame: frame preemphasis
%              zeros(fs*(frame_length/1000),1);
%is_last_frame:it show's this is the last frame of the wave   0   or 1
%N:sample_number_for_frame
%M:sample number for overlap
% wave_length=zeros(1,1);
% fs=zeros(1,1);


%output 6  fs
[wave,fs]=audioread(wave_name);
wave=32767*wave;

%output 5  wave_length
wave_length=length(wave);


%output 1& 3 & 4 frame  N   M
M=fix(fs * (frame_overlap/1000));
N=fix(fs * (frame_length/1000));
frame=zeros(N,1);
start_frame_from = flag + (frame_number-1) * M;
frame_nochange=zeros(N,1);

    if start_frame_from+N<wave_length
        for n=1:N
          frame_nochange(n,1)=wave(n+start_frame_from,1);
        end
    
          for n=1:N
            if n==1&&start_frame_from==1            
                frame(n,1)=frame_nochange(1,1)-alfa*frame_nochange(1,1);
          elseif n==1&&start_frame_from~=1
               frame(n,1)=frame_nochange(1,1)-alfa*wave(start_frame_from-1,1);
            else 
             frame(n,1)=frame_nochange(n)-alfa*frame_nochange(n-1);
            end
          end
    else
        frame=zeros(N,1);
    end

    

%output 2 is_last_frame
if wave_length - start_frame_from> N+M
    is_last_frame=0;
else
     is_last_frame=1;
end

end
