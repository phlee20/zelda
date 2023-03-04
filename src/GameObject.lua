--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid
    self.consumable = def.consumable or false

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    -- velocity
    self.dx = 0
    self.dy = 0

    -- default empty collision callback
    self.onCollide = function() end

    -- default empty consume callback
    self.onConsume = function() end
end

function GameObject:update(dt)

end

function GameObject:trackPlayer(target)
    self.x = target.x
    self.y = target.y - target.offsetY * 2
end

function GameObject:throw(target)
    if target.direction == 'left' then
        self.dx = -65
        self.dy = 0
    elseif target.direction == 'right' then
        self.dx = 65
        self.dy = 0
    elseif target.direction == 'up' then
        self.dx = 0
        self.dy = -65
    else
        self.dx = 0
        self.dy = 65
    end
    
    local newX = self.x + self.dx
    local newY = self.y + self.dy

    Timer.tween(0.2, {
        [self] = {x = newX, y = newY}
    })
end

function GameObject:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
        self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end