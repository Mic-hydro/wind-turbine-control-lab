function results = check_models()
%CHECK_MODELS Compile-check all Simulink models without running simulations.

scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);
modelDir = fullfile(projectRoot, "models");
oldFolder = pwd;
cleanup = onCleanup(@() cd(oldFolder));
cd(projectRoot);
addpath(scriptDir);

assignin("base", "WT_WIND_CASE", "wind6");
init_wt("wind6", false);

models = ["naif", "Region3", "WindT_Control"];
results = table(models(:), false(numel(models), 1), strings(numel(models), 1), ...
    'VariableNames', {'Model', 'UpdateOk', 'Message'});

for idx = 1:numel(models)
    model = models(idx);
    modelFile = fullfile(modelDir, model + ".slx");
    try
        load_system(modelFile);
        set_param(model, "SimulationCommand", "update");
        results.UpdateOk(idx) = true;
        results.Message(idx) = "OK";
    catch err
        results.Message(idx) = string(err.message);
    end
end

disp(results);

if ~all(results.UpdateOk)
    error("check_models:UpdateFailed", "One or more models failed to update.");
end
end
