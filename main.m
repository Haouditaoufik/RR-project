% Script principal
clear; clc;

% Paramètres du système robotique
l1 = 1.0; l2 = 0.8; m1 = 1.0; m2 = 0.8; g = 9.81;

% Trajectoires désirées
Tsim = 10; dt = 0.01; time = 0:dt:Tsim;
theta_desired1 = sin(2 * pi * 0.2 * time); % Trajectoire pour theta1
theta_desired2 = cos(2 * pi * 0.2 * time); % Trajectoire pour theta2

% Création du système flou
fis = fichierFIS();

% Optimisation des paramètres FOPID
[Kp1, Ki1, Kd1, Kp2, Ki2, Kd2] = optimizeFOPID(@(params) simulateRobotPoint(params, Tsim, dt, theta_desired1, theta_desired2, l1, l2, m1, m2, g, fis, true));

% Simulation finale
[theta_real1, theta_real2] = simulateRobotPoint([Kp1, Ki1, Kd1, Kp2, Ki2, Kd2], Tsim, dt, theta_desired1, theta_desired2, l1, l2, m1, m2, g, fis, false);

% Affichage des résultats
figure;
subplot(2, 1, 1);
plot(time, theta_desired1, 'r--', time, theta_real1, 'b');
xlabel('Temps (s)'); ylabel('\theta_1 (rad)');
legend('Désirée', 'Réelle');
title('Suivi de trajectoire pour \theta_1');

subplot(2, 1, 2);
plot(time, theta_desired2, 'r--', time, theta_real2, 'b');
xlabel('Temps (s)'); ylabel('\theta_2 (rad)');
legend('Désirée', 'Réelle');
title('Suivi de trajectoire pour \theta_2');