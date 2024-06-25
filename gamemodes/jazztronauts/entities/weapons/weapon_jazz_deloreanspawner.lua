SWEP.PrintName			= "Delorean spawner" -- This will be shown in the spawn menu, and in the weapon selection menu
SWEP.Author			= "The Doc" -- These two options will be shown when you have the weapon highlighted in the weapon selection menu
SWEP.Instructions		= "A rigged-up Delorean used to travel to hard to reach places."

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 99999
SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Slot			= 5
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModelFOV		= 90

SWEP.ViewModel				= "models/weapons/c_bus_summoner.mdl"
SWEP.WorldModel				= "models/weapons/w_bus_summoner.mdl"
SWEP.HoldType				= "pistol"

SWEP.UseHands		= true


local ShootSound = Sound( "weapons/357/357_fire2.wav" )
local ShootSound2 = Sound( "Weapon_Gauss.Fire" )




function SWEP:Initialize()
	self:SetHoldType("pistol")
end
function SWEP:Initialize()
	if (self.m_bInitialized) then
		return
	end
		
	self.m_bInitialized = true
	self.m_tEvents = {}
	self.m_tEventHoles = {}
	self.m_tRemovalQueue = {}
end

if SERVER then
function SWEP:Reload()
	removedeloreans = ents.FindByClass("Jazz_car_delorean")
