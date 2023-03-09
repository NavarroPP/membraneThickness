%% cristae thickness
%%% Paula Navarro, Harvard Medical School, 2022,
%%% ppnavarro@molbio.mgh.harvard.edu
% notes run in Dynamo enviroment https://wiki.dynamo.biozentrum.unibas.ch/w/index.php/Main_Page

%% check aligned particles

% get table from project
ddb mySTAprojectName:rt:ite=last -ws myTable % or wttest1_90_continue4_3; wttest1_90_continue4_4azi
% display aligned particles
figure;dslices('myDataFolderPath','t',myTable,'projy','*','align',1,'labels','on');

%% measure cristae width

% get info
ddb mySTAprojectName:rt -ws myTable % prints in screen the last available refined table lamellar_ali4
ddb mySTAprojectName:data -d % prints on screen the data folder linked to this project;
myData = 'myDataFolderPath';
% get input
r = dpkdata.Reader();
r.setSource('table', 'quickbuffer.tbl','data',myData);

% get particles
p = r.getParticle(11,'align',1); 
pa = r.getParticle('*','align',1);
pac  = mbg.cellCompact(pa);

%check particle
myAverage = dynamo_sumarray(pac);
dview(myAverage);

% create filters
clear indexList
t = dpkfw.mdm.templateSeries('size',[56,56,56],'thickness',4,'distance',[1:50]); % adjust considering your box size
figure;dslices(t,'projy','*','dim',[1,56]); % adjust considering your box size

%apply filter
o = dpkfw.mdm.bestFilteringDistance(p,'templates',t);
for i=1:length(pac)
    o = dpkfw.mdm.bestFilteringDistance(pac{i},'templates',t);
    [maxcc,myIndex] = max(o.ccmax);
    indexList(i) = myIndex(1); % in case there are two maxima
    disp(i);
end
figure;hist(indexList,[1:56]); % adjust considering your box size
xlabel('Best filter');
ylabel('# Particles');

xaxis = [1:56]; % adjust considering your box size
xaxisfinal = xaxis*2.206; % adjust considering your pixel size
indexListnm = indexList*2.206; % adjust considering your pixel size
figure;hist(indexListnm,xaxisfinal);
xlabel('Best filter');
ylabel('# Particles');