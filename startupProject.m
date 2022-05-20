function startupProject()
%startupProject Startup file for 2021-2022 ACO assignment.
%   startupProject can be run to set up the MATLAB path for the
%   2021-2022 ACO assignment. It adds some relevant folders to
%   the MATLAB search path and changes to the main directory.

%   Copyright 2022 Cranfield University. All rights reserved.


%%% Restore defaults
%

finishProject();


%%% Identify the folder containing this file
%

myFolder = fileparts(which('startupProject'));


%%% Add relevant folders to the MATLAB path
%

addpath(myFolder, '-end');
addpath(fullfile(myFolder, 'data'), '-end')
addpath(fullfile(myFolder, 'models'), '-end')


%%% There is another folder we use for development only
%

devDir = fullfile(myFolder, 'dev');
if logical(exist(devDir, 'dir'))
    addpath(devDir, '-end')
end


%%% Change to the project folder and list contents
%

cd(myFolder);
what()


end % startupProject()
