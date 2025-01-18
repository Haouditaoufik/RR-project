function [theta1, theta2] = inverseKinematics(x, y, l1, l2)
    % Résolution de la cinématique inverse pour un bras robotique à 2 liens
    cos_theta2 = (x^2 + y^2 - l1^2 - l2^2) / (2 * l1 * l2);

    % Vérification de la validité de cos_theta2
    if cos_theta2 < -1 || cos_theta2 > 1
        error('La position (x, y) est hors de portée du bras robotique.');
    end

    % Calcul des angles
    theta2 = atan2(sqrt(1 - cos_theta2^2), cos_theta2); % Épaule en bas
    theta1 = atan2(y, x) - atan2(l2 * sin(theta2), l1 + l2 * cos(theta2));
end