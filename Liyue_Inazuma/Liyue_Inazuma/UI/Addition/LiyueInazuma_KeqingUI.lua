include("GameCapabilities");

function OnUnitOperationStarted_OvertimeShift(playerID:number, unitID:number, operationID:number)
	if (operationID ~= UnitOperationTypes.BUILD_IMPROVEMENT and operationID ~= UnitOperationTypes.BUILD_IMPROVEMENT_ADJACENT and operationID ~= UnitOperationTypes.BUILD_ROUTE and operationID ~= UnitOperationTypes.CLEAR_CONTAMINATION and operationID ~= UnitOperationTypes.HARVEST_RESOURCE and operationID ~= 744183902 and operationID ~= UnitOperationTypes.REMOVE_FEATURE and operationID ~= UnitOperationTypes.REMOVE_IMPROVEMENT and operationID ~= UnitOperationTypes.REPAIR and operationID ~= UnitOperationTypes.REPAIR_ROUTE) then return; end -- So many operations that cost all movement!
	-- For unknown reason the actual operation ID (744183902) of planting forest cannot be obtained by UnitOperationTypes.PLANT_FOREST (nil). A workaround has been used for that.

	if (not HasTrait("TRAIT_LEADER_KEQING_THE_DRIVING_THUNDER", playerID)) then return; end

	local pUnit = Players[playerID]:GetUnits():FindID(unitID);
	if (not pUnit) then return; end

	local unitType = GameInfo.Units[pUnit:GetType()].UnitType;
	if (unitType == "UNIT_BUILDER" or unitType == "UNIT_MILITARY_ENGINEER") then
		abilityCount = ExposedMembers.LIYUEINAZUMA.GetOvertimeShiftAbilityCount(playerID, unitID)
		if (abilityCount > 0) then
			ExposedMembers.LIYUEINAZUMA.OvertimeShiftActionShort(playerID, unitID);
			Events.UnitOperationsCleared.Add(OnUnitOperationsCleared_OvertimeShift);
		end
	end
end

function OnUnitOperationsCleared_OvertimeShift(playerID, unitID, hCommand, iData1)
	local pUnit = Players[playerID]:GetUnits():FindID(unitID);
	if pUnit ~= nil and pUnit:GetMovesRemaining() >= 0 and Game.GetLocalPlayer() == playerID then
		UI.DeselectAllUnits();
		UI.DeselectAllCities();
		UI.SelectUnit(pUnit);
	end
	Events.UnitOperationsCleared.Remove(OnUnitOperationsCleared_OvertimeShift);
end

function OnUnitCommandStarted_OvertimeShift(playerID, unitID, hCommand, iData1)
    if (hCommand ~= UnitCommandTypes.BUILDING_PRODUCTION and hCommand ~= UnitCommandTypes.DISTRICT_PRODUCTION and hCommand ~= UnitCommandTypes.HARVEST_WONDER and hCommand ~= UnitCommandTypes.PROJECT_PRODUCTION and hCommand ~= UnitCommandTypes.WONDER_PRODUCTION) then return; end -- Not that many commands that cost all movement!

	if (not HasTrait("TRAIT_LEADER_KEQING_THE_DRIVING_THUNDER", playerID)) then return; end

	local pUnit = Players[playerID]:GetUnits():FindID(unitID);
	if (not pUnit) then return; end

	local unitType = GameInfo.Units[pUnit:GetType()].UnitType;
	if (unitType == "UNIT_BUILDER" or unitType == "UNIT_MILITARY_ENGINEER") then
		abilityCount = ExposedMembers.LIYUEINAZUMA.GetOvertimeShiftAbilityCount(playerID, unitID)
		if (abilityCount > 0) then
			ExposedMembers.LIYUEINAZUMA.OvertimeShiftActionShort(playerID, unitID);
		end
	end
end

Events.UnitOperationStarted.Add(OnUnitOperationStarted_OvertimeShift);
Events.UnitCommandStarted.Add(OnUnitCommandStarted_OvertimeShift);