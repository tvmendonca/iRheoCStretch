%---------------------
% Biophysics of human chromosomes
% Tania Mendonca <tania.mendonca@nottingham.ac.uk>
% Extract high frequency force-time data (Batch process)
% from .h5 files exported from LUMICKS Blulake
%---------------------


clear all
close all

% load data
[Path] = uigetdir;
Files = dir(Path);
l = [Files.isdir]; g = l == 0; H = Files(g);
NData = unique({H.name});
foldername = strsplit(Path,"\");

% define output directories
Out = strcat(Path,'\Output Files');

if ~exist(Out, 'dir')
    mkdir(Out)
end

%%
for j = 1:length(NData)

    j

    % import data
    info = h5info(NData{j});

    File = NData{j};
    Filename = strsplit(File,".");
    HF_Path = strcat(Out,'\',Filename{1},'_HF.txt');

    %% Get Metadata
    temp = h5read(File,'/Temperature/Objective');   % objective temperature
    ObjTemp = temp.Value(1);

    indexes = reshape(contains({info.Groups.Name}, '/Calibration'),...
        size(info.Groups));
        TrapStiff1 = h5readatt(File,info.Groups(indexes).Groups(1).Groups(1).Name,...
             'kappa (pN/nm)');                     % trap 1 stiffness
    TrapStiff2 = h5readatt(File,info.Groups(indexes).Groups(1).Groups(4).Name,...
        'kappa (pN/nm)');                           % trap 2 stiffness

    try
        bd = h5read(File,'/Bead diameter/Template 1'); % bead diameter
        beadDiameter = bd.Value(1);
    catch
        beadDiameter = 3;
    end

    % create metadata file
    metadata(j,1:4) = table({Filename{1}}, TrapStiff2,...
        beadDiameter, ObjTemp,...
        'VariableNames',{'FileName',...
        'Trap Stiffness Bead 2 [pN]','Bead Diameter [um]',...
        'Objective Temperature [oC]'});

    %% Extract high frequency force values

    hf1 = h5read(File,'/Force HF/Force 1x');      % high resolution force data (moving bead)
    hf2 = h5read(File,'/Force HF/Force 2x');      % high resolution force data (stationary bead)

    lf1 = h5read(File,'/Force LF/Force 1x');      % low res force (moving bead)
    lf = h5read(File,'/Force LF/Force 2x');       % low res force (stationary bead)
    f = lf.Value; f1 = lf1.Value;
    [~,loclf] = max(f);
    ld = h5read(File,'/Distance/Distance 1');     % displacement between beads
    d = ld.Value; lt = ld.Timestamp-ld.Timestamp(1);

    % sampling time
    t1 = h5readatt(File,'/Force HF/Force 2x','Start time (ns)');
    t2 = h5readatt(File,'/Force HF/Force 2x','Stop time (ns)');
    s = h5readatt(File,'/Force HF/Force 2x','Sample rate (Hz)');
    t = 0:(1e9/s):t2-(t1+(1e9/s));

    % cap dwell time to 2 minutes
    if max(t*1e-9)>120
        tend = find(t*1e-9 == 120,1);
    else
        tend = length(t);
    end

    %% Chromosome extension at high frequencies

    % convert data from force to displacement (F=dx*k)
    x1 = hf1/TrapStiff1; x2 = hf2/TrapStiff2;

    lx1 = f1/TrapStiff1; lx2 = f/TrapStiff2;
    bp1 = h5read(File,'/Bead position/Bead 1 X');
    bp2 = h5read(File,'/Bead position/Bead 2 X');
    tp1 = bp1.Value + (-lx1*1e-3); tp2 = bp2.Value + (lx2*1e-3);

    ftp1 = fit(lt,tp1,'linearinterp'); ftp2 = fit(lt,tp2,'linearinterp');
    warning('off','last');
    htp1 = ftp1(double(t)); htp2 = ftp2(double(t)); warning('off','last');
    hd = (htp2-(x2*1e-3))-(htp1-(-x1*1e-3))-3;

    try
        [~,loc] = max(hf2);
        a = max(hd(hf2(1:loc)<0));
        ext = (hd-a)*1e3;            % extension in nm
    catch ME
        [~,loc] = max(f);
        a = max(hd(f(1:loc)<0));
        ext = (hd-a)*1e3;            % extension in nm
    end

    metadata.Chromosome_Length(j) = a;

    %     figure;
    %     plot(t,hd,lt,d)

    %% Concatenate data and write file
    tupend = double(t(tend))+ [1:1:10];
    upendedt = [t(1:tend) tupend];
    avgf = [(abs(hf1(1:tend))+abs(hf2(1:tend)))/2; zeros(10,1)];
    %     beadf1 = [hf1(1:tend); zeros(10,1)];
    %     beadf2 = [hf2(1:tend); zeros(10,1)];
    extupend = [ext(1:tend); zeros(10,1)];

    %     figure
    %     plot(upendedt, avgf);

    HFdata = [double(upendedt(:))*1e-9, avgf(:), extupend(:)];  % concatenate data

    writematrix(HFdata,HF_Path);
end

writetable(metadata,strcat(Out,'\',foldername{end},'metadata_HF.txt'));
