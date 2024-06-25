print ("delorean shared")


ENT.Base = "sent_sakarias_scar_base"
ENT.Type = "anim"

ENT.PrintName		= "DeLorean"
ENT.Author			= "00731"
ENT.Category 		= "Misc"
ENT.Information 	= ""
ENT.AdminOnly		= true


ENT.AddSpawnHeight = 16
ENT.ViewDist = 200
ENT.ViewDistUp = 30


ENT.NrOfSeats = 2	
ENT.NrOfWheels = 4
ENT.NrOfExhausts = 6
ENT.NrOfFrontLights = 2
ENT.NrOfRearLights = 2

ENT.SeatPos = {}
ENT.WheelInfo = {}
ENT.ExhaustPos = {}
ENT.FrontLightsPos = {}
ENT.RearLightsPos = {}

ENT.effectPos = NULL

ENT.CarMass = 500
ENT.StabiliserOffset = NULL
ENT.StabilisationMultiplier = 70 --70 is default

ENT.DefaultSound = "scarenginesounds/3.wav"
ENT.CarModel = "models/delorean_prop.mdl"
ENT.TireModel = "models/xeon133/racewheelskinny/race-wheel-30_s.mdl"
ENT.AnimType = 1 --1 = jeep anim, 2 = airboat anim

ENT.FrontLightColor = "220 220 160" --RGB
------------------------------------VARIABLES END

for i = 1, ENT.NrOfWheels do
	ENT.WheelInfo[i] = {}
end

local xPos = 0
local yPos = 0
local zPos = 0

//SEAT POSITIONS
--Seat Position 1 
xPos = -8
yPos = -23.5
zPos = -1
ENT.SeatPos[1] = Vector(xPos, yPos, zPos)

--Seat Position 2
xPos = -8
yPos = 12.5
zPos = -1		
ENT.SeatPos[2] = Vector(xPos, yPos, zPos)


//WHEEL POSITIONS
--Side false = Left
--Side true = Right
--Torq true = spins
--Torq false = do not spin

--The two first wheels should be the front ones.
--The third and fourth wheel should be the rear ones.
--You can have more wheels but the suspension adjuster stool will set the suspension softness to the middle value between the front and rear softness.

--Front Left wheel
xPos = 57
yPos = -37
zPos = 4		
ENT.WheelInfo[1].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[1].Side = false
ENT.WheelInfo[1].Torq = false
ENT.WheelInfo[1].Steer = 1

--Front Right wheel
xPos = 57
yPos = 25
zPos = 4		
ENT.WheelInfo[2].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[2].Side = true
ENT.WheelInfo[2].Torq = false
ENT.WheelInfo[2].Steer = 1

--Rear Left wheel
xPos = -40.5
yPos = -37
zPos = 4	
ENT.WheelInfo[3].Pos = Vector( xPos, yPos, zPos )
ENT.WheelInfo[3].Side = false
ENT.WheelInfo[3].Torq = true
ENT.WheelInfo[3].Steer = 0

--Rear Right wheel
xPos = -40.4
yPos = 25
zPos = 4	
ENT.WheelInfo[4].Pos  =  Vector( xPos, yPos, zPos )
ENT.WheelInfo[4].Side = true
ENT.WheelInfo[4].Torq = true
ENT.WheelInfo[4].Steer = 0




//LIGHT POSITIONS	

--//Front Lights
--Left
xPos = 91
yPos = -27.5
zPos = 17	
ENT.FrontLightsPos[1] = Vector(xPos, yPos, zPos)

--Right
xPos = 91
yPos = 16
zPos = 17	
ENT.FrontLightsPos[2] = Vector(xPos, yPos, zPos)


--//Rear Lights
--Left
xPos = -84
yPos = 16
zPos = 	20
ENT.RearLightsPos[1] = Vector(xPos, yPos, zPos)

--Right
xPos = -84
yPos = -27.5
zPos = 20
ENT.RearLightsPos[2] = Vector(xPos, yPos, zPos)






--The position where the fire and smoke effects will be placed when the car is damaged
xPos = -52
yPos = 0
zPos = 35	
ENT.effectPos = Vector(xPos, yPos, zPos)



--The position of the exhaust
xPos = -84
yPos = -23.5
zPos = 30	
ENT.ExhaustPos[1] = Vector(xPos, yPos, zPos)

