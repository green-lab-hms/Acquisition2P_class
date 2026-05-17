function eventTriggeredMovieFileIO(frameIndex_mat, session_mat, output_mat)

addpath(genpath('/home/jg319/code/Acquisition2P_class'));

load(frameIndex_mat)
load(session_mat)

[avgMov, dFmov] = eventTriggeredMovie(session, frameIndex);
save(output_mat, 'avgMov', 'dFmov', 't')