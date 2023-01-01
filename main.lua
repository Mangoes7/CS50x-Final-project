-- Sprites and background from Kenney/www.kenney.nl
-- Font by Ingo Zimmermann

love.graphics.setDefaultFilter("nearest", "nearest")

local Player = require("player")
local Coin = require("coin")
local GUI = require("gui")
local Spike = require("spike")
local Map = require("map")
local Camera = require("camera")

-- Loads other files and background
function love.load()
    Map:load()
    success = love.window.setFullscreen(true, "desktop") -- Adjust window to screen size
    background = love.graphics.newImage("backgrounds/bg_grasslands.png")
    GUI:load()
    Player:load()
end

-- Updates game with other files
function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    Spike.updateAll(dt)
    GUI:update(dt)
    Camera:setPosition(Player.x, 0)
end

-- Drawing background and other files
function love.draw()
    local width, height = love.window.getMode()
    love.graphics.draw(background, 0, 0, 0, width/background:getWidth(), height/background:getHeight()) -- Adjust background to screen size
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)

    Camera:apply()
    Player:draw()
    Coin.drawAll()
    Spike.drawAll()
    Camera:clear()

    GUI:draw()
end

-- Jumping
function love.keypressed(key)
    Player:jump(key)
end

-- Contact with player/entities
function beginContact(a, b, collision)
    if Coin.beginContact(a, b ,collision) then return end
    if Spike.beginContact(a, b ,collision) then return end
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end

