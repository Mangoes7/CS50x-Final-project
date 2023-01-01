local Camera = {
    x = 0,
    y = 0,
    scale = 1.78,
}

-- Scale of camera
function Camera:apply()
    love.graphics.push()
    love.graphics.scale(1.73, 1.72)
    love.graphics.translate(-self.x, -self.y)
end 

function Camera:clear()
    love.graphics.pop()
end

-- Locks camera to map size L/R
function Camera:setPosition(x, y)
    self.x = x - love.graphics.getWidth() / 2 / self.scale
    self.y = y
    local RS = self.x + love.graphics.getWidth() / 1.78
 
    if self.x < 0 then
       self.x = 0
    elseif RS > MapWidth then
       self.x = MapWidth - love.graphics.getWidth() / 1.78
    end
 end

return Camera