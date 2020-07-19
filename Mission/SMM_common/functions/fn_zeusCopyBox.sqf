#include "script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"
#include "\a3\ui_f\hpp\definedikcodes.inc"

params [["_text","",[""]]];

private _zeusDisplay = findDisplay IDD_RSCDISPLAYCURATOR;
private _parent = _zeusDisplay ctrlCreate ["RscControlsGroupNoScrollbars",-1];
_parent ctrlSetBackgroundColor [0,0,0,0];
_parent ctrlSetPosition [safeZoneXAbs,safeZoneY,safeZoneWAbs,safeZoneH];
_parent ctrlCommit 0;
ctrlSetFocus _parent;

private _container = _zeusDisplay ctrlCreate ["RscControlsGroupNoScrollbars",-1,_parent];
_container ctrlSetBackgroundColor [0,0,0,0];
_container ctrlSetPosition [0,0,safeZoneWAbs,safeZoneH];
_container ctrlCommit 0;

private _posX = (safezoneWAbs / 2) - 0.5;
private _posY = (safezoneH / 2) - 0.5;

private _editbox = _zeusDisplay ctrlCreate ["RscEditMulti",-1,_container];
_editbox ctrlSetBackgroundColor [0,0,0,0.8];
_editbox ctrlSetPosition [_posX,_posY,1,0.95];
_editbox ctrlCommit 0;
_editbox ctrlSetText _this;

private _closeButton = _zeusDisplay ctrlCreate ["RscButton",-1,_container];
_closeButton ctrlSetPosition [_posX,_posY + 0.955,1,0.045];
_closeButton ctrlCommit 0;
_closeButton ctrlSetText "CLOSE";

GVAR(zeusCopyBoxKeyDownEHID) = [_zeusDisplay,"KeyDown",{
	if (_this # 1 == DIK_ESCAPE) then {
		(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler [_thisType,_thisID];
		ctrlDelete _thisArgs;
		true
	} else {
		false
	};
},_parent] call CBA_fnc_addBISEventHandler;

[_closeButton,"ButtonClick",{
	(findDisplay IDD_RSCDISPLAYCURATOR) displayRemoveEventHandler ["KeyDown",GVAR(zeusCopyBoxKeyDownEHID)];
	ctrlDelete _thisArgs;
},_parent] call CBA_fnc_addBISEventHandler;
