--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdlePotState = Class{__includes = EntityIdleState}

function PlayerIdlePotState:enter(params)
    self.entity:changeAnimation('pot-idle-' .. self.entity.direction)

    -- render offset for spaced character sprite (negated in render function of state)
    self.entity.offsetY = 5
    self.entity.offsetX = 0

    -- track object with player
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.state == 'lifted' then
            self.object = object
        end
    end
end

function PlayerIdlePotState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or
       love.keyboard.isDown('up') or love.keyboard.isDown('down') then
            self.entity:changeState('walk-pot')
    end

    self.object:trackPlayer(self.entity)

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.object:throw(self.entity)
        self.entity:changeState('idle')
    end

end