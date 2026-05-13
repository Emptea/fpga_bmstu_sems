function sqnr_db = check_data (flp, rtl)
nfft = numel(rtl);
rtl = double(rtl);
if(~isrow(flp))
    flp = flp.';
end

if(~isrow(rtl))
    rtl = rtl.';
end

flp_mean_pwr = mean(abs(flp).^2);
rtl_mean_pwr = mean(abs(rtl).^2);
rtl_descaled = rtl * sqrt(flp_mean_pwr / rtl_mean_pwr);
sqnr_db = 10*log10(flp_mean_pwr / mean (abs(flp - rtl_descaled).^2));

figure();
ax1 = subplot(3,1,1);
plot(1 : nfft, real(rtl), 'r', ...
     1: nfft, imag(rtl), 'b')
legend('RTL Re', 'RTL Im')
ax2 = subplot(3,1,2);
plot(1 : nfft, real(rtl_descaled), 'r', ...
     1: nfft, real(flp), 'b--')
legend('RTL Re', 'FLP Re')
ax3 = subplot(3,1,3);
plot(1 : nfft, imag(rtl_descaled), 'r', ...
     1: nfft, imag(flp), 'b--')
legend('RTL Im', 'FLP Im')
linkaxes([ax1, ax2, ax3], 'x')