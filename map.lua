local Map = {}
local sti = require("libraries.sti")
local Coin = require("coin")
local Spike = require("spike")
local Player = require("player")

-- Loads the map
function Map:load()
    self.level = sti("maps/pixelplatformer.lua", {"box2d"}) -- Load a map exported to Lua from Tiled
    World = love.physics.newWorld(0,0) -- Prepare physics world with horizontal and vertical gravity 
    World:setCallbacks(beginContact, endContact)
    self.level:box2d_init(World) -- Prepare collision objects
    self.solidLayer = self.level.layers.solid
    self.groundLayer = self.level.layers.Ground
    self.entityLayer = self.level.layers.entity
    self.solidLayer.visible = false
    self.entityLayer.visible = false
    MapWidth = self.groundLayer.width * 18

    self:spawnEntities()
end
-- Spawns all entities, not player
function Map:spawnEntities()
	for i,v in ipairs(self.entityLayer.objects) do
		if v.class == "spikes" then
			Spike.new(v.x + v.width / 2, v.y + v.height / 2)
		elseif v.class == "coin" then
			Coin.new(v.x, v.y)
		end
	end
end

return Map