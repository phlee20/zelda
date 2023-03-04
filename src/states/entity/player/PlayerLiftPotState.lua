--[[
    GD50
    Legend of Zelda

    -- Player Lift Pot State
]]

PlayerLiftPotState = Class{__includes = BaseState}

function PlayerLiftPotState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    self.player.offsetY = 5
    self.player.offsetX = 0

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 2
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 2
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 2
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 2
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    -- separate hitbox for the player's sword; will only be active during this state
    self.liftHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    self.lifting = false
    --self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerLiftPotState:enter(params)

    self.player.currentAnimation:refresh()

end

function PlayerLiftPotState:update(dt)
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object:collides(self.liftHitbox) then
            self.lifting = true
            object.state = 'lifted'
        end
    end

    if self.lifting then
        self.player:changeAnimation('pot-lift-' .. self.player.direction)
        -- if we've fully elapsed through one cycle of animation, change to walk-pot state
        if self.player.currentAnimation.timesPlayed > 0 then
            self.player.currentAnimation.timesPlayed = 0
            self.player:changeState('idle-pot')
        end
    else
        self.player:changeState('idle')
    end
end

function PlayerLiftPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end