xPos = -83
yPos = -23.5
zPos = 35	
ENT.ExhaustPos[2] = Vector(xPos, yPos, zPos)

xPos = -82
yPos = -23.5
zPos = 40
ENT.ExhaustPos[3] = Vector(xPos, yPos, zPos)

xPos = -84
yPos = 11
zPos = 30
ENT.ExhaustPos[4] = Vector(xPos, yPos, zPos)

xPos = -83
yPos = 11
zPos = 35	
ENT.ExhaustPos[5] = Vector(xPos, yPos, zPos)

xPos = -82
yPos = 11
zPos = 40	
ENT.ExhaustPos[6] = Vector(xPos, yPos, zPos)


//SUSPENSION
--The higher the number is the harder the suspension will be
--Recommend not to change these numbers
ENT.DefaultSoftnesFront = 25
ENT.DefaultSoftnesRear = 25


ENT.DefaultAcceleration = 4500
ENT.DefaultMaxSpeed = 2500
ENT.DefaultTurboEffect = 4
ENT.DefaultTurboDuration = 10
ENT.DefaultTurboDelay = 1
ENT.DefaultReverseForce = 2000
ENT.DefaultReverseMaxSpeed = 500
ENT.DefaultBreakForce = 3000
ENT.DefaultSteerForce = 6
ENT.DefautlSteerResponse = 0.6
ENT.DefaultStabilisation = 8000
ENT.DefaultNrOfGears = 5
ENT.DefaultAntiSlide = 100
ENT.DefaultAutoStraighten = 40

ENT.DeafultSuspensionAddHeight = 0
ENT.DefaultHydraulicActive = 0

list.Set( "SCarsList", ENT.PrintName, ENT )

ENT.FlyMode = false



function ENT:StartCarCustom()

	if self.AboutToTurnOn == false and self:HasDriver() && self.IsOn == false && self.Fuel > 0 && self.CarHealth > 0 && self:WaterLevel() <= self.AcceptedWaterLevel then
		self:EmitSound(self.TurnOnSoundDir,70)
		self.AboutToTurnOn = true
		timer.Create( "ScarStartTimer"..self:EntIndex(), 0.1, 1, function()
			if self and self.HasDriver && self:HasDriver() && self.IsOn == false && self.Fuel > 0 && self.CarHealth > 0 && self:WaterLevel() <= self.AcceptedWaterLevel	then
				self:TurnOnCar()
				self.AutoTurnOn = false
			end
			self.AboutToTurnOn = false
		end )			
	end
end

function ENT:CheckSwapToNextSeat()

	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			local driver = self.Seats[i]:GetDriver()

			if driver:IsPlayer() && (!driver.SwapSeatDelay or driver.SwapSeatDelay < CurTime()) then
				driver.SwapSeatDelay = CurTime() + 1000000000000000
		end		
	end
end
end

