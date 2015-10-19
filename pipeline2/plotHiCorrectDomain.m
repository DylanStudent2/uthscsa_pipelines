function output=plotHiCorrectDomain(domainFile)
fid=fopen(domainFile);
tmp=textscan(fid,'%s%d%d%d%d%s%d','headerLines',1);
fclose(fid);
domainType=tmp{1,6};
domainX=tmp{1,2};
domainY=tmp{1,4};

bins=size(domainType,1);
domainMat=zeros(bins,bins);domainVec=zeros(bins,1);
types={'boundary';'gap';'domain'};

for i = 1:bins
    [a,b,c]= intersect(types,domainType{i},'stable');
    domainMat(domainX(i):domainY(i),domainX(i):domainY(i))=b-2;
    domainVec(domainX(i):domainY(i),1)=b-2;
    domainInx(i,:)=[domainX(i),domainY(i),b-2];
    
end

output.inx=domainInx;
output.vec=domainVec;
output.mat=domainMat;