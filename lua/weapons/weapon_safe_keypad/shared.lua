if (SERVER) then
	AddCSLuaFile("shared.lua");
	
	SWEP.Weight				= 5;
	SWEP.AutoSwitchTo		= false;
	SWEP.AutoSwitchFrom		= false;
end

if (CLIENT) then
	SWEP.PrintName			= "Safe keypad cracker";
	SWEP.Instructions		= "Aim on the safe and crack!";
	SWEP.DrawAmmo			= false;
	SWEP.ViewModelFOV		= 55;
	SWEP.ViewModelFlip		= false;
	SWEP.Slot 				= 3;
	SWEP.SlotPos			= 2;
	SWEP.Author					= "Haru"
	SWEP.Purpose				= "Open advancedsafes with this advanced tool!"
	
end;

SWEP.Base 					= "weapon_base";

SWEP.Spawnable				= true;
SWEP.AdminSpawnable			= true;
SWEP.Category				= "Safe"

SWEP.ViewModel = Model("models/weapons/v_c4.mdl")
SWEP.WorldModel = Model("models/weapons/w_c4.mdl")

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= -1;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Ammo			= "none";

SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "none";


function SWEP:Initialize()

	self:SetHoldType( "slam" )

end

function SWEP:Reload()
end

function SWEP:AttemptToCrack(ent, with)
	DarkRP.notify(self.Owner, 4, 3, "Attempting to crack...")
	timer.Simple(1, function()
		ent:TriggerChance()
		ent:EmitSound("npc/scanner/combat_scan"..math.random(1,5)..".wav")
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

	self:SetNextPrimaryFire( CurTime() + 2 )

	
	if ( !SERVER ) then return end
	
	local openEnt = self.Owner:GetEyeTrace().Entity
	
	if ( openEnt ) then
		
		if openEnt:GetPos():Distance(self.Owner:GetPos()) >= 150 then return end
		
		local this = "keypad" // What is this?
		
		if openEnt.Safe.CanBeOpenedWith[this] == true then
			if openEnt.Safe.OpenedWith[this] == openEnt.Safe.ToOpenedWith[this] then
				DarkRP.notify(self.Owner, 1, 4, "This safe's locks have already been cracked!")
			else
				self:AttemptToCrack(openEnt, this)
			end
		end
	end

end


function SWEP:SecondaryAttack()

end
