clc;
clear;
close all;

%% ==============================
% 1. SYSTEM PARAMETERS
% ==============================

A = [0 1;
    -2 -3];

B = [0;
     1];

K = [1 -4];

sigma = 0.05;
sigma_dash = 0.04;

delay = 0.005;

dt = 0.0001;
T = 2;
t = 0:dt:T;

%% ==============================
% 2. INITIAL CONDITIONS
% ==============================

x = [2;2];
x_last = x;

u = K*x_last;

pending_update = false;
update_time = 0;
x_snapshot = [0;0];

x_str = zeros(2,length(t));
e_norm_str = zeros(1,length(t));
trigger_events = zeros(1,length(t));

control_count = 0;

%% ==============================
% 3. EVENT-TRIGGERED SIMULATION
% ==============================

for i = 1:length(t)

    curr_t = t(i);

    x_str(:,i) = x;

    %% Measurement Error
    e = x_last - x;

    e_norm = norm(e);

    e_norm_str(i) = e_norm;

    %% Event Trigger Condition
    if (e_norm >= sigma_dash*norm(x)) && ~pending_update

        pending_update = true;

        update_time = curr_t + delay;

        x_snapshot = x;

        trigger_events(i) = 1;

    end

    %% Delayed Control Update
    if pending_update && (curr_t >= update_time)

        x_last = x_snapshot;

        u = K*x_last;

        control_count = control_count + 1;

        pending_update = false;

    end

    %% Disturbance Injection
    if curr_t >= 1.0
        disturbance = [0;
                       0.8];
    else
        disturbance = [0;
                       0];
    end

    %% Plant Dynamics
    x_dot = A*x + B*u + disturbance;

    x = x + x_dot*dt;

end

%% ==============================
% 4. PERIODIC CONTROL BASELINE
% ==============================

x_p = [2;2];
x_p_store = zeros(2,length(t));

for i = 1:length(t)

    curr_t = t(i);

    %% Same disturbance for comparison
    if curr_t >= 1.0
        disturbance_p = [0;
                         0.8];
    else
        disturbance_p = [0;
                         0];
    end

    u_p = K*x_p;

    x_dot_p = A*x_p + B*u_p + disturbance_p;

    x_p = x_p + x_dot_p*dt;

    x_p_store(:,i) = x_p;

end

%% ==============================
% 5. CPU ANALYSIS
% ==============================

periodic_executions = length(t);

event_execution_rate = ...
    (control_count/periodic_executions)*100;

execution_reduction = ...
    100 - event_execution_rate;

fprintf('\n');
fprintf('Total Simulation Steps : %d\n', periodic_executions);
fprintf('Control Executions     : %d\n', control_count);
fprintf('Event Execution Rate   : %.2f %%\n', ...
    event_execution_rate);
fprintf('Execution Reduction    : %.2f %%\n', ...
    execution_reduction);
%% ==============================
% 6. INTER-EVENT TIMES
% ==============================

trigger_times = t(trigger_events==1);

if length(trigger_times) > 1

    inter_event_times = diff(trigger_times);

    avg_inter_event_time = ...
        mean(inter_event_times);

    fprintf('Average Inter-Event Time : %.4f sec\n', ...
        avg_inter_event_time);

else

    inter_event_times = [];

end

%% Detection Latency

disturbance_time = 1.0;

idx = find(trigger_times > disturbance_time,1);

if ~isempty(idx)

    detection_latency = ...
        trigger_times(idx) - disturbance_time;

    fprintf('Detection Latency        : %.4f sec\n', ...
        detection_latency);

end

%% ==============================
% 7. HEALTH / FAULT MONITORING
% ==============================

x_norm = vecnorm(x_str);

fault_flag = zeros(1,length(t));

fault_threshold = 3;   % reduced threshold to show fault after disturbance

for i = 1:length(t)

    if x_norm(i) > fault_threshold
        fault_flag(i) = 1;
    end

end

%% ==============================
% 8. PLOTS
% ==============================

%% Event Trigger Condition
figure('Color','w');
hold on;

plot(t,e_norm_str,'LineWidth',1.3);

plot(t(trigger_events==1), ...
     e_norm_str(trigger_events==1), ...
     'ro','MarkerFaceColor','r');

plot(t,sigma_dash*x_norm,'k--','LineWidth',1.2);

xline(1,'m--','Disturbance Applied');

grid on;

xlabel('Time (s)');
ylabel('Magnitude');
title('Event Triggering Condition with Disturbance');

legend('|e(t)|','Trigger Events','Threshold');

%% State Comparison
figure('Color','w');

plot(t,x_str(1,:), ...
    'b','LineWidth',1.5);

hold on;

plot(t,x_p_store(1,:), ...
    'r--','LineWidth',1.5);

xline(1,'m--','Disturbance Applied');

grid on;

xlabel('Time (s)');
ylabel('State x_1');

title('Event-Triggered vs Periodic Control');

legend('Event Triggered','Periodic');

%% Inter-event intervals
if ~isempty(inter_event_times)

figure('Color','w');

plot(inter_event_times,'LineWidth',1.5);

grid on;

xlabel('Trigger Number');
ylabel('Time (s)');

title('Inter-Event Intervals');

end

%% Health Monitoring
figure('Color','w');

plot(t,x_norm,'LineWidth',1.5);
hold on;

yline(fault_threshold,'r--','Fault Threshold');

xline(1,'m--','Disturbance Applied');

grid on;

xlabel('Time (s)');
ylabel('||x(t)||');

title('System Health Monitoring');

%% Fault Timeline
figure('Color','w');

stairs(t,fault_flag,'LineWidth',2);

xline(1,'m--','Disturbance Applied');

ylim([-0.1 1.1]);

grid on;

xlabel('Time (s)');
ylabel('Fault Status');

title('Fault Detection Timeline');

%% Event Distribution

figure('Color','w');

histogram(trigger_times,20);

grid on;

xlabel('Time (s)');
ylabel('Number of Events');

title('Event Distribution Over Time');