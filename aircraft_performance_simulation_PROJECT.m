%==========================================================================
%------------------AIRCRAFT PERFORMANCE SIMULATION-------------------------
%
% Objective:
% To simulate basic aircraft aerodynamic and performance characteristics
% using MATLAB.
%
% Features:
% - Lift and Drag Analysis
% - Stall Speed Estimation
% - Thrust and Power Required
% - Drag Polar
% - Maximum L/D Condition
% - Minimum Drag Speed
% - Flight Envelope Visualization
%
%==========================================================================

clc,clearvars,format compact,close all

%==========================================================================
%---------------------------------INITIALIZER------------------------------
%==========================================================================

mass = 2;
g = 9.81;
w= mass*g;

%==========================================================================
%--------------------AIRCRAFT AND AERODYNAMIC TERMS------------------------
%==========================================================================

clmax=1.2;
rho = 1.225;
s =0.2;
cl = 0.5;
%----------------------------DRAG CALCULATION-----------------------------

cd0 = 0.02;
k = 0.30;
cd = cd0 + k*cl.^2;

thrust_available=20;
vstall = sqrt((2*w)/(rho*s*clmax));
v=vstall:0.1:100;

l = 0.5*rho*v.^2*s*cl;
d = 0.5*rho*v.^2*s*cd;

cl_required = (2*w)./(rho*v.^2*s);
cd_required = cd0 + k*cl_required.^2;
d_required = 0.5*rho*v.^2*s.*cd_required;
[min_drag,min_idx] = min(d_required);
V_min_drag = v(min_idx);
thrust_required=d_required;
power_required=thrust_required.*v;
cl_values = 0:0.05:1.5;
cd_values = cd0 + k*cl_values.^2;
ld_values=cl_values./cd_values;

[ld_max,idx]=max(ld_values);
cl_opt=cl_values(idx);

idx = find(thrust_required >= thrust_available,1);
if isempty(idx)
    Vmax_graph = NaN;
else
    Vmax_graph = v(idx);
end

Vmax_formula = sqrt((2*thrust_available)/(rho*s*cd));

xls=find(l>=w,1);
Vmin1_by_graph=v(xls);
Vmin2_by_formula = sqrt((2*w)/(rho*s*cl));
v_ldmax = sqrt((2*w)/(rho*s*cl_opt));

%=========================================================================
%------------------------------PLOTTING-----------------------------------
%=========================================================================

figure
subplot(2,3,1)
plot(v,l)
xlabel('velocity(m/s)'),ylabel('lift(N)')
yline(w,'LineWidth',2)
grid on
title('velocity vs lift')

subplot(2,3,2)
plot(v,d_required)
xlabel('velocity(m/s)'),ylabel('drag(N)')
grid on
title('velocity vs drag')

subplot(2,3,3)
ld=w./d_required;
plot(v,ld,'LineWidth',2)
grid on
xlabel('Velocity (m/s)')
ylabel('L/D')
title('Lift-to-Drag Ratio')

subplot(2,3,4)
plot(v,l)
hold on
yline(w,'r','LineWidth',2)
xline(vstall,'LineWidth',2)
grid on
xlabel('Velocity (m/s)')
ylabel('Lift (N)')
title('Lift vs Weight with Stall Limit')

subplot(2,3,5)
plot(v,thrust_required,'LineWidth',2)
hold on
yline(thrust_available,'r','LineWidth',2)
grid on
xlabel('Velocity')
ylabel('Thrust')
title('Thrust Required vs Available')
legend('Thrust Required','Thrust Available')
xlim([0 50])
ylim([0 50])

subplot(2,3,6)
plot(v,power_required,'LineWidth',2)
grid on
title('Power Required vs Velocity')
xlabel('Velocity (m/s)')
ylabel('Power (W)')

figure

subplot(2,2,1)
plot(cl_values,cd_values,'LineWidth',2)
grid on
xlabel('C_L')
ylabel('C_D')
title('Drag Polar')
xlim([0 1.5])
ylim([0 1.5])

subplot(2,2,2)
plot(cl_values,ld_values,'LineWidth',2)
hold on
plot(cl_opt,ld_max,'ro','MarkerFaceColor','r')
grid on
xlabel('C_L'),ylabel('L/D')
title('lift to drag ratio vs C_L')

subplot(2,2,3)
xline(vstall,'r','LineWidth',2)
hold on
xline(v_ldmax,'g','LineWidth',2)
xline(Vmax_graph,'b','LineWidth',2)
grid on
xlabel('Velocity (m/s)')
title('Aircraft Flight Envelope')
legend('Stall Speed','Best L/D Speed','Maximum Speed')

subplot(2,2,4)
plot(v,cl_required,'LineWidth',2)
hold on
yline(clmax,'r','LineWidth',2)
grid on
xlabel('Velocity (m/s)')
ylabel('Required C_L')
title('Required C_L vs Velocity')
legend('Required C_L','C_{L,max}')
ylim([0 2]) 

figure
plot(v,d_required,'LineWidth',2)
hold on
plot(V_min_drag,min_drag,'ro','MarkerFaceColor','r')
grid on
xlabel('Velocity (m/s)')
ylabel('Drag Required (N)')
title('Drag Required vs Velocity')

%==========================================================================
%------------------------PRINTING RESULTS----------------------------------
%==========================================================================
fprintf('\nAIRCRAFT PERFORMANCE RESULTS\n')
fprintf('Maximum Speed (by graph) = %.2f m/s\n',Vmax_graph)
fprintf('Maximum Speed (Formula) = %.2f m/s\n',Vmax_formula)
fprintf('Minimum Flight Speed (by graph) = %.2f m/s\n',Vmin1_by_graph)
fprintf('Minimum Flight Speed (Formula) = %.2f m/s\n',Vmin2_by_formula)
fprintf('Stall Speed = %.2f m/s\n', vstall)
fprintf('Maximum L/D Ratio = %.2f\n',ld_max)
fprintf('Speed for Maximum L/D = %.2f m/s\n', v_ldmax)
fprintf('Speed for Minimum Drag = %.2f m/s\n',V_min_drag)