function ENT:Initialize()
	


	--Setting up the SCar in the SCar base
	self:Setup()

	if (SERVER) then
		--Setting up the car characteristics
		self:SetAcceleration( self.DefaultAcceleration )
		self:SetMaxSpeed( self.DefaultMaxSpeed )
		
		self:SetTurboEffect( self.DefaultTurboEffect )
		self:SetTurboDuration( self.DefaultTurboDuration )
		self:SetTurboDelay( self.DefaultTurboDelay )
		
		self:SetReverseForce( self.DefaultReverseForce )
		self:SetReverseMaxSpeed( self.DefaultReverseMaxSpeed )
		self:SetBreakForce( self.DefaultBreakForce )
		
		self:SetSteerForce( self.DefaultSteerForce )
		self:SetSteerResponse( self.DefautlSteerResponse )
		
		self:SetStabilisation( self.DefaultStabilisation )
		self:SetNrOfGears( self.DefaultNrOfGears )
		self:SetAntiSlide( self.DefaultAntiSlide )
		self:SetAutoStraighten( self.DefaultAutoStraighten )	
		
		self:SetSuspensionAddHeight( self.DeafultSuspensionAddHeight )
		self:SetHydraulicActive( self.DefaultHydraulicActive )	


		self.StabilizerPropFly = ents.Create( "prop_physics" )
		self.StabilizerPropFly:SetModel("models/props_junk/sawblade001a.mdl")		
		self.StabilizerPropFly:SetPos(self.Entity:GetPos() + self.StabiliserOffset.x * self.Entity:GetForward() + self.StabiliserOffset.y * self.Entity:GetRight() + self.StabiliserOffset.z * self.Entity:GetUp() )
		self.StabilizerPropFly:SetOwner(self.Owner)		
		self.StabilizerPropFly:SetAngles(self.Entity:GetAngles())
		self.StabilizerPropFly:SetColor(Color(255,255,255,0))
		self.StabilizerPropFly:SetNoDraw( true )
		self.StabilizerPropFly:Spawn()
		self.StabilizerPropFly:GetPhysicsObject():EnableGravity(false)	
		self.StabilizerPropFly:SetCollisionGroup( COLLISION_GROUP_DEBRIS )	
		self.StabilizerPropFly:GetPhysicsObject():SetMass(self.StabilisationMultiplier)
		self.StabilizerPropFly:SetNotSolid( true )
		self.StabilizerPropFly:GetPhysicsObject():EnableDrag(false)	

		constraint.Weld( self.Entity, self.StabilizerPropFly, 0, 0, 0, true )
		
		self.FakeWheels = {}
		for i = 1, self.NrOfWheels do		
			self.FakeWheels[i] = ents.Create( "prop_physics" )
			self.FakeWheels[i]:SetModel(self.TireModel)	
			self.FakeWheels[i]:Spawn()	
			self.FakeWheels[i]:SetPos( self.Entity:GetPos() + (self:GetForward() * self.WheelInfo[i].Pos.x) + (self:GetRight() * self.WheelInfo[i].Pos.y) + (self:GetUp() * self.WheelInfo[i].Pos.z))		
			self.FakeWheels[i]:SetParent( self.Entity )
			self.FakeWheels[i]:SetLocalAngles( Angle(0,0,0) )	
			self.FakeWheels[i]:SetNotSolid( true )
			self.FakeWheels[i]:SetColor(Color(0,0,0,0))
			self.FakeWheels[i]:SetNoDraw( true )
			self.FakeWheels[i].WheelSide = false



		end
	end
end



ENT.FlyUser = nil
ENT.StabilizerConstaintFly = nil
ENT.FloatHeight = 0
ENT.WheelSaveColor = {}

ENT.FakeWheels = {}
ENT.TransDel = 0.2
ENT.TransTime = 0
ENT.InTransition = 0

ENT.TimeLeapDel = 1.5
ENT.TimeLeapTime = 0
ENT.TimeLeapState = 0
ENT.StoppingTimeLeap = 0
function ENT:SpecialThink()
	if (SERVER) then
		local driver = self:GetDriver()
		if driver:IsPlayer() then
			if self.TimeLeapState == 0 and self.FlyMode == false and SCarKeys:KeyWasReleased(driver, "Special") and self.IsOn == true then
				SCarKeys:KillKey(driver, "Special")
				
				if self.TimeLeapState == 0 then
					if !driver:KeyDown( IN_FORWARD )  then
						self:DoFlyMode( true )
					elseif driver:KeyDown( IN_FORWARD ) and self.TimeLeapTime < CurTime() and self.StoppingTimeLeap < CurTime() then
						self:DoTimeLeap()
						self:EmitSound("delorean_scars/sparks_loop.wav")
						timer.Simple(1, function()
							self:StopSound("delorean_scars/sparks_loop.wav")
						end)
					end
				end
			elseif self.FlyMode == true and SCarKeys:KeyWasReleased(driver, "Special") and self.TimeLeapState == 0 then
				SCarKeys:KillKey(driver, "Special")
				self:DoFlyMode( false )
			end
		end
		
		
		----------------FLY
		if self.FlyMode == true then
			self.FlyUser = self:GetDriver()
			self.UseTurbo = CurTime() + 0.1
--			if !self.FlyUser or !self.FlyUser.GetAimVector or self.IsOn == false then
			if self.IsOn == false then
				self:DoFlyMode( false )
			else
				self:Direct()
			end
		end	
		
		if self.InTransition != 0 then
			local per = (self.TransTime - CurTime()) / self.TransDel

