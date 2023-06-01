function f = s_dbw(clust, X, varargin)
% Validation of the clustering solution
N = numel(clust);
cnames = unique(clust);
K = numel(cnames);
Nk = accumarray(clust,ones(N,1),[K,1]);
if sum(Nk<1) || K==1
    f = inf;
    return;
end

sXX = norm(var(X,1,1)); % 2- norm of input data X

% Intra-cluster variance
sMM  = zeros(K,1); % Varianza del cluster Ci
for i = 1:K
    if size(X(clust==i,:),1) >1
        sMM(i) = norm(var(X(clust==i,:),1,1));
    else
        sMM(i) = norm(((1/1)*sum((X(clust==i,:)-mean(X(clust==i,:))).^2))*ones(1,size(X,2)));
    end
end

Scat = (1/K)*sum(sMM/sXX);

% Average standard deviation of clusters
stdev = (1/K)*sqrt(sum(sMM));


aux = 0;
for clust_1=1:K
    for clust_2=1:K
        if clust_1~=clust_2
            c_clust_1 = mean(X(clust == clust_1,:));
            c_clust_2 = mean(X(clust==clust_2,:));
            Uij=(c_clust_1+c_clust_2)/2;
            
            aux1 = densidad([X(clust == clust_1,:); X(clust==clust_2,:)],Uij,stdev);

            aux2 = densidad(X(clust == clust_1,:),c_clust_1,stdev);

            aux3 = densidad(X(clust==clust_2,:),c_clust_1,stdev);
            
            aux = aux + aux1/max(aux2,aux3);
        end
    end
end
dens_bw = 1/(K*(K-1))*aux;
f = Scat + dens_bw;
end

%***********************************************************************
function D = densidad(Z,U,sd)
    D=0;
    dist = distancia(U,Z);
    valores = find(dist<=sd);
    [~,D] = size(valores);
end

function D = distancia(centro, puntos_cluster)
    D = sqrt(sum(puntos_cluster-centro).^2);
end