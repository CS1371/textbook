in = fopen('all_run.m','r');
out = fopen('all_run_really.m','w');
line = fgets(in);
while ischar(line)
    line(line == 0) = [];
    fprintf(out, '%s', line);
    line = fgets(in);
end