--			if self.InTransition == 1 then
--				for i = 1, self.NrOfWheels do
--					if self.FakeWheels[i].WheelSide then
--						self.FakeWheels[i]:SetLocalAngles( Angle(0,0,((1-per)*90))	)
--					else
--						self.FakeWheels[i]:SetLocalAngles( Angle(0,0,180-((1-per)*90)))
--					end
--					
--				end
--			else
--				for i = 1, self.NrOfWheels do
--					if self.FakeWheels[i].WheelSide then
--						self.FakeWheels[i]:SetLocalAngles( Angle(0,0,(per*90) ))	
--					else
--						self.FakeWheels[i]:SetLocalAngles( Angle(0,0,180-(per*90)))
--					end
--				end
--			end

		if self.FlyMode == true then
				for i = 1, self.NrOfWheels do
					if self.FakeWheels[i].WheelSide then
						self.FakeWheels[i]:SetLocalAngles( Angle(0,0,90))
					else
						self.FakeWheels[i]:SetLocalAngles( Angle(0,0,90))
					end

				end

			end



			if per > 1 or per < 0 then
				
				if self.InTransition == -1 then
					for i = 1, self.NrOfWheels do
						if self.Wheels[i] and self.WheelSaveColor[i] then
							self.Wheels[i]:SetColor( self.WheelSaveColor[i] )
							self.Wheels[i]:SetNoDraw( false )
							if IsValid(self.Wheels[i].DecoyWheel) then
								self.Wheels[i].DecoyWheel:SetNoDraw( false )
							end		
							
							self.FakeWheels[i]:SetColor(Color(0,0,0,0))
							self.FakeWheels[i]:SetNoDraw( true )
						end
					end
				end
				
				self.InTransition = 0
				
			end
		end

		------------------TIME LEAP
		if self.TimeLeapState == 1 then
			self:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 30000 )
			
			--Spawn wheel fire
			if (self.TimeLeapTime - 2) < CurTime() then
				self:DoWheelFire()
			end
			
			if !driver:KeyDown( IN_FORWARD ) and self.TimeLeapTime > CurTime() then
				self.TimeLeapState  = 0
				self.StoppingTimeLeap = CurTime() + 1.1
			end			

			if (self.TimeLeapTime - 0.8) < CurTime() then
				if self:GetPhysicsObject():GetVelocity():Length() > 1 then
					self.TimeLeapState = 2
					self:EmitSound("delorean_scars/spark.wav")
					self:EmitSound("delorean_scars/explosion.wav")
					self:Extinguish()
					driverhealth = driver:Health()
					driver:GodEnable()
					driver:SetHealth(99999999)
					driver:SetNoTarget(true)
					local effect = EffectData()
					effect:SetOrigin(self:GetPos())
					effect:SetStart(self:GetPos())
					effect:SetScale(750)
					effect:SetMagnitude(200)
					effect:SetNormal(Vector(0,0,1))
					util.Effect("ThumperDust", effect)	
					self:StartTimeTravel()
					self.TimeLeapTime = CurTime() + 0.5
				else
					self.TimeLeapState = 0
					self.TimeLeapTime = CurTime() + 1.1
					self.StoppingTimeLeap = CurTime() + 1.1
				end
			end







		elseif self.TimeLeapState == 2 then
			if !self:HasDriver() then
				driver:GodDisable()
				self.TimeLeapState = 3
				self.TimeLeapTime = CurTime() + 0.5
				self:StopTimeTravel()

				local vel = self:GetForward() * 1000
				self:GetPhysicsObject():SetVelocity( vel )

			elseif self.TimeLeapState == 2 and SCarKeys:KeyWasReleased(driver, "ToggleHeadlights") then
				driver:GodDisable()
				driver:SetHealth(driverhealth)
				driver:SetNoTarget(false)
				mapcontrol.Launch(mapcontrol.GetHubMap())



				return
			elseif self:HasDriver() and SCarKeys:KeyWasReleased(driver, "Special") then
				SCarKeys:KillKey(driver, "Special")
				self:EmitSound("delorean_scars/explosion.wav")
				self:EmitSound("delorean_scars/spark.wav")

				local effectdataleave = EffectData()
				effectdataleave:SetOrigin( Vector(100, 10,0) )
				effectdataleave:SetEntity( self )
				effectdataleave:SetScale( 0.5 )
				util.Effect( "SCarTimeLeapEffect", effectdataleave )
				
				self.TimeLeapState = 3
				driver:GodDisable()
				driver:SetHealth(driverhealth)
				driver:SetNoTarget(false)
				self.TimeLeapTime = CurTime() + 0.5
				self:StopTimeTravel()
				
				local vel = self:GetForward() * 1000
				self:GetPhysicsObject():SetVelocity( vel )
				
				for i = 1, self.NrOfWheels do
					if self.Wheels[i] then	
						self.Wheels[i]:GetPhysicsObject():SetVelocity( vel )
					end
				end
				
				return
			end



			local ang = driver:EyeAngles()
			local angDiff = math.AngleDifference( ang.y, self:GetAngles().y )
			driver:SetEyeAngles( Angle(ang.p, 90 + angDiff, 0) )
			ang = self:GetAngles()
			ang.p = 0
			ang.y = ang.y + angDiff * 0.05
			ang.r = 0
			self:SetAngles( ang )

			if driver:KeyDown( IN_ATTACK ) then
				self.MovePos = self.MovePos + self:GetUp() * 20
			elseif driver:KeyDown( IN_ATTACK2 ) then
				self.MovePos = self.MovePos + self:GetUp() * -20
			end

			if driver:KeyDown( IN_FORWARD ) then
				self.MovePos = self.MovePos + self:GetForward() * 20
			elseif driver:KeyDown( IN_BACK ) then
				self.MovePos = self.MovePos + self:GetForward() * -20
			end

			if driver:KeyDown( IN_MOVERIGHT ) then
				self.MovePos = self.MovePos + self:GetRight() * 20
			elseif driver:KeyDown( IN_MOVELEFT ) then
				self.MovePos = self.MovePos + self:GetRight() * -20

			elseif driver:KeyDown( IN_SPEED ) and driver:KeyDown( IN_ATTACK2 ) then
				self.MovePos = self.MovePos + self:GetUp() * -50
			elseif driver:KeyDown( IN_SPEED ) and driver:KeyDown( IN_ATTACK ) then
				self.MovePos = self.MovePos + self:GetUp() * 50
			elseif driver:KeyDown( IN_SPEED ) and driver:KeyDown( IN_FORWARD ) then
				self.MovePos = self.MovePos + self:GetForward() * 200
			elseif driver:KeyDown( IN_SPEED ) and driver:KeyDown( IN_BACK ) then
				self.MovePos = self.MovePos + self:GetForward() * -200

			end

			self:SetPos( self.MovePos )
		elseif self.TimeLeapState == 3 then
			self:DoWheelFire()
			if self.TimeLeapTime < CurTime() then
				self.TimeLeapState = 0
			end
		end
	end
