local GUI = {}
local Player = require("player")

function GUI:load()
    self.coins = {}
    self.coins.img = love.graphics.newImage("sprites/kenney_pixelplatformer/Tiles/tile_0151.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.x = love.graphics.getWidth() - 200
    self.coins.y = 40
    self.coins.scale = 3

    self.hearts = {}
    self.hearts.img = love.graphics.newImage("sprites/kenney_pixelplatformer/Tiles/tile_0044.png")
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 30
    self.hearts.scale = 3
    self.hearts.spacing = self.hearts.width * self.hearts.scale + 30

    self.font = love.graphics.newFont("assets/depixel/DePixelBreit.ttf", 24)
end

function GUI:update(dt)

end

-- Draws the hearts and coin counter
function GUI:draw()
    self:displayCoins()
    self:coinText()
    self:displayHearts()
end

-- Heart position and image
function GUI:displayHearts()
    for i=1,Player.health.current do
        local x = self.hearts.x + self.hearts.spacing * i
        love.graphics.draw(self.hearts.img, x, self.hearts.y, 0, self.hearts.scale, self.hearts.scale) 
    end
end

-- Coin counter position and image
function GUI:displayCoins()
    love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0, self.coins.scale, self.coins.scale)
    local x = self.coins.x + self.coins.width * 2
    local y = self.coins.y + self.coins.height
    love.graphics.print(" : "..Player.coins, x, y)
end

-- Text for coin counter
function GUI:coinText()
    love.graphics.setFont(self.font)

end

return GUI 