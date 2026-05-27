function out = run_simulation(modelName, windCase, stopTime)
%RUN_SIMULATION Run a wind-turbine Simulink model.
%
%   out = run_simulation() runs WindT_Control with the default wind6 case.
%   out = run_simulation("Region3", "wind10", 60) runs Region3 for 60 s.

if nargin < 1 || strlength(string(modelName)) == 0
    modelName = "WindT_Control";
end
if nargin < 2 || strlength(string(windCase)) == 0
    windCase = "wind6";
end
if nargin < 3 || strlength(string(stopTime)) == 0
    stopTime = "t(end)";
end

modelName = erase(string(modelName), ".slx");
windCase = string(windCase);
stopTime = string(stopTime);

scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);
modelFile = fullfile(projectRoot, "models", modelName + ".slx");

if ~isfile(modelFile)
    error("run_simulation:MissingModel", "Model not found: %s", modelFile);
end

addpath(scriptDir);
assignin("base", "WT_WIND_CASE", windCase);
init_wt(windCase, false);

load_system(modelFile);
set_param(modelName, "StopTime", char(stopTime));

fprintf("Running %s with %s until %s...\\n", modelName, windCase, stopTime);
out = sim(modelName);
fprintf("Done. Output variable: Simulazioni_sim.\\n");
end