--	timer.Create( "ScarLeaveVelTimer"..self:EntIndex(), 0.3, 1, function()
--	local vel = pGrenade:GetForward() * 1000
--	pGrenade:GetPhysicsObject():SetVelocity( vel )
	for k, v in pairs(removedeloreans) do
		local vel = v:GetForward() * 3000
		v:GetPhysicsObject():SetVelocity( vel )
		v:DoWheelFire()

		v:EmitSound("delorean_scars/explosion.wav")
		v:EmitSound("delorean_scars/spark.wav")

		local effectdatav = EffectData()
		effectdatav:SetOrigin( Vector(100, 10,0) )
		effectdatav:SetEntity( self )
		effectdatav:SetScale( 0.5 )
		util.Effect( "SCarTimeLeapEffect", effectdatav )
		

		timer.Create( "ScarLeaveVelTimer"..self:EntIndex(), 0.5, 1, function()
		v:Remove(self:GetOwner())
		end)
	end
end

function SWEP:SetLaunchedBy(owner)
	self:SetVar("playerwholaunched", owner)
end
end


function SWEP:Think()
	-- Fixes clientside not initializing on occasion
	if (not self.m_bInitialized) then
		self:Initialize()
	end
	
	local bFirstTimePredicted = IsFirstTimePredicted()
	
	-- Events are removed one Think after they mark themselves as complete to maintain clientside prediction
	if (bFirstTimePredicted) then
		for key, _ in pairs(self.m_tRemovalQueue) do
			self.m_tRemovalQueue[key] = nil
			self.m_tEvents[key] = nil
			
			if (isnumber(key)) then
				self.m_tEventHoles[key] = true
			end
		end
	end
	
	-- Events have priority over main think function
	local flCurTime = CurTime()
	
	for key, tbl in pairs(self.m_tEvents) do
		-- Only start running on the first prediction time
		if (bFirstTimePredicted) then
			self.m_tEvents[key][4] = true
		elseif (not self.m_tEvents[key][4]) then
			continue
		end
		
		-- -1 is an event that counts as active but never ran
		if (tbl[1] ~= -1) then
			if (tbl[2] <= flCurTime) then
				local RetVal = tbl[3]()
				
				if (RetVal == true) then
					self.m_tRemovalQueue[key] = true
				else
					-- Update interval
					if (isnumber(RetVal)) then
						tbl[1] = RetVal
					end
					
					tbl[2] = flCurTime + tbl[1]
				end
			end
		end
	end
end
function SWEP:AddEvent(sName, iTime, fCall, bNoPrediction)
	local bAddedByName = isstring(sName)
	
	if (IsFirstTimePredicted() or (bAddedByName and bNoPrediction or fCall == true)) then
		if (bAddedByName) then -- Added by name
			sName = sName:lower()
			self.m_tEvents[sName] = {iTime, CurTime() + iTime, fCall, false}
			self.m_tRemovalQueue[sName] = nil -- Fixes edge case of event being added upon removal
		else
			local iPos = next(self.m_tEventHoles)
			
			if (iPos) then
				self.m_tEvents[iPos] = {sName, CurTime() + sName, iTime, false}
				self.m_tEventHoles[iPos] = nil
			else
				-- No holes, we can safely use the count operation
				self.m_tEvents[#self.m_tEvents] = {sName, CurTime() + sName, iTime, false}
			end
		end
	end
end

function SWEP:EventActive(sName, bNoPrediction)
	sName = sName:lower()
	
	return self.m_tEvents[sName] ~= nil and (bNoPrediction or IsFirstTimePredicted() or self.m_tEvents[sName][4])
end
//
function SWEP:PlaySound(sSound, iIndex, bPlayShared --[[= false]])	
	if (sSound == "") then
		return false
	end
	
	if (bPlayShared or SERVER) then
		local pPlayer = self:GetOwner()
		
		if (pPlayer:IsValid()) then
			pPlayer:EmitSound(sSound)
		else
			self:EmitSound(sSound)
		end
	end
	
	return true
end
function SWEP:GetShootAngles(iIndex --[[= 0]])
	local pPlayer = self:GetOwner()
	
	return pPlayer:EyeAngles() + pPlayer:GetViewPunchAngles()
end
function SWEP:GetShootSrc(iIndex --[[= 0]])
	return self:GetOwner():GetShootPos()
end
function SWEP:GetShootDir(iIndex --[[= 0]])
	return self:GetShootAngles(iIndex):Forward()
end
function _SetAbsVelocity(ent, vAbsVelocity)
	if (ent:GetInternalVariable("m_vecAbsVelocity") ~= vAbsVelocity) then
		// The abs velocity wont be dirty since we're setting it here
		ent:RemoveEFlags(EFL_DIRTY_ABSVELOCITY)
		
		// All children are invalid, but we are not
		local tChildren = ent:GetChildren()
			
		for i = 1, #tChildren do
			tChildren[i]:AddEFlags(EFL_DIRTY_ABSVELOCITY)
		end
		
		ent:SetSaveValue("m_vecAbsVelocity", vAbsVelocity)
		
		// m_vVelocity is only networked for the player, which is not manual mode
		local pMoveParent = ent:GetMoveParent()
		
		if (pMoveParent:IsValid()) then
			// First subtract out the parent's abs velocity to get a relative
			// velocity measured in world space
			// Transform relative velocity into parent space
			//ent:SetSaveValue("m_vecVelocity", (vAbsVelocity - pMoveParent:_GetAbsVelocity()):IRotate(pMoveParent:EntityToWorldTransform()))
			ent:SetSaveValue("velocity", vAbsVelocity)
		else
			ent:SetSaveValue("velocity", vAbsVelocity)
		end
	end
end



function SWEP:SecondaryAttack() // time to suffer
	local flCooldown = 1.5;
	if(!self:GetOwner()) then
		return false
	end
	if(self:GetOwner():GetAmmoCount("SMG1_Grenade") < 0) then
		self:SetNextPrimaryFire(CurTime() + flCooldown, self:EntIndex())
		self:SetNextSecondaryFire(CurTime() + flCooldown, self:EntIndex()) -- Double the penalty
		
		self:PlaySound("Weapon_SMG1.Empty", self:EntIndex())
		return false
	end
	
	
	local pPlayer = self:GetOwner()
	if (SERVER) then
		// Create the grenade
		local pGrenade = ents.Create("Jazz_car_delorean")
		if (pGrenade:IsValid()) then
	
	
	pGrenade:PhysicsInit(SOLID_VPHYSICS)
	pGrenade:SetMoveType(MOVETYPE_VPHYSICS)
	pGrenade:SetSolid(SOLID_VPHYSICS)
	pGrenade:SetColor(Color(255,255,255,255))
	pGrenade:Activate()

	
    local phys = pGrenade:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake() 
		phys:SetMass(self.CarMass)
		phys:EnableDrag(false)	
		phys:SetBuoyancyRatio( 0.025 )


	end

			pGrenade:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() + Vector(40, 40, -30) ) )
			pGrenade:Spawn()
			local vel = pGrenade:GetForward() * 1000
	pGrenade:GetPhysicsObject():SetVelocity( vel )

	pGrenade:EmitSound("delorean_scars/explosion.wav")
	pGrenade:EmitSound("delorean_scars/spark.wav")

	local effectdatapGrenade = EffectData()
	effectdatapGrenade:SetOrigin( Vector(100, 10,0) )
	effectdatapGrenade:SetEntity( self )
	effectdatapGrenade:SetScale( 0.5 )
	util.Effect( "SCarTimeLeapEffect", effectdatapGrenade )

	timer.Create( "ScarKillVelTimer"..self:EntIndex(), 0.3, 1, function()
		local vel = pGrenade:GetForward() * (-100)
		pGrenade:GetPhysicsObject():SetVelocity( vel )

		end)
	end
end
	pPlayer:RemoveAmmo(0, "SMG1_Grenade")
		
	// Register a muzzleflash for the AI
	pPlayer:MuzzleFlash()
		
	pPlayer:SetAnimation(PLAYER_ATTACK1)
		
	local flNextTime = CurTime() + flCooldown
	self:SetNextPrimaryFire(CurTime(), self:EntIndex())
	self:SetNextSecondaryFire(flNextTime + flCooldown, self:EntIndex()) -- Double the penalty
		
	self:PlaySound("Weapon_SMG1.Double", self:EntIndex())
end





