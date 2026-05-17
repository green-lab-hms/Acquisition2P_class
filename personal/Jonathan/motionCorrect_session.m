function motionCorrect_session(movPath, refFilter, useCommonMotionRefFile)

if ~exist('refFilter', 'var')
	refFilter = 'Green';
end

if ~exist('useCommonMotionRefFile', 'var')
	useCommonMotionRefFile = true;
end

motionCorrect_Acq2P(movPath, refFilter);

filter_dirs = dir(fullfile(movPath, 'filter*'));
if length(filter_dirs) > 0
	if useCommonMotionRefFile
		motionRefFile = fullfile(movPath, 'session.mat');
	else
		motionRefFile = '';
	end

	for i = 1:length(filter_dirs)
		refPath = fullfile(movPath, filter_dirs(i).name);
		motionCorrect_Acq2P(refPath, refFilter, motionRefFile);
	end
end
