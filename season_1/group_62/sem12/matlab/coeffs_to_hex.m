scale = 2^15-1;
int_coeffs = int16(round(Num * scale));

hex_str = string(dec2hex(int_coeffs));

filename = 'coeffs_hex.txt';
fid = fopen(filename, 'w');
if fid == -1
    error('Could not open file %s for writing.', filename);
end

for k = 1:length(hex_str)
    fprintf(fid, '%s\n', hex_str(k));
end
fclose(fid);

disp(['Coefficients saved to ', filename, ' in hex format.']);