end


ENT.SCarCol = {}
ENT.SCarWheelCol = {}
ENT.PlyCols = {}
ENT.Pass = {}
ENT.NrPass = 0
ENT.OldCarTakeDamage = 0
ENT.OldWheelTakeDamage = {}
ENT.OldSaveFuel = 0
ENT.MovePos = Vector(0,0,0)
ENT.OldView = 0


function ENT:PutWheelDamageOn()
	for i = 1, self.NrOfWheels do
		if self.Wheels[i] and self.OldWheelTakeDamage[i] then
			self.Wheels[i].CanTakeDamage = self.OldWheelTakeDamage[i]
		end
	end	
end


function ENT:StartTimeTravel()
	
	if self:GetDriver():IsPlayer() then
		self.OldView = self:GetDriver():GetNetworkedInt( "SCarThirdPersonView" )
		self:GetDriver():SetNetworkedInt( "SCarThirdPersonView", 1 )
		self:SetNetworkedEntity( "SCarCloakOwner", self:GetDriver() )
	end
	
	self:SetNetworkedBool( "SCarInTimeTravel", true )
	self.NrPass, self.Pass = self:GetPassengers()
	self.MovePos = self:GetPos()
	
	local ang = self:GetAngles()
	ang.p = 0
	ang.r = 0
	self:SetAngles( ang ) 

	for i = 1, self.NrPass do
		self.PlyCols[i] = self.Pass[i]:GetColor()

		self.Pass[i]:SetColor(Color(0,0,0,0))
		self.Pass[i]:SetNoDraw( true )
	end

	
	
	

	self:SetPos( self:GetPos() + Vector(0,0,10) )
	self:GetPhysicsObject():SetVelocity(Vector(0,0,0))
	self:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity()*-1 )
	self:GetPhysicsObject():EnableMotion(false)
	
	self.OldSaveFuel = self.Fuel
	self.Fuel = 0
	
	self.SCarCol = self:GetColor()


	
	self:SetColor(Color(0,0,0,1))
	self:SetNotSolid( true )
	--self:SetNoDraw( true )
	self:GetPhysicsObject():EnableGravity( false )
	
	for i = 1, self.NrOfWheels do
		if self.Wheels[i] then

			self.SCarWheelCol[i] = self.Wheels[i]:GetColor()
				

			self.Wheels[i]:SetColor(Color(0,0,0,0))
			self.Wheels[i]:SetNoDraw( true )
			
			if IsValid(self.Wheels[i].DecoyWheel) then
				self.Wheels[i].DecoyWheel:SetNoDraw( true )
			end	
							
			self.Wheels[i]:SetNotSolid( true )
			self.Wheels[i]:GetPhysicsObject():EnableGravity( false )
			self.Wheels[i]:GetPhysicsObject():SetVelocity(Vector(0,0,0))
			self.Wheels[i]:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity()*-1 )	
			self.Wheels[i].CanTakeDamage = 0
		else
			self.SCarWheelCol[i] = nil
		end
	end	
	
	for i = 1, self.NrOfSeats do
		if self.Seats[i] then
			self.Seats[i]:GetPhysicsObject():SetVelocity(Vector(0,0,0))
			self.Seats[i]:GetPhysicsObject():AddAngleVelocity( self:GetPhysicsObject():GetAngleVelocity()*-1 )				
		end
	end
