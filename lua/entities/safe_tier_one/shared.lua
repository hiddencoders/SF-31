ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Tier I Safe"
ENT.Author = "Haru"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Roleplay"

ENT.UseCoolMenu = true							// Use model-based menu. You need to calibrate this if you switch models.
ENT.MaxStorage = 20000							// Maximum money that can be stored

function ENT:ResetOpenedValues()
	self.Safe.OpenedWith["crowbar"] = 0
	self.Safe.OpenedWith["blowtorch"] = 0
	self.Safe.OpenedWith["keypad"] = 0
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Float", 0, "Amount")
	self:NetworkVar("Float", 1, "MaxStorage")
	self:NetworkVar("Bool", 0, "Pager")
end