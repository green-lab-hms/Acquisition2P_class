function compositeImage = meanRef_composite(obj, iSlice)

nChannels = numel(obj.derivedData(1).meanRef.slice(1).channel);
nMovies = length(obj.derivedData);
[h, w] = size(obj.derivedData(1).meanRef.slice(1).channel(1).img);

compositeImage = zeros(h, w, 3);
for iChannel = 1:nChannels
	if obj.filters(iChannel).color == 'B'
		tifChannel = 1;
	elseif obj.filters(iChannel).color == 'G'
		tifChannel = 2;
	elseif obj.filters(iChannel).color == 'R'
		tifChannel = 3;
	else
		disp('Filter not identified.')
	end
	compositeImage(:, :, tifChannel) = meanRef(obj, 1:nMovies, iSlice, iChannel);
end
	