end

function ENT:StopTimeTravel()

	
	if self:GetDriver() and self:GetDriver():IsPlayer() then
		self:GetDriver():SetEyeAngles( Angle(0,90,0) )
		self:GetDriver():SetNetworkedInt( "SCarThirdPersonView", self.OldView )
	end

	self:SetNetworkedBool( "SCarInTimeTravel", false )
	for i = 1, self.NrPass do
		if IsValid(self.Pass[i]) and self.PlyCols[i] then
			self.Pass[i]:SetColor(self.PlyCols[i])		
			self.Pass[i]:SetNoDraw( false )
			self.PlyCols[i] = nil
		end
	end
	
	
	self:SetColor(self.SCarCol)
	self:SetNoDraw( false )
	self:SetNotSolid( false )
	self:GetPhysicsObject():EnableGravity( true )	
	self:GetPhysicsObject():EnableMotion(true)
	
	self.CanTakeDamage = self.OldCarTakeDamage
	self.Fuel = self.OldSaveFuel
	self:StartCarCustom()
	
	for i = 1, self.NrOfWheels do
		if self.Wheels[i] and self.SCarWheelCol[i] then
			self.Wheels[i]:SetColor(self.SCarWheelCol[i])
			self.Wheels[i]:SetNoDraw( false )
			
			if IsValid(self.Wheels[i].DecoyWheel) then
				self.Wheels[i].DecoyWheel:SetNoDraw( false )
			end	
			
			if self.Wheels[i].IsFlat == false then
				self.Wheels[i]:SetNotSolid( false )
			end
			self.Wheels[i]:GetPhysicsObject():EnableGravity( true )
		end
	end		
	self.StoppingTimeLeap = CurTime() + 1.1
	timer.Create( "ScarDeLoreanFixWheels"..self:EntIndex(), 1, 1, function()
		if self and self.PutWheelDamageOn then
			self:PutWheelDamageOn()
		end
	end)

end

function ENT:DoWheelFire()

	local len = 0
	
	for i = 3, self.NrOfWheels do
		if self.Wheels[i] then
			len = (self.Wheels[i]:OBBMaxs().z - self.Wheels[i]:OBBMins().z) * 0.5
			local fire = ents.Create( "env_fire" )
			fire:SetPos( self.Wheels[i]:GetPos() )
			fire:SetKeyValue("health","0")
			fire:SetKeyValue("firesize","10")
			fire:SetKeyValue("fireattack","0")
			fire:SetKeyValue("damagescale",0)
			fire:SetKeyValue("spawnflags","2")
			fire:Spawn()
			fire:Activate()
			fire:Fire("StartFire","",0)
			
			SafeRemoveEntityDelayed( fire, 5 )			
		end
	end


    
    
end

