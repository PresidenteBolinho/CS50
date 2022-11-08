-- Import Class library to OOP
Paddle = Class{}

-- Function that init the class
function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dy = 0
end

-- Updating Paddle position
function Paddle:update(dt)
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

-- Function that criate a simple IA
-- The delta variable becomes that of the ball, since the player's objective is
-- to move the paddle behind the ball. In the tests, the behavior was satisfactory,
-- not preventing the player from winning, much less nullifying the possibility of
-- losing to AI
function Paddle:IA(dt, ball)
    if self.dy <= ball.dy then
        self.y = math.max(0, self.y + ball.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + ball.dy * dt)
    end
end

-- Render paddle on screen
function Paddle:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end