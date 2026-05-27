function windCase = get_wind_case()
%GET_WIND_CASE Return selected wind case for model callbacks.

if evalin("base", "exist('WT_WIND_CASE', 'var')")
    windCase = evalin("base", "WT_WIND_CASE");
else
    windCase = "wind6";
end
end
