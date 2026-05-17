function motionCorrect_Acq2P(movPath, refFilter, externalMotionRefFile)

if ~exist('refFilter', 'var')
	refFilter = 'Green';
end

if ~exist('externalMotionRefFile', 'var')
	externalMotionRefFile = '';
end


addpath(genpath('/home/hek089/code/Acquisition2P_class'));
acq = Acquisition2P([], @(acq) JG2Pinit(acq, movPath, refFilter, externalMotionRefFile));


if isempty(externalMotionRefFile)
	disp(sprintf('Correcting motion for %s on %s channel.', movPath, refFilter))
else
	disp(sprintf('Correcting motion for %s on %s channel using %s as reference.', movPath, refFilter, externalMotionRefFile))
end
acq.motionCorrect();

% Collect quality controls
nSlice = []; %defaults to 1
nChannel = []; %defaults to 1
[mov, mF] = viewAcq(acq, nSlice, nChannel);

% Write sped-up video
v = VideoWriter(fullfile(movPath, 'Corrected', 'motionCorrectionCheck.avi'));
open(v);
movSize = size(mov);
writeVideo(v, reshape(mov, [movSize(1:2) 1 movSize(3)]));
close(v);

% Save intensity plot
fig1 = plot(mF);
saveas(fig1, fullfile(movPath, 'Corrected', 'meanF.png'));

% Write mean ref images as composite Tif files
write_meanRefs(acq, fullfile(movPath, 'Corrected'));
