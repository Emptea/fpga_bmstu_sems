function data2hexfile(arr, scale, filename)

int_arr = int16(round(arr * scale));

hex_str = string(dec2hex(int_arr));

fid = fopen(filename, 'w');
if fid == -1
    error('Could not open file %s for writing.', filename);
end

for k = 1:length(hex_str)
    fprintf(fid, '%s\n', hex_str(k));
end
fclose(fid);

disp(['Coefficients saved to ', filename, ' in hex format.']);