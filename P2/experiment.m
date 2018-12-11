#!/usr/bin/octave -qf

if (nargin!=3)
  printf("Usage: experiment <data> <alphas> <bes>\n");
  exit(1);
end;

arg_list = argv(); # Get arguments 
data = arg_list{1}; # Get de firts argument (data)
as = str2num(arg_list{2}); # Get de second argument (a)
bs = str2num(arg_list{3}); # Get de third argument (b)

load(data); # Load data

[ N, L ] = size(data); # Load size of matrix data

D = L-1; # Load the number of characteristics


ll = unique(data(:,L));
C = numel(ll);

rand("seed",23);

data = data(randperm(N),:);

NTr = round(.7*N);

M = N - NTr;

te = data(NTr+1:N,:);

printf("       a        b   E   k Ete  Ete (%%)    Ite (%%)\n");
printf("-------- -------- --- --- --- -------- ----------\n");

for a=as # a=[.1 1 10 100 1000 10000 100000]

  for b=bs # b=[.1 1 10 100 1000 10000 100000]
    
    [w, E, k] = perceptron(data(1:NTr,:), b, a);

    rl = zeros(M, 1);

    for n=1:M

      rl(n) = ll(linmach(w,[1 te(n, 1:D)]')); #'
    end
    
    [nerr m] = confus(te(:, L), rl);

    perr = nerr/M;

    s = sqrt(perr* (1-perr)/M);
    r = 1.96*s;

    pe = perr*100;
    ies = (perr-r)*100;
    idt = (perr+r)*100;

    if(ies < 0) ies = 0; end

    printf("%8.1f %8.1f %3d %3d %3d      %1.1f [%1.1f, %1.1f]\n", a, b, E, k, nerr, pe, ies, idt);

  end
  
  printf("\n");
end

printf("\n");
printf("a: Alpha utilizada\n");
printf("b: Beta utilizada\n");
printf("E: Numero de errores producidos en última iteración.\n");
printf("k: Iteraciones necesarias\n");
printf("Ete: Error estimado\n");
printf("Ete (%%): Porcentaje de error\n");
printf("Ite (%%): Intervalo de confianza\n");