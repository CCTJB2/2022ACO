function finishProject()
%finishProject Finish file for 2021-2022 ACO assignment.
%   finishProject can be run to restore the default MATLAB path
%   and the end of a session. It also restores the directory to
%   the project root.


%%% Close any open Simulink models
%

openModels = Simulink.allBlockDiagrams();
if ~isempty(openModels)
    allModels = get_param(openModels, 'Name');
    allModels = cellfun(@(m)bdroot(m), allModels, 'UniformOutput', false);
    allModels = sort(unique(allModels));
    nModels = numel(allModels);
    for iModel = 1:nModels
        thisModel = allModels{iModel};
        isDirty = strcmpi(get_param(thisModel, 'Dirty'), 'on');
        if isDirty
            try
                save_system(thisModel)
            catch ME
                warning(ME.identifier, '%s', ME.message)
            end
        end
        close_system(thisModel, 0);        
    end
    bdclose('all');
end


%%% Close any open figures
%

close('all');


%%% Return to the project root folder
%

projectRootFolder = fileparts(which('finishProject'));
cd(projectRootFolder);


%%% Restore the original path
%

originalPath = pathdef();
path(originalPath);


%%% Clear the workspace
%

evalin('caller', 'clear');


%%% Clear the command window
%

clc();


end