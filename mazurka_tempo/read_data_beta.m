tempo_mat = csvread('mazurka17-4.csv', 2, 0);

for i = 3:20

    tempo_vec = tempo_mat(:, i);

    spb_vec = (1 ./ tempo_vec) * 60; %sec per beat

    time_vec = cumsum(spb_vec);

    figure(1)
    plot(time_vec, tempo_vec)

    figure(2)
    plot(tempo_vec)

    dtempo_dt = diff(tempo_vec) ./ diff(time_vec);
    
    alpha_vec = dtempo_dt ./ tempo_vec(2:end); %
    
    figure(3)
    plot(time_vec(2:end),dtempo_dt)
    plot(alpha_vec)
    
    
    pause();

end