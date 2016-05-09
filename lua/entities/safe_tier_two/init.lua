AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()	
	self:SetModel("models/props_vtmb/safe.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
	
	self.Weight = 500
	
	self:SetAmount(0)
	
	
		self.Safe = {}
		self.Safe.CanBeOpenedWith= {}
		self.Safe.OpenedWith= {}
		self.Safe.ToOpenedWith= {}
		self.Safe.Opened = {}
		self.Safe.NeedToBeOpened = {}
		self.Safe.Upgrades = {}

		self.Safe.OpenedWith["crowbar"] = 0
		self.Safe.OpenedWith["blowtorch"] = 0
		self.Safe.OpenedWith["keypad"] = 0
		
		self.Safe.Upgrades["safe_upgrade_storage"] = false		// Remove one to disable installing the module
		self.Safe.Upgrades["safe_upgrade_interest"] = false
		self.Safe.Upgrades["safe_upgrade_lock"] = false
		self.Safe.Upgrades["safe_upgrade_keypad"] = false
		self.Safe.Upgrades["safe_upgrade_alarm"] = false
		self.Safe.Upgrades["safe_upgrade_pager"] = false
		
		self.Safe.NeedToBeOpened["__MAX"] = 2 --[[number of values in NeedToBeOpened, because we are lazy.]]

		self.Safe.CanBeOpenedWith["crowbar"] = true			// Can you open it with: "crowbar", "keypad cracker", "blowtorch"
		self.Safe.CanBeOpenedWith["keypad"] = true			
		self.Safe.CanBeOpenedWith["blowtorch"] = true
		self.Safe.ToOpenedWith["crowbar"] = {3,9}			// How many times you have to try open the safe {minimum, maximum} with this. If it's between you MIGHT get it open. Keep the curly brackets!
		self.Safe.ToOpenedWith["keypad"] = {1,5}
		self.Safe.ToOpenedWith["blowtorch"] = {1,1}
		self.Safe.NeedToBeOpened["crowbar"] = true			// What locks must be breached in order to open it? [Disredards blowtorch]
		self.Safe.NeedToBeOpened["keypad"] = true	
		
		self.InterestRate = 4							// Interest rate in percentage
		self.InterestTime = 60							// Intervallum between interest gains
		
		self.AlarmSound = CreateSound(self, "ambient/alarms/alarm1.wav")
		
		sound.Add( {
			name = "safe_alarm",
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 80,
			pitch = { 255, 255 },
			sound = "ambient/alarms/combine_bank_alarm_loop4.wav"
		} )
		
	timer.Simple(0.05, function() self:SetPos(self:GetPos() + Vector(0, 0, 40)) end)
	timer.Create("safe_interest_"..self:EntIndex(), self.InterestTime, 0, function() if self:IsValid() then self:Interest() end end )
	timer.Simple(0.1, function() if self:IsValid() then self:SetMaxStorage(self.MaxStorage) end end )
	--timer.Simple(0.1, function() if self:IsValid() then self:SetModelScale( self:GetModelScale() * 0.75, 0 ) end end)
end

function ENT:Use(activator,caller)
	if activator == self:Getowning_ent() then
		if self.Safe.Cracked then DarkRP.notify(activator, 1, 5, "Your safe has been cracked!") return "" else
			self:Door()
			if self:GetAmount()==0 then DarkRP.notify(activator, 0, 2, "Your safe is empty!") return end
			activator:addMoney(self:GetAmount())
			DarkRP.notify(activator, 2, 2, "You have recovered ".. self:GetAmount().."$ from the safe!")
			self:SetAmount(0)
		end
	else
		DarkRP.notify(activator, 1, 2, "You don't have access to this safe!")
	end

end

function ENT:Door()
	if self:IsValid() then
		self:SetBodygroup(1,1)
		self:EmitSound("buttons/lever"..math.random(1,6)..".wav")
		timer.Simple(5, function() 
			if self:IsValid() then
				self:SetBodygroup(1,0)
				self:EmitSound("buttons/lever"..math.random(1,6)..".wav")
			end
		end)
	end
end

function ENT:Upgrade(with)
	if !with then return end
	
	print("Upgrading with: "..with)
	
	if with == "safe_upgrade_storage" then
		self:SetMaxStorage(self:GetMaxStorage() * 1.20)
	end
	if with == "safe_upgrade_interest" then
		self.InterestRate = self.InterestRate * 2
	end
	if with == "safe_upgrade_lock" then
		self.Safe.ToOpenedWith["crowbar"][1] = math.Round(self.Safe.ToOpenedWith["crowbar"][1] * 1.5)
		self.Safe.ToOpenedWith["crowbar"][2] = math.Round(self.Safe.ToOpenedWith["crowbar"][2] * 2)
	end
	if with == "safe_upgrade_keypad" then
		self.Safe.ToOpenedWith["keypad"][1] = math.Round(self.Safe.ToOpenedWith["keypad"][1] * 1.5)
		self.Safe.ToOpenedWith["keypad"][1] = math.Round(self.Safe.ToOpenedWith["keypad"][1] * 2)
	end
	if with == "safe_upgrade_pager" then
		self.Safe.AllowPager = true
	end
	if with == "safe_upgrade_alarm" then
		print("Would upgrade!")
		self.Safe.AllowAlarm = true
	end
end

function ENT:Crack(ply, with)
	self:EmitSound("buttons/lever"..math.random(1,6)..".wav")	
	self.Safe.Opened[with] = true
	
	local check = 0
	
	for k, v in pairs(self.Safe.Opened) do
		if v == true and self.Safe.NeedToBeOpened[k] == true then
			check = check + 1
		end
	end
	
	if (self.Safe.NeedToBeOpened["__MAX"] == check) or with == "blowtorch" then
		self:SetColor(Color(255,255,255,255))
		if self:GetAmount() == 0 then 
			DarkRP.notify(ply, 1, 4, "The safe is empty!")
		else
			ply:addMoney(self:GetAmount())
			DarkRP.notify(ply, 2, 5, "You have recovered ".. self:GetAmount().."$ from the safe!")
			self:SetAmount(0)
		end
		
		self.Safe.Cracked = true
		self:SetBodygroup(1,1)
	else
		
		self:SetColor(Color(175, 75, 75, 255))
		DarkRP.notify(ply, 1, 10, "There is another lock you need to breach!")
		
	end
end

function ENT:Alarm(toggle)
	print("Alarm trigger? ", toggle, " Canwe? ", self.Safe.AllowAlarm)
	if self.Safe.AllowAlarm != true then return end
	print("Alarm trigged succesfully!")
	if toggle == true then
		self.AlarmSound:Play()
		--sound.Play("ambient/alarms/combine_bank_alarm_loop4.wav", self:GetPos(), 75, 255)
	elseif toggle == false then
		self.AlarmSound:Stop()
		--self:StopSound("safe_alarm")
	else
		return
	end
end

function ENT:Pager(time)
	if !time then return end
	if time == "__off" then
		self:SetPager(false)
		return
	end
	if self:GetPager() == true then return end
	if self.Safe.AllowPager != true then return end
	
	self:SetPager(true)
	
	for k, v in pairs(player.GetAll()) do
		if v:isCP() then
			DarkRP.notify(v, 2, 10, self:Getowning_ent():Nick() .."'s safe is being cracked!")
		end
		if v == self:Getowning_ent() then
			DarkRP.notify(v, 2, 10, "Your safe is being cracked!")
		end
	end
	
	timer.Simple(time, function() if self:IsValid() then self:SetPager(false) end end)
end

function ENT:TriggerChance()
	print("Attempting trigger!")
	if math.random(1, 3) == 3 then return end
		print("Success!")
		self:Alarm(true)
		self:Pager(85)
	
	-- 33% chance to succeed
end

function ENT:Repair(ply)
	for k, v in pairs(self.Safe.Opened) do
		self.Safe.Opened[k] = nil
	end
	for k, v in pairs(self.Safe.OpenedWith) do
		self.Safe.OpenedWith[k] = 0
	end
	self.Safe.Cracked = false
	self:SetColor(Color(255,255,255,255))
	self:SetBodygroup(1,0)
	self:SetPager(false)
	self:Alarm(false)
end

function ENT:Interest()
	local am = self:GetAmount()
	local rate = self.InterestRate/100
	local plus = math.Round(am*rate)
	self:SetAmount(math.Clamp(am+plus, 0, self:GetMaxStorage()))
	if self:GetAmount() == self:GetMaxStorage() then DarkRP.notify(self:Getowning_ent(), 1, 4, "Your safe is full and can't produce any more interest!") end
end

function ENT:StartTouch(ent)
	if self.CheckingSafe == true or self.Safe.Cracked then return end
	if ent:GetClass() == "spawned_money" then
		self.CheckingSafe = true
		local now = self:GetAmount()
		local mon = ent:Getamount() 
		print(mon)
		if now + mon > self:GetMaxStorage() then
			self:SetAmount(self:GetMaxStorage())
			ent:Setamount(mon-(self:GetMaxStorage()-now))
		else
			self:SetAmount(self:GetAmount() + (ent:Getamount()))
			ent:Remove()
		end
	end
	if self.Safe.Upgrades[ent:GetClass()] == false then
		self:Upgrade(ent:GetClass())
		ent:Remove()
		self.Safe.Upgrades[ent:GetClass()] = true
		self:EmitSound("buttons/blip1.wav")
	end
	self.CheckingSafe = false
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
	local entid = self.ClassName --or "chem_base"
    local ent = ents.Create( entid )
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
	ent:SetModelScale( ent:GetModelScale() * 0.75, 0 ) 
    ent:Activate()
	timer.Simple(0.1, function() if ent:IsValid() then ent:Setowning_ent(ply) end end )
    return ent
end

function ENT:OnRemove()
	self:Alarm(false)
	self:Pager("__off")
end