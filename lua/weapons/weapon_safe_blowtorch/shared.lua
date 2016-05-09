if (SERVER) then
	AddCSLuaFile("shared.lua");
	
	SWEP.Weight				= 5;
	SWEP.AutoSwitchTo		= false;
	SWEP.AutoSwitchFrom		= false;
end

if (CLIENT) then
	SWEP.PrintName			= "Blowtorch";
	SWEP.Instructions		= "Aim on the safe and torch the lock!";
	SWEP.DrawAmmo			= false;
	SWEP.ViewModelFOV		= 55;
	SWEP.ViewModelFlip		= false;
	SWEP.Slot 				= 3;
	SWEP.SlotPos			= 2;
	SWEP.Author					= "Haru"
	SWEP.Purpose				= "Open any safe with this monster!"
	
end;

SWEP.Base 					= "weapon_base";

SWEP.Spawnable				= true;
SWEP.AdminSpawnable			= true;
SWEP.Category				= "Safe"

SWEP.ViewModel = Model("models/weapons/c_irifle.mdl")
SWEP.WorldModel = Model("models/weapons/w_irifle.mdl")

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= -1;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Delay 			= 0.3
SWEP.Primary.Ammo			= "none";

SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "none";

SWEP.Primary.Load			= 0

function SWEP:Initialize()

	self:SetHoldType( "ar2" )

end

function SWEP:Reload()
end

function SWEP:AttemptToCrack(ent, with)
	DarkRP.notify(self.Owner, 4, 3, "Attempting to crack...")
	timer.Simple(1, function()
		ent:TriggerChance()
		ent:EmitSound("ambient/materials/metal_stress"..math.random(1,5)..".wav")
		ent.Safe.OpenedWith[with] = ent.Safe.OpenedWith[with] + 1
		local chance = 0
		local per = 0
		local OpW = ent.Safe.OpenedWith[with] 
		local OpTW = ent.Safe.ToOpenedWith[with] 
		if ent.Safe.OpenedWith[with] >= ent.Safe.ToOpenedWith[with] [1] then
		end
		
		if ent.Safe.OpenedWith[with] >= ent.Safe.ToOpenedWith[with][1] then
			local uno = ent.Safe.OpenedWith[with]
			local dos = ent.Safe.ToOpenedWith[with][2]
			
			local num = dos - uno + 1
			per = math.Round((1/num)*100)
		end
		if false then	//DEBUG
			print("Values: ")
			print("OpW, OpTW; ", OpW, ", ", OpTW[1], OpTW[2])
			print("Chance: " .. per.. "; with actual "..chance)
			print("Possible with: ")
			print("  1.0 ", chance == ent.Safe.ToOpenedWith[with][2])
			print("  1.1 ", ent.Safe.OpenedWith[with] >= ent.Safe.ToOpenedWith[with][2])
			print("  2.0 ", ent.Safe.OpenedWith[with] >= ent.Safe.ToOpenedWith[with][1])
		end
		if ((chance == ent.Safe.ToOpenedWith[with][2]) or ( ent.Safe.OpenedWith[with] >= ent.Safe.ToOpenedWith[with][2] )) and (ent.Safe.OpenedWith[with] >= ent.Safe.ToOpenedWith[with][1]) then
			DarkRP.notify(self.Owner, 4, 3, "Successfully cracked! (Chance: ".. per .."%)")
			ent:Crack(self.Owner, with)
		else
			DarkRP.notify(self.Owner, 1, 4, "Failed to crack! (Chance: ".. per .."%)")
		end
	end)
end



function SWEP:PrimaryAttack()

	--self:SetNextPrimaryFire( CurTime() + 2 )

	
	if ( !SERVER ) then return end
	
	local openEnt = self.Owner:GetEyeTrace().Entity
	
	if ( openEnt ) then
		
		if openEnt:GetPos():Distance(self.Owner:GetPos()) >= 50 then return end
		
		local this = "blowtorch" // What is this?
		if openEnt.Safe.CanBeOpenedWith[this] == true then
			if openEnt.Safe.Opened[this] == true then
				self:SetNextPrimaryFire( CurTime() + 2 )
				DarkRP.notify(self.Owner, 1, 4, "This safe's locks have already been cracked!")
			else
					local effectdatat = EffectData()
					effectdatat:SetOrigin( self.Owner:GetEyeTrace().HitPos )
					effectdatat:SetMagnitude( 2 / 2 )
					effectdatat:SetRadius( 8 - 2 )
					util.Effect( "ManhackSparks", effectdatat, true, true )
					
					self:EmitSound("weapons/stunstick/spark"..math.random(1,3)..".wav")
					self.Primary.Load = self.Primary.Load + 1
				if self.Primary.Load >= math.random(140, 180) then
					self:AttemptToCrack(openEnt, this)
					self.Primary.Load = 0
					self:SetNextPrimaryFire( CurTime() + 2 )
				end
			end
		end
	end

end


function SWEP:SecondaryAttack()

end
