range = [-10000, 10000];
in = range(1) + (-range(1)+range(2))*rand([3*1000, 1], 'double');
hex = dec2hex(typecast(double(in), 'uint64'));

fileID = fopen('input.txt','w');
for i = 1:length(hex)
    fprintf(fileID, hex(i, :));
    fprintf(fileID,'\n');
end
fclose(fileID);