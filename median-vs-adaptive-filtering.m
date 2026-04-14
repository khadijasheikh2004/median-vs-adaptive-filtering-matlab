clear; clc; 

% Load grayscale image
img = double(rgb2gray(imread("lena.png")));  

% Noise levels 
noise_levels = [0.3, 0.5, 0.7];

% Standard median filter window sizes
window_sizes = [5, 9, 13]; 

for n = 1:length(noise_levels)
    noise_density = noise_levels(n);
    win_size = window_sizes(n);
    half_win = floor(win_size / 2);

    % Add salt & pepper noise
    noisy_img = double(imnoise(uint8(img), 'salt & pepper', noise_density));
    [rows, cols] = size(noisy_img);

    % Standard Median Filter
    filtered_std = zeros(size(noisy_img));
    for i = 1 + half_win : rows - half_win
        for j = 1 + half_win : cols - half_win
            subImg = noisy_img(i - half_win : i + half_win, j - half_win : j + half_win);
            subImg = sort(subImg(:));
            filtered_std(i,j) = subImg(round(length(subImg)/2));
        end
    end

    % Adaptive Median Filter
    Smax = 13; % Max window size 
    filtered_adapt = zeros(size(noisy_img));
    for i = 1:rows
        for j = 1:cols
            W = 3; % Initial window size
            while W <= Smax
                halfW = floor(W/2);
                r1 = max(i - halfW, 1);
                r2 = min(i + halfW, rows);
                c1 = max(j - halfW, 1);
                c2 = min(j + halfW, cols);
                subImg = noisy_img(r1:r2, c1:c2);
                z_min = min(subImg(:));
                z_max = max(subImg(:));
                z_med = median(subImg(:));
                z_xy = noisy_img(i,j);
               
                A1 = z_med - z_min;
                A2 = z_med - z_max;

                if A1 > 0 && A2 < 0
                    B1 = z_xy - z_min;
                    B2 = z_xy - z_max;
                    if B1 > 0 && B2 < 0
                        filtered_adapt(i,j) = z_xy;  % Keep original
                    else
                        filtered_adapt(i,j) = z_med; % Replace with median
                    end
                    break;
                else
                    W = W + 2; % Increase by 2 to keep window odd
                end
            end

            if W > Smax
                filtered_adapt(i,j) = z_med;
            end
        end
    end

    % MSE Calculation 
    mse_std = immse(img, filtered_std);
    mse_adapt = immse(img, filtered_adapt);

    % Display Results
    fprintf('Noise: %.0f%% \t Standard MSE: %.5f \t Adaptive MSE: %.5f\n', noise_density*100, mse_std, mse_adapt);

    % Output Images 
    figure('Name', sprintf('Noise %.0f%%', noise_density*100), 'NumberTitle', 'off');

    subplot(1,3,1);
    imshow(uint8(noisy_img));
    title(sprintf('Noisy (%.0f%%)', noise_density*100));
    imwrite(uint8(noisy_img), sprintf('noisy_%.0f.png', noise_density*100));

    subplot(1,3,2);
    imshow(uint8(filtered_std));
    title('Standard Median');
    imwrite(uint8(filtered_std), sprintf('standard_median_%.0f.png', noise_density*100));

    subplot(1,3,3);
    imshow(uint8(filtered_adapt));
    title('Adaptive Median');
    imwrite(uint8(filtered_adapt), sprintf('adaptive_median_%.0f.png', noise_density*100));
end

% Analysis 
% For low noise (30%), a 5x5 standard median filter is sufficient to remove most noise.
% However, at high noise levels (50% or 70%), it struggles to restore pixels when most values
% in the window are corrupted and severely degrades quality.
% The adaptive median filter performs consistently better at high noise levels due to its ability
% to expand its window dynamically and avoid relying on corrupted medians.
% But the adaptive median filter has higher computational cost.