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

    self.player:changeAnimation('pot-lift-' .. self.player.direction)
end

function PlayerLiftPotState:enter(params)
    self.player.currentAnimation:refresh()

end

function PlayerLiftPotState:update(dt)

    -- if we've fully elapsed through one cycle of animation, change to walk-pot state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle-pot')
    end
end

function PlayerLiftPotState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))
end