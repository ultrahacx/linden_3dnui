local last_x, last_y, lasttext

function DrawTextNUI(coords, text, active)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(coords.x,coords.y,coords.z)
	if _x ~= last_x or _y ~= last_y or text ~= lasttext then
		if active then 
			SendNUIMessage({action = 'display', x = _x, y = _y, text = text})
		else
			SendNUIMessage({action = 'hide', x = _x, y = _y, text = text})
		end
		last_x, last_y, lasttext = _x, _y, text
		Citizen.Wait(0)
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isDrawing = false
		for k,v in ipairs(Config.List) do
			if not isDrawing then
				local distance = GetDistanceBetweenCoords(playerCoords, v.coords)
				drawCoords, drawText, isDrawing = v.coords, v.text, true
				if distance > v.range then isDrawing = false end
			end
		end
		DrawTextNUI(drawCoords, drawText, isDrawing)
	end
end)