function ENT:DoTimeLeap()
	if self.TimeLeapState == 0 then
		self.TimeLeapTime = CurTime() + self.TimeLeapDel
		self.TimeLeapState = 1
		
		self.OldCarTakeDamage = self.CanTakeDamage
		self.CanTakeDamage = 0

		for i = 1, self.NrOfWheels do
			if self.Wheels[i] then
				self.OldWheelTakeDamage[i] = self.Wheels[i].CanTakeDamage
				self.Wheels[i].CanTakeDamage = 0
			end
		end

		local effectdata = EffectData()
		effectdata:SetOrigin( Vector(100, 10,0) )
		effectdata:SetEntity( self )
		effectdata:SetScale( 0.5 )
		util.Effect( "SCarTimeLeapEffect", effectdata )

		-- local effectdata2 = EffectData()
		-- effectdata2:SetOrigin( Vector(100, 10,0) )
		-- effectdata2:SetEntity( self )
		-- effectdata2:SetScale( 10.5 )
		-- util.Effect( "AR2Tracer", effectdata2 )

	end
end

function ENT:DoFlyMode( d )
	if self.InTransition == 0 then
		self.TransTime = CurTime() + self.TransDel

		if d then
			self.InTransition = 1
			self.FlyMode = true
			self:DoGravity( false )
			self.StabilizerConstaintFly = constraint.Keepupright( self.StabilizerPropFly, Angle(0,0,0) , 0, 100000)
			self.FloatHeight = self:GetPos().z + 20

			for i = 1, self.NrOfWheels do
				if self.Wheels[i] then

					self.WheelSaveColor[i] = self.Wheels[i]:GetColor()

					self.Wheels[i]:SetColor(Color(0,0,0,0))
					self.Wheels[i]:SetNoDraw( true )

					if IsValid(self.Wheels[i].DecoyWheel) then
						self.Wheels[i].DecoyWheel:SetNoDraw( true )
					end

					self.FakeWheels[i]:SetModel(self.Wheels[i]:GetModel())

					if self.WheelAxis[i]:IsValid() then
						self.FakeWheels[i]:SetColor(self.WheelSaveColor[i])
						self.FakeWheels[i]:SetNoDraw( false )
					end

					self.FakeWheels[i].WheelSide = self.Wheels[i].Side
				else
					self.WheelSaveColor[i] = nil
				end
			end
		else
			self.InTransition = -1
			self.FlyMode = false
			self:DoGravity( true )

			if self.IsOn == true && !self:HasDriver() then
				self:EnableMotion(false)
			end
			
			if IsValid( self.StabilizerConstaintFly ) then
				self.StabilizerConstaintFly:Remove()
				self.StabilizerConstaintFly = NULL
			end	
		end
	end
end

function ENT:Direct()

	if self.IsOn == true && self:HasDriver() then

		local angVel = self:GetPhysicsObject():GetAngleVelocity()
		angVel = angVel * -0.1
		self:GetPhysicsObject():AddAngleVelocity(angVel)
		
		local vel = self:GetPhysicsObject():GetVelocity()
		self:GetPhysicsObject():SetVelocity( self:GetPhysicsObject():GetVelocity() * 0.99)

		if self.FlyUser:KeyDown( IN_ATTACK ) then
			self.FloatHeight = self.FloatHeight + 5
		elseif self.FlyUser:KeyDown( IN_ATTACK2 ) then
			self.FloatHeight = self.FloatHeight - 5
		end

		if self.FlyUser:KeyDown( IN_FORWARD ) then
			self:GetPhysicsObject():ApplyForceCenter( self:GetForward() * 5000 )
		elseif self.FlyUser:KeyDown( IN_BACK ) then
			self:GetPhysicsObject():ApplyForceCenter( self:GetForward() * -10000 )
		end

		if self.FlyUser:KeyDown( IN_JUMP ) then
			self:GetPhysicsObject():EnableMotion(false)
		elseif self.FlyUser:KeyDown( IN_WALK ) then
			self:GetPhysicsObject():EnableMotion(true)
		end

				if self.FlyUser:KeyDown( IN_WALK ) then
			self:GetPhysicsObject():ApplyForceCenter( self:GetRight() * 30000 )
			self:GetPhysicsObject():ApplyForceCenter( self:GetForward() * -5950 )
		elseif self.FlyUser:KeyDown( IN_DUCK ) then
			self:GetPhysicsObject():ApplyForceCenter( self:GetRight() * -30000 )
			self:GetPhysicsObject():ApplyForceCenter( self:GetForward() * -5950 )
		end

		if self.FlyUser:KeyDown( IN_MOVERIGHT ) then
			self:GetPhysicsObject():AddAngleVelocity( Vector(0,0,1) * -16 )
		elseif self.FlyUser:KeyDown( IN_MOVELEFT ) then
			self:GetPhysicsObject():AddAngleVelocity( Vector(0,0,1) * 16 )
		end		
		
		--Apply height
		local velVec = self:GetPhysicsObject():GetVelocity()
		local yDiff = self.FloatHeight - self:GetPos().z
		
		self:GetPhysicsObject():ApplyForceCenter( Vector(0,0,1) * yDiff * 100 )
		self:GetPhysicsObject():ApplyForceCenter( Vector(0,0,velVec.z * -20)) --Smooth out the vel to prevent oscilations
		if !self:HasDriver() then
			self:GetPhysicsObject():ApplyForceCenter( Vector(0,0,velVec.z * -2000))
		end

		if yDiff > 70 then
			self.FloatHeight = self.FloatHeight - (yDiff - 10)
		end
		
		
		--In air anti slide
		local adder = 200
		local dotmul = velVec:Dot(self:GetRight())
		local sum = dotmul * adder

		-- local adder = 200
		-- local dotmul = velVec:Dot(self:GetRight())
		-- local sum = dotmul * adder
		
		
		if sum < 0 then
			sum = sum * -1
		end

		self:GetPhysicsObject():ApplyForceCenter(  self:GetForward() * sum * 0.2  - self:GetRight() * adder * dotmul ) 
	
	end
