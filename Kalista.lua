function AfterObjectLoopEvent(myHero)
    local movePos = GenerateMovePos()
    local unit = GetTarget(GetRange(myHero))
    if not KeyIsDown(0x20) then return end
    if ValidTarget(unit, 1000) then
      local TotalDmg = GetBonusDmg(myHero)+GetBaseDamage(myHero)
      local dmgE = (GotBuff(unit,"kalistaexpungemarker") > 0 and (10 + (10 * GetCastLevel(myHero,_E)) + (TotalDmg * 0.6)) + (GotBuff(unit,"kalistaexpungemarker")-1) * (kalE(GetCastLevel(myHero,_E)) + (0.15 + 0.03 * GetCastLevel(myHero,_E))*TotalDmg) or 0)
      local dmg = CalcDamage(myHero, unit, dmgE)
      local hp = GetCurrentHP(unit)
      local targetPos = GetOrigin(unit)
      local drawPos = WorldToScreen(1,targetPos.x,targetPos.y,targetPos.z)
      if dmg > 0 then 
        DrawText(math.floor(dmg/hp*100).."%",20,drawPos.x,drawPos.y,0xffffffff)
        if hp > 0 and dmg >= hp then CastTargetSpell(unit, _E) end
      end
    end
    if ValidTarget(unit, GetRange(myHero)) then
      local QPred = GetPredictionForPlayer(myHeroPos,unit,GetMoveSpeed(unit),1750,250,1150,70,true,true)
      if walk then
        walk = false
        MoveToXYZ(movePos.x, movePos.y, movePos.z)
      elseif CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 then
        walk = true
        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
      else
        walk = true
        AttackUnit(unit)
      end
    else
      MoveToXYZ(movePos.x, movePos.y, movePos.z)
    end
end

function kalE(x)
	if x <= 1 then 
		return 10
	else 
		return kalE(x-1) + 2 + x
	end 
end
