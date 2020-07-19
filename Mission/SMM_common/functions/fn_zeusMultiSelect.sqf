#include "script_component.hpp"
#include "\A3\ui_f_curator\ui\defineResinclDesign.inc"

disableSerialization;
params [["_enterCode",{},[{}]],["_customArguments",[]]];

private _display = finddisplay IDD_RSCDISPLAYCURATOR;
private _ctrlMessage = _display displayctrl IDC_RSCDISPLAYCURATOR_FEEDBACKMESSAGE;

playSound "FD_Finish_F";
_ctrlMessage ctrlSetText "SELECT ITEMS, THEN PRESS ENTER";
_ctrlMessage ctrlSetFade 1;
_ctrlMessage ctrlCommit 0;
_ctrlMessage ctrlSetFade 0;
_ctrlMessage ctrlCommit 0.1;

[_display,"KeyDown",{
	params ["_display","_key"];
	_thisArgs params ["_ctrlMessage","_enterCode","_customArguments"];

	//Escape
	if (_key == 0x01) exitWith {
		_display displayRemoveEventHandler [_thisType,_thisID];
		[objNull,"Selection cancelled"] call BIS_fnc_showCuratorFeedbackMessage;
		true
	};

	//Enter
	if (_key == 0x1C) exitWith {
		_display displayRemoveEventHandler [_thisType,_thisID];
		[objNull,"Selection submitted"] call BIS_fnc_showCuratorFeedbackMessage;
		[_enterCode,[curatorSelected,_customArguments]] call CBA_fnc_execNextFrame; // curatorSelected: [objects,groups,waypoints,markers]
		true
	};

	false
},[_ctrlMessage,_enterCode,_customArguments]] call CBA_fnc_addBISEventHandler;
