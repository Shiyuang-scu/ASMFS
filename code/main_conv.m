dataset = 'AD vs. NC';
dataset = 'MCI vs. NC';
dataset = 'MCI-C vs. MCI-NC';
plot(output.obj,'ro-');
title(dataset);
xlabel('Iteration');
ylabel('Objective function value');

