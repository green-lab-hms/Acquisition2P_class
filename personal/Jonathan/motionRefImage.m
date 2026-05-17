function img = motionRefImage(obj, iChannel)

nSlices = numel(obj.derivedData(1).meanRef.slice);

img.slice(nSlices) = struct();
for iSlice = 1:nSlices
	img.slice(iSlice).img = meanRef(obj, obj.motionRefMovNum, iSlice, iChannel);
end
	
