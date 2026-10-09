dt = 0.1; % 10 radar frames per second
time = 0:dt:5-dt;

true_range = 50 + 30 * time; % Starts at 50m, drives at 30m/s
true_velocity = 30 * ones(1, length(time));

noisy_measurements = true_range + randn(1, length(time)) * 2; % Add +/- 2m of static noise
noisy_velocity = true_velocity + randn(1, length(time)) * 1;


X = [50; 2];      % Initial guess 
F = [1 dt; 0 1];  % State Transition Matrix (Position & Velocity)
H = [1 0; 0 1];        % Measurement Matrix (we only measure position, not velocity directly)


P = [10 0; 0 10]; % Initial Uncertainty
R = 4;            % Sensor Noise 
Q = [0.1 0; 0 0.1]; % Process Noise 


filtered_range = zeros(1, length(time));
filtered_velocity =  zeros(1, length(time));

% Kalman Filter loop
for i=1:length(time)
    X_pred = F * X;
    P_pred = F * P * F' + Q;
    
    Z = [noisy_measurements(i);noisy_velocity(i)];
     
    K = P_pred * H' / (H * P_pred * H' + R);
    pred_measurement = H*X_pred;
    X = X_pred + K * (Z - pred_measurement);
    
    P = (eye(2)- K*H) * P_pred;
    filtered_range(i) = X(1); 
    filtered_velocity(i) = X(2);
end

figure('Name', 'Kalman Filter: Range & Velocity', 'Position', [100, 100, 800, 400]);
% Subplot 1: Range
subplot(1,2,1);
plot(time, true_range, 'k--', 'LineWidth', 2); hold on;
plot(time, noisy_measurements, 'r.', 'MarkerSize', 15);
plot(time, filtered_range, 'b-', 'LineWidth', 2);
title('Range Tracking'); xlabel('Time (s)'); ylabel('Range (m)');
legend('True Path', 'Noisy CFAR Blips', 'Kalman Filter', 'Location', 'Best');
% Subplot 2: Velocity
subplot(1,2,2);
plot(time, true_velocity, 'k--', 'LineWidth', 2); hold on;
plot(time, noisy_velocity, 'r.', 'MarkerSize', 15);
plot(time, filtered_velocity, 'b-', 'LineWidth', 2);
title('Velocity Tracking'); xlabel('Time (s)'); ylabel('Velocity (m/s)');
legend('True Velocity', 'Noisy Doppler', 'Kalman Filter', 'Location', 'Best');