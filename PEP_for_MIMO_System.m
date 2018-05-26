clc;
close all;

% Setting the initial parameters

N = 10^5;
Mt = 2;
co = [1,1;-1,1];
c1 = [-1,-1;1,-1];
N = 10^5;
SNRatio = -6:2:12;
err = zeros(length(SNRatio));

% Theoretical value from the derived equation

for i = 1:length(SNRatio)
    p = 10.^(0.1*SNRatio(i));
    r = rank(co-c1);
    A = ctranspose(co-c1) * (co-c1);
    Lamda = eig(A)'
 for k = 1:r
    Pep = 1/(1+ (p*Lamda(k))/4*Mt);
 end
    x2 = 0.5*(prod(Pep));
Pr(i) = x2;
end

% Calculating p and randomizing the selection of ST signals
for i = 1:length(SNRatio)    
    p = 10.^(0.1*SNRatio(i));
        for j = 1:100000
        out = randi(20);
           if (out/2) == 1
           Channel_out = co;
           else 
           Channel_out = c1;
           end
   
% Simulation using the equation
            H = [sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1); sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1)];
            symbol = (sqrt(p/Mt)*Channel_out)*H;   
            N = [sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1); sqrt(1/2)*randn(1) + i*sqrt(1/2)*rand(1)];
            Y = sqrt(p/Mt)*Channel_out*H + N;
            Co_received = (norm(Y - sqrt(p/Mt)*co*H))^2;
            C1_received = (norm(Y- sqrt(p/Mt)*c1*H))^2;
            opvalue = min(Co_received, C1_received);
   
            if (opvalue == Co_received)
            final_received = co;
            else
            final_received = c1;
            end

% Calculating the Error
        if (( final_received - Channel_out)~=0)
        err(i) = err(i)+1;
        end
    end
   c = err(i);
   err(i)=err(i)/100000;
end

figure
semilogy(SNRatio,Pr,'LineWidth',2);
hold all
semilogy(SNRatio,err,'Linewidth',2);
grid on
legend('THEORETICAL', 'SIMULATED');
xlabel('Signal to Noise Ratio in dB');
ylabel('Error Probability ');
title('PairWise Error Probability Curve ');
 
