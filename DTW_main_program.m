%  creator : iman shahryary
% date : 1396/9/22
clear all
close all
clc

%DTW_main_program
%source cepstral number
%words:  amirkabir  bastanshenas  farvardin  ketabdar
[c1,T1] = my_mfcc('amirkabir.wav' );
[c2,T2] = my_mfcc('bastanshenas.wav' );
[c3,T3] = my_mfcc('farvardin.wav' );
[c4,T4] = my_mfcc('ketabdar.wav' );
%example: amirkabir  bastanshenas  farvardin  ketabdar
[c5,T5] = my_mfcc('amirkabir2.wav' );
[c6,T6] = my_mfcc('bastanshenas2.wav' );
[c7,T7] = my_mfcc('farvardin2.wav' );
[c8,T8] = my_mfcc('ketabdar2.wav' );
%you can choose every sample that you want 
% each word record twice
% by changing  Cin & Tx from    c5 upto c8    & T5 upto T8

%% main program --------------------------------------------------------------  

Cin=c5;
Tx=T5;

%t : number of source
% Dt : difference of two word
Dt=zeros(4,1);
for t=1:4
%% choosing source
index=int2str(t);
A={'c',index};
B=strjoin(A,'');
if strcmp(B,'c1')
    C=c1;
    Ty=T1;
elseif strcmp(B,'c2')
    C=c2;
    Ty=T2;    
elseif strcmp(B,'c3')
    C=c3;
    Ty=T3;
elseif strcmp(B,'c4')
    C=c4;
    Ty=T4;
end

%% 
% D : cost from (1,1) to the specific point
% k : step of optimal path to each point
% zeta : difference of each point 
% difference : matrix for saving result during calculation
% path :  4D matrix for saving optimal path to each point
% area : for display area

D=zeros(Tx,Ty);
k=zeros(Tx,Ty);
zeta=zeros(Tx,Ty);
difference=zeros(12,1);
path=zeros(min(Tx,Ty),2,Tx,Ty);
area=zeros(Tx,Ty);


%% preset for (1,1)        
% calculate zeta for (1,1)
        for n=1:12
            difference(n)=Cin(n,1)-C(n,1);
        end
        for n=1:12
           zeta(1,1)=zeta(1,1)+difference(n);
        end
      
D(1,1)=zeta(1,1);
k(1,1)=1;
path(1,1,1,1)=1;
path(1,2,1,1)=1;
area(1,1)=1;
  
 %%  calculate for other point      
for ix=2:Tx
    for iy=2:Ty
        if 0.5<=((iy-1)/(ix-1))&&((iy-1)/(ix-1))<=2&&0.5<=((Ty-iy)/(Tx-ix))&&((Ty-iy)/(Tx-ix))<=2||(ix ==Tx)&&(iy==Ty)
         area(ix,iy)=1;   
        for n=1:12
            difference(n)=(Cin(n,ix)-C(n,iy))^2;
        end
        for n=1:12
           zeta(ix,iy)=zeta(ix,iy)+difference(n);
        end
        zeta(ix,iy)=sqrt(zeta(ix,iy));

        %mahdoodiat harekat   (a,b)=(2,1)
        %m=min(delta_x,delta_y)=min(a,b)=1
        if 0.5<((iy-1)/(ix-2))&&((iy-1)/(ix-2))<2&&0.5<=((Ty-iy+1)/(Tx-ix+2))&&((Ty-iy+1)/(Tx-ix+2))<=2
            d1=D(ix-2,iy-1)+zeta(ix,iy);            
        else
            d1=inf;
        end
        
        %mahdoodiat harekat   (a,b)=(1,1)
        %m=min(delta_x,delta_y)=min(a,b)=1
        if 0.5<((iy-1)/(ix-1))&&((iy-1)/(ix-1))<2&&0.5<=((Ty-iy+1)/(Tx-ix+1))&&((Ty-iy+1)/(Tx-ix+1))<=2
            d2=D(ix-1,iy-1)+zeta(ix,iy);
        else
            d2=inf;
        end
        
        %moving limitation   (a,b)=(1,2)
        %m=min(delta_x,delta_y)=min(a,b)=1
        if 0.5<((iy-2)/(ix-1))&&((iy-2)/(ix-1))<2&&0.5<=((Ty-iy+2)/(Tx-ix+1))&&((Ty-iy+2)/(Tx-ix+1))<=2
            d3=D(ix-1,iy-2)+zeta(ix,iy);
        else
            d3=inf;
        end
        
        
        D(ix,iy)=min([d1,d2,d3]);
        
        % finding path and number of step to each point
        if D(ix,iy)==d1&&d1~=inf
            k(ix,iy)=k(ix-2,iy-1)+1;
            path(k(ix,iy),1,ix,iy)=ix;
            path(k(ix,iy),2,ix,iy)=iy;
            for a=1:k(ix-2,iy-1)
                for b=1:2
                    path(a,b,ix,iy)=path(a,b,ix-2,iy-1);
                end
            end
        elseif D(ix,iy)==d2&&d2~=inf
            k(ix,iy)=k(ix-1,iy-1)+1;
            path(k(ix,iy),1,ix,iy)=ix;
            path(k(ix,iy),2,ix,iy)=iy;
            for a=1:k(ix-1,iy-1)
                for b=1:2
                    path(a,b,ix,iy)=path(a,b,ix-1,iy-1);
                end
            end
        elseif D(ix,iy)==d3&&d3~=inf
            k(ix,iy)=k(ix-1,iy-2)+1;
            path(k(ix,iy),1,ix,iy)=ix;
            path(k(ix,iy),2,ix,iy)=iy;
            for a=1:k(ix-1,iy-2)
                for b=1:2
                    path(a,b,ix,iy)=path(a,b,ix-1,iy-2);
                end
            end
        end
         
        end   
    end
end

%way : path to the last point 
way=zeros(min(Tx,Ty),2);
for a=1:min(Tx,Ty)
way(a,1)=path(a,1,Tx,Ty);
way(a,2)=path(a,2,Tx,Ty);
end


figure (1)
subplot(2,2,t)
plot(way(1:k(ix,iy),1),way(1:k(ix,iy),2),'r')
if t==1 
    title( 'check sample with amirkabir')
elseif t==2
    title( 'check sample with bastanshenas')
elseif t==3
    title( 'check sample with farvardin')
elseif t==4
    title( 'check sample with ketabdar')
end
axis([0,Tx,0,Ty])
grid on
grid minor
hold on
for ix=2:Tx-1
    for iy=2:Ty-1
        if area(ix,iy)==1&&area(ix,iy-1)==1&&area(ix,iy+1)==0||area(ix,iy)==1&&area(ix,iy-1)==0&&area(ix,iy+1)==1
           
            plot(ix,iy,'k.')
        end
    end
end
plot(1,1,'k.')
plot(Tx,Ty,'k.')


Dt(t,1)=D(Tx,Ty)/Tx;

end


%show the word that you choose for input
a=min(Dt);
if a==Dt(1,1)
    disp('the input word is Amirkabir')
elseif a==Dt(2,1)
    disp('the input word is Bastanshenas')
elseif a==Dt(3,1)
    disp('the input word is Farvardin')
elseif a==Dt(4,1)
    disp('the input word is Ketabdar')
end






