function JG2Pinit(obj, movPath, refFilter, externalRefFile)

%Example of an Acq2P Initialization Function. Allows user selection of
%movies to form acquisition, sorts alphabetically, assigns an acquisition
%name and default directory, and assigns the object to a workspace variable
%named after the acquisition name

%Initialize user selection of multiple tif files
% [movNames, movPath] = uigetfile('*.tif','MultiSelect','on');
fileList = dir(fullfile(movPath, '*.tif'));
movNames = {fileList.name};

%Set default directory to folder location,
obj.defaultDir = movPath;

%sort movie order alphabetically for consistent results
movNames = sort(movNames);

%Attempt to automatically name acquisition from movie filename, raise
%warning and create generic name otherwise
obj.acqName = 'session';

%Attempt to add each selected movie to acquisition in order
for nMov = 1:length(movNames)
    obj.addMovie(fullfile(movPath,movNames{nMov}));
end

movNames = {fileList.name};
% Determine functional channel based on filename
regex_1filter = "^[BGR]\d$";
regex_2filters = "^[BGR]\d[BGR]\d$";
tags = split(movNames{1}, '_');
for itag = 1:length(tags)
	if regexp(tags{itag}, regex_1filter)
		filters = tags{itag};
		obj.filters(1).id = filters;
		obj.filters(1).color = filters(1);
		obj.motionRefChannel = 1;
		disp(obj.filters(1).id);
		disp(obj.filters(1).color);
		disp('1 filter');
		break
	elseif regexp(tags{itag}, regex_2filters)
		disp('2 filters');
		filters = tags{itag};
		obj.filters(1).id = filters(1:2);
		obj.filters(1).color = filters(1);
		obj.filters(2).id = filters(3:4);
		obj.filters(2).color = filters(3);
		if filters(1) == refFilter(1)
			obj.motionRefChannel = 1;
		elseif filters(3) == refFilter(1)
			obj.motionRefChannel = 2;
		end
		break
	end
end


%Automatically fill in fields for motion correction
obj.motionRefMovNum = ceil(length(movNames)/2);
obj.binFactor = 1;
obj.motionCorrectionFunction = @lucasKanade_plus_nonrigid; % lucasKanade_plus_nonrigid_memMap

% Assign external motion reference image if externalMotionRefFile is supplied
if exist('externalRefFile', 'var') && ~isempty(externalRefFile)
	obj.externalRefFile = externalRefFile;
	data = load(externalRefFile);
	thisRefColor = obj.filters(obj.motionRefChannel).color
	externalRefColor = data.session.filters(data.session.motionRefChannel).color
	if strcmp(thisRefColor, externalRefColor)
		obj.externalMotionRefImage = data.session.motionRefImage;
	else
		nExtChannels = length(data.session.filters);
		for iExtChannel = 1:nExtChannels
			if strcmp(thisRefColor, data.session.filters(iExtChannel).color)
				iExtChannel
				obj.externalMotionRefImage = motionRefImage(data.session, iExtChannel);
			end
		end
	end
end

%Assign acquisition object to acquisition name variable in workspace
assignin('base',obj.acqName,obj);

%Notify user of success
fprintf('Successfully added %03.0f movies to acquisition: %s\n',length(movNames),obj.acqName),
