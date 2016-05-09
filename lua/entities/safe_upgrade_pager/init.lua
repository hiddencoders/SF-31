AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()	
	self:SetModel("models/props_lab/reciever01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid() then phys:Wake() end
	
end

function ENT:Use(activator,caller)
	if activator:IsPlayer() then
		DarkRP.notify(activator, 1, 4, "This is an upgrade that installs a Pager to your safe! It alerts you and the police silently when triggered!")
	end
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
	local entid = self.ClassName --or "chem_base"
    local ent = ents.Create( entid )
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 ) 
    ent:Spawn()
    ent:Activate()
    return ent
end