end

function ENT:DoGravity( d )
	self:GetPhysicsObject():EnableGravity( d )
	self.Entity:EmitSound("weapons/slam/mine_mode.wav")
	for i = 1, self.NrOfWheels do
		if IsValid(self.Wheels[i]) then
			self.Wheels[i]:GetPhysicsObject():EnableGravity( d )
		end
	end
	
	for i = 1, self.NrOfSeats do
		if IsValid(self.Seats[i]) then
			self.Seats[i]:GetPhysicsObject():EnableDrag(d)	
		end
	end
	
	self.StabilizerProp:GetPhysicsObject():EnableGravity(d)	
end

function ENT:SpecialRemove()
	if self.TimeLeapState == 2 then
		self:StopTimeTravel()
	end
end

function ENT:SpecialReposition()
	if (SERVER) then	
		if IsValid(self.StabilizerPropFly) then
			self.StabilizerPropFly:SetPos(self.Entity:GetPos() + self.StabiliserOffset.x * self.Entity:GetForward() + self.StabiliserOffset.y * self.Entity:GetRight() + self.StabiliserOffset.z * self.Entity:GetUp() )
			self.StabilizerPropFly:SetAngles(self.Entity:GetAngles())
		end		
	end
end

----------------------------------------------------------------



-- function ENT:SetupDataTables()
-- 	self:NetworkVar("String",	0, "Destination")
-- 	self:NetworkVar("String",	1, "WorkshopID")
-- 	self:NetworkVar("Int",		0, "MapProgress")
-- end

-- function ENT:ToProgressMask(mapname)
-- 	local col, total = progress.GetMapShardCount(mapname)
-- 	if not total or total == 0 then return 0 end

-- 	return bit.bor(bit.lshift(total, 16), col)
-- end

-- function ENT:FromProgressMask(val)
-- 	local mask = bit.lshift(1, 16) - 1
-- 	return bit.band(val, mask),
-- 		bit.band(bit.rshift(val, 16), mask)
-- end

-- function ENT:SetMap(mapname, workshopID)
-- 	self:SetDestination(mapname)
-- 	self:SetWorkshopID(workshopID)
-- 	self:SetMapProgress(self:ToProgressMask(mapname))
-- end

-- function ENT:UpdateDestinationMaterial()
-- 	JazzRenderDestinationMaterial(self, self:GetDestination())
-- end

-- if CLIENT then
-- 	net.Receive("mapmessagedeloreano", function (len)
-- 	local mapname = net.ReadString()
-- 	print (mapname)
-- 	print ("map received on delorean")
-- 	end)
-- 	end


	--	elseif self.TimeLeapState == 2 and SCarKeys:KeyWasReleased(driver, "ToggleHeadlights") then

--		ent.JazzBus = busD
--		local mapname = busD:GetDestination()
--		mapcontrol.Launch(mapcontrol.mapname())
