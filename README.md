# Wind Turbine Control Models

MATLAB/Simulink lab for wind-turbine control exercises. The repository contains runnable Simulink models, FAST-derived input data, and helper scripts so another user can open, validate, and simulate the project without rebuilding the MATLAB base workspace by hand.

## Inspiration and Attribution

This exercise is inspired by the MathWorks example [Control Design for Wind Turbine](https://it.mathworks.com/help/control/ug/wind-turbine-control-design.html). In particular, it follows the same high-level ideas: reduced-order rotor dynamics, operating regions, torque control below rated wind speed, and blade-pitch control above rated wind speed.

This repository is an independent educational project. It is not an official MathWorks example and does not redistribute MathWorks source files.

## Folder Structure

- `models/` - Simulink models: `WindT_Control.slx`, `Region3.slx`, `naif.slx`.
- `data/` - FAST-derived input data and turbine inertia data.
- `scripts/` - setup and validation scripts: `init_wt.m`, `check_models.m`.
- `docs/` - final theory PDF and presentation for the exercise.

## Requirements

Tested with MATLAB R2026a and Simulink R2026a on Windows. Older MATLAB releases may open the files, but this has not been verified.

## Quick Start

From MATLAB:

```matlab
cd("C:\path\to\WT")
addpath("scripts")
init_wt
check_models
open_system(fullfile("models", "WindT_Control.slx"))
```

`init_wt` defaults to `wind6`. To select another wind dataset:

```matlab
init_wt("wind3")
init_wt("wind10")
```

The Simulink models also call `init_wt` through their model initialization callback, so opening or updating a model from this folder should load the required workspace variables automatically.

For compatibility with the original Live Script, `init_wt` still exports a few legacy misspelled aliases (`P_reted`, `C_reted`, `Omega_ott_higt`). New scripts should use `P_rated`, `C_rated`, and `Omega_ott_high`.

## Run Simulations

Run the main model with the default `wind6` wind data:

```matlab
cd("C:\path\to\WT")
addpath("scripts")
out = run_simulation("WindT_Control", "wind6");
```

Run a short smoke simulation:

```matlab
out = run_simulation("WindT_Control", "wind6", 30);
```

Available models are `WindT_Control`, `Region3`, and `naif`. Available wind cases are `wind3`, `wind6`, and `wind10`.

Simulation outputs are returned in `out`, with logged signals available under `out.Simulazioni_sim`.

## Complete the Exercise

1. Run `check_models` and verify that all three models return `OK`.
2. Run `WindT_Control` with `wind6` as the baseline case.
3. Plot or inspect `out.Simulazioni_sim` to check rotor speed, power, pitch, and torque trends.
4. Repeat one short run with `wind3` or `wind10` to see how the controller reacts to another wind input.
5. Compare `WindT_Control`, `Region3`, and `naif` only after using the same wind case and stop time.
6. Write down which model tracks the expected operating region best and why.

## Exercise Documents

Use only these files in `docs/`:

- `wind_turbine_theory.pdf`
- `Presentation.pptx`

## Git Notes

The `.slx`, `.mlx`, `.mat`, `.pdf`, and `.pptx` files are binary assets and should be committed only when intentionally updated. Generated MATLAB/Simulink artifacts such as `slprj/`, `*.slxc`, autosaves, logs, and temporary files are ignored through `.gitignore`.

## License

Released under the Apache License 2.0. The project is provided on an `AS IS` basis, without warranties or liability coverage beyond the limits stated in the license.
