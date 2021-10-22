clear all
op = 11;

fileID = fopen('output.txt');
for i = 1:(1000-1)
    data = fscanf(fileID, '%s', [1, 1]);
    in_a(i) = hex2num(data);
    %in_a = hex2num(data);
    data = fscanf(fileID, '%s', [1, 1]);
    in_b(i) = hex2num(data);
    %in_b = hex2num(data);
    data = fscanf(fileID, '%s', [1, 1]);
    in_c(i) = hex2num(data);
    %in_c = hex2num(data);
    data = fscanf(fileID, '%s', [1, 1]);
    out_sim(i) = hex2num(data);
    %out_sim = hex2num(data);
    if(op == 11)
        out_cal(i) = in_a(i) * in_b(i) + in_c(i);
        %out_cal = in_a * in_b + in_c;
    end
    if(op == 00)
        out_cal(i) = in_a(i) * in_b(i);
        %out_cal = in_a * in_b;
    end
    if(op == 10)
        out_cal(i) = in_a(i) + in_c(i);
        %out_cal = in_a + in_c;
    end
    if(op == 01)
        out_cal(i) = in_a(i) - in_c(i);
        %out_cal = in_a - in_c;
    end
    
    diff(i) = out_cal(i) - out_sim(i);
    %diff = out_cal - out_sim;
end
out = [in_a; in_b; in_c; out_sim; out_cal; diff];
fclose(fileID);
% Uncomment if you want to save output
%filename = 'Data.xlsx';
%writematrix(out, filename);