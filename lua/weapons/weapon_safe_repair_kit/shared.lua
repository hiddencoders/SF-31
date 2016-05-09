if (SERVER) then
	AddCSLuaFile("shared.lua");
	
	SWEP.Weight				= 5;
	SWEP.AutoSwitchTo		= false;
	SWEP.AutoSwitchFrom		= false;
end

if (CLIENT) then
	SWEP.PrintName			= "Repair Kit";
	SWEP.Instructions		= "Aim on the safe and repair it!!";
	SWEP.DrawAmmo			= false;
	SWEP.ViewModelFOV		= 55;
	SWEP.ViewModelFlip		= false;
	SWEP.Slot 				= 3;
	SWEP.SlotPos			= 2;
	SWEP.Author					= "Haru"
	SWEP.Purpose				= "Fixed cracked safes with this!"
	
end;

SWEP.Base 					= "weapon_base";

SWEP.Spawnable				= true;
SWEP.AdminSpawnable			= true;
SWEP.Category				= "Safe"

SWEP.ViewModel = Model("models/weapons/c_crowbar.mdl")
SWEP.WorldModel = Model("models/weapons/w_crowbar.mdl")

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= -1;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Ammo			= "none";

SWEP.Secondary.ClipSize		= -1;
SWEP.Secondary.DefaultClip	= -1;
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "none";


function SWEP:Initialize()

	self:SetHoldType( "pistol" )

end

function SWEP:Reload()
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + 5 )

	
	if ( !SERVER ) then return end
	
	local openEnt = self.Owner:GetEyeTrace().Entity
	
	if ( openEnt ) then
		
		if openEnt:GetPos():Distance(self.Owner:GetPos()) >= 150 then return end
		
		if openEnt.Safe then
			DarkRP.notify(self.Owner, 2, 5, "Repaired "..openEnt.PrintName.." !")
			openEnt:Repair()
		end
	end

end


function SWEP:SecondaryAttack()

end
