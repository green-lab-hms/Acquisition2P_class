function write_meanRefs(obj, path)

if isa(obj, 'char')
	addpath(genpath('/home/jg319/code/HarveyLab/Acquisition2P_class'));
	load(obj);
	obj = session;
end

nSlices = numel(obj.derivedData(1).meanRef.slice);
for iSlice = 1:nSlices
	compositeImage = meanRef_composite(obj, iSlice);
	filters = '';
	for ifilter = 1:length(obj.filters)
		filters = [filters obj.filters(ifilter).id];
	end
	[pathstr,name,ext] = fileparts(char(obj.Movies(1)));
	tif_filename = fullfile(path, sprintf('%s_slice%02d_mean.tiff', name(1:end-6), iSlice));
	% tif_filename = fullfile(path, sprintf('compositeMeanRef_%s_slice%02d.tiff', filters, iSlice));
	imwrite(uint16(compositeImage), tif_filename, 'tiff');
end
