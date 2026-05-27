function wt = init_wt(windCase, verbose)
%INIT_WT Load wind-turbine data and parameters required by the models.
%
%   init_wt() loads the default _wind6.mat dataset and assigns the
%   variables used by the Simulink models to the base workspace.
%
%   init_wt("wind3"), init_wt("wind6"), or init_wt("wind10") select a
%   different wind dataset.

if nargin < 1 || strlength(string(windCase)) == 0
    windCase = "wind6";
end
if nargin < 2
    verbose = true;
end

scriptDir = fileparts(mfilename("fullpath"));
projectRoot = fileparts(scriptDir);
dataDir = fullfile(projectRoot, "data");

inertia = load(fullfile(dataDir, "J_turbina.mat"), "J_rot_blade");
steady = load(fullfile(dataDir, "FAST_Steady_Simulations.mat"));

windCase = erase(lower(string(windCase)), "_");
switch windCase
    case "wind3"
        windFile = "_wind3.mat";
    case "wind6"
        windFile = "_wind6.mat";
    case "wind10"
        windFile = "_wind10.mat";
    otherwise
        error("init_wt:InvalidWindCase", ...
            "Unsupported wind case '%s'. Use wind3, wind6, or wind10.", windCase);
end
wind = load(fullfile(dataDir, windFile));

valid = steady.AeroPower > 0 & steady.Ct < 1;
if ~any(valid)
    error("init_wt:NoValidSteadyPoints", ...
        "FAST_Steady_Simulations.mat has no valid operating points.");
end

GBRatio = 97;
GBEff = 1.00;
GenEff = 0.944;
Jgen = 534.116;
Jrot = inertia.J_rot_blade;
Jeq = Jrot + Jgen * GBRatio^2;
R = 63;
rho = 1.225;
wPA = 8.6;
zetaPA = 0.8;
Bmax = 90;
Kaw = 0.5;

Cp_max = max(steady.Cp(valid));
V_ott = 11.4;
Omega_ott_low = 12.1 * 2 * pi / 60;
Lambd_ott = Omega_ott_low * R / V_ott;
Beta_ott = 0;

P_D = rho * V_ott^3 * pi * R^2 / 2;
P_rated = Cp_max * P_D;
C_rated = P_rated / Omega_ott_low;
Omega_ott_high = GBRatio * Omega_ott_low;
GenRated = P_rated * GenEff;
w_1 = Omega_ott_high * 0.99;
Kreg2 = (rho * pi * R^5 * Cp_max) / (2 * Lambd_ott^3 * GBRatio^3);
B = 0;

WindData = wind.WInd;
Omega_0 = wind.Omega(1);
dt = mean(diff(wind.t));

% Legacy aliases keep older saved models and notebooks working.
P_reted = P_rated;
C_reted = C_rated;
Omega_ott_higt = Omega_ott_high;

wt = struct( ...
    "scriptDir", scriptDir, ...
    "projectRoot", projectRoot, ...
    "dataDir", dataDir, ...
    "windFile", windFile, ...
    "steady", steady, ...
    "wind", wind, ...
    "validSteadyMask", valid);

params = struct( ...
    "GBRatio", GBRatio, ...
    "GBEff", GBEff, ...
    "GenEff", GenEff, ...
    "Jgen", Jgen, ...
    "Jrot", Jrot, ...
    "Jeq", Jeq, ...
    "R", R, ...
    "rho", rho, ...
    "wPA", wPA, ...
    "zetaPA", zetaPA, ...
    "Bmax", Bmax, ...
    "Kaw", Kaw, ...
    "Cp_max", Cp_max, ...
    "V_ott", V_ott, ...
    "Omega_ott_low", Omega_ott_low, ...
    "Lambd_ott", Lambd_ott, ...
    "Beta_ott", Beta_ott, ...
    "P_D", P_D, ...
    "P_reted", P_reted, ...
    "C_reted", C_reted, ...
    "Omega_ott_higt", Omega_ott_higt, ...
    "GenRated", GenRated, ...
    "w_1", w_1, ...
    "Kreg2", Kreg2, ...
    "B", B, ...
    "WindData", WindData, ...
    "Omega_0", Omega_0, ...
    "dt", dt, ...
    "P_rated", P_rated, ...
    "C_rated", C_rated, ...
    "Omega_ott_high", Omega_ott_high);

paramNames = fieldnames(params);
for idx = 1:numel(paramNames)
    name = paramNames{idx};
    wt.(name) = params.(name);
    assignin("base", name, params.(name));
end

windFields = fieldnames(wind);
for idx = 1:numel(windFields)
    wt.(windFields{idx}) = wind.(windFields{idx});
    assignin("base", windFields{idx}, wind.(windFields{idx}));
end

if verbose
    fprintf("WT init loaded %s. Use check_models to verify model compile.\\n", windFile);
end
end
