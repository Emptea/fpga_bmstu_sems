function [arr, int_arr] = hexfile2data(filename, scale)

fid = fopen(filename, 'r');
if fid == -1
    error('Could not open file %s for reading.', filename);
end

hex_lines = textscan(fid, '%s', 'Delimiter', '\n');
hex_lines = hex_lines{1};
fclose(fid);

int_arr = zeros(length(hex_lines), 1, 'int16');
for k = 1:length(hex_lines)
    u = hex2dec(hex_lines{k});
    if u >= 2^15
        s = int16(u - 2^16);
    else
        s = int16(u);
    end
    int_arr(k) = s;
end

arr = double(int_arr) / scale;

disp(['Recovered ', num2str(length(arr)), ' coefficients from ', filename]);