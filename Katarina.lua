local waitTickCount = 0

function AfterObjectLoopEvent(myHero)
	waitTickCount = waitTickCount - 1
	local unit = GetCurrentTarget()
	if waitTickCount > 0 then return end
	local movePos = GenerateMovePos()
	if KeyIsDown(0x41) and GetDistanceSqr(GetMousePos()) > GetHitBox(myHero)*GetHitBox(myHero) then
		MoveToXYZ(movePos.x, 0, movePos.z)
	end
	if ValidTarget(unit) then
        local dmg = 0
        local hp  = GetCurrentHP(unit)
        local AP = GetBonusAP(myHero)
        local TotalDmg = GetBonusDmg(myHero)+GetBaseDamage(myHero)
	    local targetPos = GetOrigin(unit)
	    local drawPos = WorldToScreen(1,targetPos.x,targetPos.y,targetPos.z)
        if CanUseSpell(myHero, _Q) == READY then
        	dmg = dmg + CalcDamage(myHero, unit, 0, 35+25*GetCastLevel(myHero,_Q)+0.45*AP) * 1.25
        end
        if CanUseSpell(myHero, _W) == READY then
        	dmg = dmg + CalcDamage(myHero, unit, 0, 5+35*GetCastLevel(myHero,_W)+0.25*AP+0.6*TotalDmg)
        end
        if CanUseSpell(myHero, _E) == READY then
        	dmg = dmg + CalcDamage(myHero, unit, 0, 10+30*GetCastLevel(myHero,_E)+0.25*AP)
        end
        if CanUseSpell(myHero, _R) ~= ONCOOLDOWN and GetCastLevel(myHero,_R) > 0 then
        	dmg = dmg + CalcDamage(myHero, unit, 0, 30+10*GetCastLevel(myHero,_R)+0.2*AP+0.3*GetBonusDmg(myHero)) * 10
        end
        if dmg > hp then
        	DrawText("Killable",20,drawPos.x,drawPos.y,0xffffffff)
        	DrawDmgOverHpBar(unit,hp,0,hp,0xffffffff)
        else
        	DrawText(math.floor(100 * dmg / hp).."%",20,drawPos.x,drawPos.y,0xffffffff)
        	DrawDmgOverHpBar(unit,hp,0,dmg,0xffffffff)
        end
		if not KeyIsDown(0x41) then return end
    	if IsInDistance(unit, 675) and CanUseSpell(myHero, _Q) == READY then
    		CastTargetSpell(unit, _Q)
		elseif IsInDistance(unit, 375) and CanUseSpell(myHero, _W) == READY then
    		CastTargetSpell(myHero, _W)
		elseif IsInDistance(unit, 700) and CanUseSpell(myHero, _E) == READY then
    		CastTargetSpell(unit, _E)
		elseif IsInDistance(unit, 550) and CanUseSpell(myHero, _W) == ONCOOLDOWN and CanUseSpell(myHero, _Q) == ONCOOLDOWN and CanUseSpell(myHero, _E) == ONCOOLDOWN and CanUseSpell(myHero, _R) ~= ONCOOLDOWN and GetCastLevel(myHero,_R) > 0 then
    		CastTargetSpell(myHero, _R)
		end
		lastTargetName = GetObjectName(unit)
	end
end

function OnProcessSpell(unit, spell)
	if unit and unit == myHero and spell then
		if spell.name:lower():find("katarinar") then
			waitTickCount = 250
		end
	end
end
