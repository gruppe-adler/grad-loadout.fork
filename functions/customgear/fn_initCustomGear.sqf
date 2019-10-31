#define PREFIX grad
#define COMPONENT loadout
#include "\x\cba\addons\main\script_macros_mission.hpp"


private _enabled = [missionConfigFile >> "Loadouts", "customGear", 300] call BIS_fnc_returnConfigEntry;
if (_enabled isEqualType 0 && {_enabled <= 0}) exitWith {};

if (!(_enabled isEqualType 0) && !(_enabled isEqualType "")) exitWith {
    ERROR_1("[missionConfigFile >> Loadouts >> customGear] is of type %1 - only number or string allowed.", typeName _enabled);
};

if !(isClass (configfile >> "CfgPatches" >> "ace_interact_menu")) exitWith {
    ERROR("customGear needs ace_interact_menu addon.");
};

// user supplied number for custom gear timeout
GVAR(customGearCondition) = if (_enabled isEqualType 0) then {
    GVAR(customGearTimeout) = _enabled;
    {
        params ["_unit"];
        (CBA_missionTime - (_unit getVariable [QGVAR(lastLoadoutApplicationTime), 0])) < GVAR(customGearTimeout)
    }

// user supplied string for custom gear condition
} else {
    compile _enabled
};

private _action = [QGVAR(customGearAction), "Select custom gear", "", {[{_this call FUNC(openCustomGearDialog)}, _this] call CBA_fnc_execNextFrame}, GVAR(customGearCondition)] call ace_interact_menu_fnc_createAction;
["CAManBase", 1, ["ACE_SelfActions", "ACE_Equipment"], _action, true] call ace_interact_menu_fnc_addActionToClass;