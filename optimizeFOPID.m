function [bestKp1, bestKi1, bestKd1, bestKp2, bestKi2, bestKd2] = optimizeFOPID(costFunction)
    % Paramètres de PSO
    numParticles = 20;
    numIterations = 50;
    Kp_range = [0, 100];
    Ki_range = [0, 50];
    Kd_range = [0, 20];

    % Initialisation des particules
    particles = rand(numParticles, 6); % 6 paramètres : Kp1, Ki1, Kd1, Kp2, Ki2, Kd2
    particles(:, 1) = Kp_range(1) + particles(:, 1) * diff(Kp_range); % Kp1
    particles(:, 2) = Ki_range(1) + particles(:, 2) * diff(Ki_range); % Ki1
    particles(:, 3) = Kd_range(1) + particles(:, 3) * diff(Kd_range); % Kd1
    particles(:, 4) = Kp_range(1) + particles(:, 4) * diff(Kp_range); % Kp2
    particles(:, 5) = Ki_range(1) + particles(:, 5) * diff(Ki_range); % Ki2
    particles(:, 6) = Kd_range(1) + particles(:, 6) * diff(Kd_range); % Kd2
    velocities = zeros(size(particles));

    % Meilleures solutions
    personalBest = particles;
    personalBestCost = inf(numParticles, 1);
    globalBest = particles(1, :);
    globalBestCost = inf;

    % Boucle PSO
    for iter = 1:numIterations
        for i = 1:numParticles
            % Évaluation de la fonction de coût
            cost = costFunction(particles(i, :)); % Simule le robot avec les gains actuels
            if cost < personalBestCost(i)
                personalBestCost(i) = cost;
                personalBest(i, :) = particles(i, :);
            end
            if cost < globalBestCost
                globalBestCost = cost;
                globalBest = particles(i, :);
            end
        end

        % Mise à jour des particules
        w = 0.5; c1 = 1.5; c2 = 1.5;
        for i = 1:numParticles
            velocities(i, :) = w * velocities(i, :) + ...
                               c1 * rand * (personalBest(i, :) - particles(i, :)) + ...
                               c2 * rand * (globalBest - particles(i, :));
            particles(i, :) = particles(i, :) + velocities(i, :);
            % Assurer que les particules restent dans les limites
            particles(i, 1) = max(Kp_range(1), min(Kp_range(2), particles(i, 1))); % Kp1
            particles(i, 2) = max(Ki_range(1), min(Ki_range(2), particles(i, 2))); % Ki1
            particles(i, 3) = max(Kd_range(1), min(Kd_range(2), particles(i, 3))); % Kd1
            particles(i, 4) = max(Kp_range(1), min(Kp_range(2), particles(i, 4))); % Kp2
            particles(i, 5) = max(Ki_range(1), min(Ki_range(2), particles(i, 5))); % Ki2
            particles(i, 6) = max(Kd_range(1), min(Kd_range(2), particles(i, 6))); % Kd2
        end
    end

    % Retourner les meilleurs gains trouvés
    bestKp1 = globalBest(1);
    bestKi1 = globalBest(2);
    bestKd1 = globalBest(3);
    bestKp2 = globalBest(4);
    bestKi2 = globalBest(5);
    bestKd2 = globalBest(6);
end