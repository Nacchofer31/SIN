#!/usr/bin/octave -qf

if (nargin!=3)
  printf("Usage: experiment <data> <alphas> <bes>\n");
  exit(1);
end;

arg_list = argv();
data = arg_list{1};
as = str2num(arg_list{2});
bs = str2num(arg_list{3});

#Se cargan las matriz de cada archivo.
load(data); # Load data

[ N, L ] = size(data);

D = L-1;

#Convierte el número de clases en etiquetas
ll = unique(data(:,L));
C = numel(ll);

rand("seed",23);
data = data(randperm(N),:);

NTr = round(.7*N);

M = N - NTr;

te = data(NTr+1:N,:);

printf("       a        b   E   k Ete  Ete (%%)    Ite (%%)\n");
printf("-------- -------- --- --- --- -------- ----------\n");

#Entra en el perceptron y lo clasifica
for a=as

  for b=bs
    
    [w, E, k] = perceptron(data(1:NTr,:), b, a);
    
    #Se almacena en la clase que pertenece
    rl = zeros(M, 1);

    for n=1:M
      #Clase a la que pertenece
      rl(n) = ll(linmach(w,[1 te(n, 1:D)]')); #'
    end
    
    #Compara las etiquetas
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
printf("a -> Alpha\n");
printf("b -> Beta\n");
printf("E -> Nº Errores en la última iteración.\n");
printf("k -> Iteraciones necesarias\n");
printf("Ete -> Error estimado\n");
printf("Ete (%%) -> Porcentaje de error\n");
printf("Ite (%%) -> Intervalo de confianza\n");