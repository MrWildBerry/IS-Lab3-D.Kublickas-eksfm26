clc;
clear;
close all;

% ----- MOKYMO DUOMENYS -----

x = 0.1:1/22:1;

% Norimas atsakas
d = (1 + 0.6*sin(2*pi*x/0.7) + 0.3*sin(2*pi*x))/2;


% ----- SBF PARAMETRAI -----

% Centrai parenkami rankiniu būdu
c1 = 0.19;
c2 = 0.90;

% Spinduliai parenkami rankiniu būdu
r1 = 0.19;
r2 = 0.19;


% ----- PRADINIAI SVORIAI -----

w1 = rand;
w2 = rand;
w0 = rand;


% Mokymosi greitis
eta = 0.1;

% Epochų skaičius
epochs = 50;


% ----- MOKYMAS -----

for epoch = 1:epochs

    E = 0;

    for n = 1:length(x)

        % Gauso funkcijos
        F1 = exp(-(x(n)-c1)^2 / (2*r1^2));
        F2 = exp(-(x(n)-c2)^2 / (2*r2^2));

        % Tinklo išėjimas
        y = w1*F1 + w2*F2 + w0;

        % Klaida
        e = d(n) - y;

        % Svorių atnaujinimas
        w1 = w1 + eta*e*F1;
        w2 = w2 + eta*e*F2;
        w0 = w0 + eta*e;

        % Bendra epochos klaida
        E = E + e^2;

    end

    % Vidutinė kvadratinė klaida
    MSE(epoch) = E / length(x);

end


% ----- TINKLO PATIKRINIMAS -----

x1 = 0.1:1/202:1;

for n = 1:length(x1)

    F1 = exp(-(x1(n)-c1)^2 / (2*r1^2));
    F2 = exp(-(x1(n)-c2)^2 / (2*r2^2));

    y_out(n) = w1*F1 + w2*F2 + w0;

end


% ----- REZULTATAI -----

fprintf('w1 = %.4f\n', w1);
fprintf('w2 = %.4f\n', w2);
fprintf('w0 = %.4f\n', w0);


% Norimos ir aproksimuotos funkcijos grafikas
figure;
plot(x, d, 'o-');
hold on;
plot(x1, y_out, '*-');
grid on;

xlabel('x');
ylabel('y');
legend('Norimas atsakas d', 'SBF tinklo atsakas y');
title('SBF tinklo aproksimacija');


% Klaidos grafikas
figure;
plot(MSE);
grid on;

xlabel('Epocha');
ylabel('MSE');
title('Mokymo klaida');

% Bazinės funkcijos

F1_all = exp(-(x-c1).^2 / (2*r1^2));
F2_all = exp(-(x-c2).^2 / (2*r2^2));

figure;
plot(x, F1_all);
hold on;
plot(x, F2_all);
grid on;

legend('F1', 'F2');
xlabel('x');
ylabel('F');
title('Gauso bazinės funkcijos');