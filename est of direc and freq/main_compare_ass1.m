%% Make a plot of the estimation performance 
clear all
close all
%  of 3 methods(mean and theta of estimated angles and freqs

%  as a function of SNR, for d=2, M=3, N=20,theta=[-20,30], f=[0.1,0.12]
% space between antennas
Delta = 1/2;
d=2;
M=3;
N=20;
theta=[-20;30];
f=[0.1;0.12];
SNR_array = 0:4:20; % SNR_array = [0, 4, 8, 12, 16, 20]

size_SNR_array = size(SNR_array,2); % get the number of SNR value for this experiment

% statistcs of each method
mean_value_esprit = zeros(d,size_SNR_array);
std_value_esprit = zeros(d,size_SNR_array);

mean_value_espritfreq = zeros(d,size_SNR_array);
std_value_espritfreq = zeros(d,size_SNR_array);

mean_value_joint_angel = zeros(d,size_SNR_array);
std_value_joint_angel = zeros(d,size_SNR_array);

mean_value_joint_freq = zeros(d,size_SNR_array);
std_value_joint_freq = zeros(d,size_SNR_array);


% result of each method
theta_est_array = zeros(d,1000);  % to store estimation of first method
freq_est_array = zeros(d,1000);

theta_joint_est_array = zeros(d,1000);  % to store estimation of first method
freq_joint_est_array = zeros(d,1000);


for j=1:1:size_SNR_array

%% for SNR = 20

    for i=1:1:1000
    i
    [X,A,S] = gendata(M,N,Delta,theta,f,SNR_array(j));

    % estimation of direction
    theta_est_array(:,i) = sort(esprit(X,d,Delta))


    % estimation of freqs
    freq_est_array(:,i) = sort(espritfreq(X,d));

    % data preparation for joint estimation
    m_order=2;
    Z=zeros(m_order*M,N-m_order+1);
    for ii=1:m_order
        for jj=1:(N-m_order+1)
            Z(1+M*(ii-1):ii*M,jj)=X(:,ii+jj-1);
        end
    end

    % joint estimation of directions and freqs
    m_order2=2; % same as m_order
    [theta_joint_est_array(:,i),freq_joint_est_array(:,i)] = joint(Z,m_order2,M,N,d,Delta);
    end

    % DOA
    mean_value_esprit(:,j) = mean(theta_est_array,2);
    std_value_esprit(:,j) = std(theta_est_array,0,2);
    % freq
    mean_value_espritfreq(:,j) = mean(freq_est_array,2);
    std_value_espritfreq(:,j) = std(freq_est_array,0,2);
    % joint DOA
    mean_value_joint_angel(:,j) = mean(theta_joint_est_array,2);
    std_value_joint_angel(:,j) = std(theta_joint_est_array,0,2);
    
    % joint freq
    mean_value_joint_freq(:,j) = mean(freq_joint_est_array,2);
    std_value_joint_freq(:,j) = std(freq_joint_est_array,0,2);
    

end

%% Plot for DOA estimation
% plot the mean
subplot(1,2,1)
plot(SNR_array, mean_value_esprit(1,:))
xlabel('SNR')
ylabel('Angel')
title('The mean of esprit angel estimation(s1)')
subplot(1,2,2)
plot(SNR_array, mean_value_esprit(2,:))
xlabel('SNR')
title('The mean of esprit angel estimation(s2)')

% plot the std
figure
plot(SNR_array, std_value_esprit(1,:))
hold
plot(SNR_array, std_value_esprit(2,:))
xlabel('SNR')
legend({'first source','second source'},'Location','southwest')
title('The std of esprit angel estimation')

%% Plot for freq estimation
% plot the mean
figure
subplot(1,2,1)
plot(SNR_array, mean_value_espritfreq(1,:))
xlabel('SNR')
ylabel('Frequency')
title('The mean of esprit freq estimation(s1)')
subplot(1,2,2)
plot(SNR_array, mean_value_espritfreq(2,:))
xlabel('SNR')
title('The mean of esprit freq estimation(s2)')

% plot the std
figure
plot(SNR_array, std_value_espritfreq(1,:))
hold
plot(SNR_array, std_value_espritfreq(2,:))
xlabel('SNR')
legend({'first source','second source'},'Location','southwest')
title('The std of esprit freq estimation')

%% Plot for joint estimation
% plot the angel
    % plot the mean
figure
subplot(1,2,1)
plot(SNR_array, mean_value_joint_angel(1,:))
xlabel('SNR')
ylabel('Angel')
title('The mean of joint angel estimation(s1)')
subplot(1,2,2)
plot(SNR_array, mean_value_joint_angel(2,:))
xlabel('SNR')
title('The mean of joint angel estimation(s2)')
    % plot the std
figure
plot(SNR_array, std_value_joint_angel(1,:))
hold
plot(SNR_array, std_value_joint_angel(2,:))
xlabel('SNR')
legend({'first source','second source'},'Location','southwest')
title('The std of joint angel estimation')

% plot the freq
    % plot the mean
figure
subplot(1,2,1)
plot(SNR_array, mean_value_joint_freq(1,:))
xlabel('SNR')
ylabel('Frequency')
title('The mean of joint freq estimation(s1)')
subplot(1,2,2)
plot(SNR_array, mean_value_joint_freq(2,:))
xlabel('SNR')
title('The mean of joint freq estimation(s2)')
    % plot the std
figure
plot(SNR_array, std_value_joint_freq(1,:))
hold
plot(SNR_array, std_value_joint_freq(2,:))
xlabel('SNR')
legend({'first source','second source'},'Location','southwest')
title('The std of joint freq estimation')