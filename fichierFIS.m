% Créer un système flou FIS
fis = mamfis('Name', 'FOFPID_Controller');

% Ajouter les entrées
fis = addInput(fis, [-10 10], 'Name', 'Error');
fis = addMF(fis, 'Error', 'gaussmf', [2 -10], 'Name', 'Negative');
fis = addMF(fis, 'Error', 'gaussmf', [2 0], 'Name', 'Zero');
fis = addMF(fis, 'Error', 'gaussmf', [2 10], 'Name', 'Positive');

fis = addInput(fis, [-10 10], 'Name', 'DeltaError');
fis = addMF(fis, 'DeltaError', 'gaussmf', [2 -10], 'Name', 'Negative');
fis = addMF(fis, 'DeltaError', 'gaussmf', [2 0], 'Name', 'Zero');
fis = addMF(fis, 'DeltaError', 'gaussmf', [2 10], 'Name', 'Positive');

% Ajouter les sorties avec les nouvelles plages
fis = addOutput(fis, [0 100], 'Name', 'Kp');
fis = addMF(fis, 'Kp', 'trimf', [0 25 50], 'Name', 'Small');
fis = addMF(fis, 'Kp', 'trimf', [25 50 75], 'Name', 'Medium');
fis = addMF(fis, 'Kp', 'trimf', [50 75 100], 'Name', 'Large');

fis = addOutput(fis, [0 50], 'Name', 'Ki');
fis = addMF(fis, 'Ki', 'trimf', [0 12.5 25], 'Name', 'Small');
fis = addMF(fis, 'Ki', 'trimf', [12.5 25 37.5], 'Name', 'Medium');
fis = addMF(fis, 'Ki', 'trimf', [25 37.5 50], 'Name', 'Large');

fis = addOutput(fis, [0 20], 'Name', 'Kd');
fis = addMF(fis, 'Kd', 'trimf', [0 5 10], 'Name', 'Small');
fis = addMF(fis, 'Kd', 'trimf', [5 10 15], 'Name', 'Medium');
fis = addMF(fis, 'Kd', 'trimf', [10 15 20], 'Name', 'Large');

% Ajouter des règles floues
ruleList = [
    1 1 3 2 1 1 1;  % Si Error est Negative et DeltaError est Negative, alors Kp = Large, Ki = Medium, Kd = Small
    2 2 2 2 2 1 1;  % Si Error est Zero et DeltaError est Zero, alors Kp = Medium, Ki = Medium, Kd = Medium
    3 3 1 3 3 1 1;  % Si Error est Positive et DeltaError est Positive, alors Kp = Small, Ki = Large, Kd = Large
];
fis = addRule(fis, ruleList);

% Sauvegarder le fichier FIS
writeFIS(fis, 'FOFPID_Controller.fis');

% Afficher le système flou
ruleview(fis); % Affiche l'éditeur de règles