
local Player = {}
local anim8 = require("libraries.anim8")

function Player:load()
    self.x = 50
    self.y = 315
    self.spawnX = self.x
    self.spawnY = self.y
    self.width = 18
    self.height = 18
    self.xVel = 0
    self.yVel = 0
    self.maxSpeed = 150
    self.acceleration = 4000
    self.friction = 3500
    self.gravity = 1500
    self.jumpAmount = -400
    self.coins = 0
    self.health = {current = 3, max = 3}

    self.alive = true
    self.doubleJump = true
    self.grounded = false

    self.physics = {}
    self.physics.body = love.physics.newBody(World, self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)

    self.spriteSheet = love.graphics.newImage("sprites/kenney_pixelplatformer/characters/spritesheet.png")
    self.grid = anim8.newGrid( 24, 24, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.right = anim8.newAnimation(self.grid("3-4", 1), 0.2)
    self.animations.left = anim8.newAnimation(self.grid("1-2", 1), 0.2)

    self.anim = self.animations.right 

end

-- Damages the player
function Player:takeDmg(amount)
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
    else
            self.health.current = 0
            self:die()
    end
    print("Player Health: "..self.health.current)
end

-- Kills the player
function Player:die()
    print("Player Died")
    self.alive = false
end

-- Respawn the player after health reaches 0
function Player:respawn()
    if not self.alive then 
       self.physics.body:setPosition(self.spawnX, self.spawnY) 
       self.health.current = self.health.max
       self.alive = true
    end
end

-- Add coin(s) to coin count
function Player:incrementCoins()
    self.coins = self.coins + 1
end

-- Update player info
function Player:update(dt)
    self:respawn()
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
end

-- Make sure the player falls down when in the air
function Player:applyGravity(dt)
    if not self.grounded then
        self.yVel = self.yVel + self.gravity * dt
    end
end

-- Player movement left and right
function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
        if self.xVel < self.maxSpeed then
            if self.xVel + self.acceleration * dt < self.maxSpeed then
                self.xVel = self.xVel + self.acceleration * dt
                self.anim = self.animations.right
            else
                self.xVel = self.maxSpeed
            end
        end
    elseif love.keyboard.isDown("a", "left") then
        if self.xVel > -self.maxSpeed then
            if self.xVel - self.acceleration * dt > -self.maxSpeed then
                self.xVel = self.xVel - self.acceleration * dt
                self.anim = self.animations.left
            else
                self.xVel = -self.maxSpeed
            end
        end
    else
        self:applyFriction(dt)
    end
end

-- Applies friction
function Player:applyFriction(dt)
    if self.xVel > 0 then
        if self.xVel - self.friction * dt > 0 then
            self.xVel = self.xVel - self.friction * dt
        else
            self.xVel = 0
        end
    elseif self.xVel < 0 then
        if self.xVel + self.friction * dt < 0 then
            self.xVel = self.xVel + self.friction * dt
        else
            self.xVel = 0
        end
    end
end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.xVel, self.yVel)
end

-- Checks if player is in contact with object/ground
function Player:beginContact(a, b, collision)
    if self.grounded == true then return end
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        end
    elseif b == self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        end
    end
end

-- Checks if the player has landed
function Player:land(collision)
    self.currentGroundCollision = collision
    self.yVel = 0
    self.grounded = true
    self.doubleJump = true
end

-- Jumping
function Player:jump(key)
    if (key == "w" or key == "up") and self.grounded then
            self.yVel = self.jumpAmount
            self.grounded = false
    end
end

-- Checks if player isn't in contact with object/ground
function Player:endContact(a, b, collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.currentGroundCollision == collision then
            self.grounded = false
        end
    end
end

-- Draws the player
function Player:draw()
    self.anim:draw(self.spriteSheet, self.x, self.y)
end

return Player