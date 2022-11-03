-- Import of push library to make virtual resolution
push = require 'push'

-- Import of class library to make objects
Class = require 'class'

-- Import the games objects
require 'Paddle'
require 'Ball'

-- Windows proportion
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution, that goin to render the game's object
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Constant to determine the speed of the paddle
PADDLE_SPEED = 200

function love.load()
    -- Set one filter to render
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- Add um title to game window
    love.window.setTitle('Pong')

    -- Library to use random 
    math.randomseed(os.time())

    -- Fonts to use on game
    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Chooce the font to use
    love.graphics.setFont(smallFont)

    -- A table that stores the sounds of the game
    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- Setup of screen
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    -- Variable that store player's points
    player1Score = 0
    player2Score = 0

    -- Variable to determine player's turn
    servingPlayer = 1

    -- Instances of players and ball
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)

    -- Variable to determine player winner
    winningPlayer = 0

    -- State start
    gameState = 'start'
end

-- Function to resize window
function love.resize(w, h)
    push:resize(w, h)
end

-- Update function, that render each frame's game
function love.update(dt)
    -- Game serve state
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(140, 200)
        else
            ball.dx = -math.random(140, 200)
        end
    -- Game play state
    elseif gameState == 'play' then
        -- Ball collide at Player 1 
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5
            
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            -- Sound played when hit one player
            sounds['paddle_hit']:play()
        end
        -- Ball collide at Player 2
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4
            
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end
        
        -- Ball collide at header wall
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end
        
        -- Ball collide footer wall
        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        -- Player 2 making point
        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()

            -- Check if player 2 win
            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        -- Player 1 making point
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            -- Check if player 1 win
            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end
    end

    -- Player 1 moviment control
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player 2 moviment control
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- Lauching the ball
    if gameState == 'play' then
        ball:update(dt)
    end

    -- Updating players
    player1:update(dt)
    player2:IA(dt, ball)
end

-- Waiting for a key to be pressed at any time during the game
function love.keypressed(key)
    -- When this key is escape, close the game
    if key == 'escape' then
        love.event.quit()

    -- When this key is enter or return, play the game or change to serve state
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        -- Done state. When any player win. Reset the counters
        elseif gameState == 'done' then
            gameState = 'serve'

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end
end

-- Function to draw the elements of game
function love.draw()
    -- Using the push library to render the resolution
    push:start()

    -- Cleaning background game
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- UI messages in start state
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    
    -- UI messages in serve state
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf(
            'Player ' .. tostring(servingPlayer) .. "'s serve!",
            0,
            10,
            VIRTUAL_WIDTH,
            'center'
        )
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    
    -- no UI messages to display in play
    elseif gameState == 'play' then
        
    -- UI messages in done state
    elseif gameState == 'done' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player' .. tostring(winningPlayer) .. ' wins!', 
        0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    -- Called of function that render display score
    displayScore()

    -- Render of game elements
    player1:render()
    player2:render()
    ball:render()

    -- Called of function that render display FPS
    displayFPS()

    -- Close of push rendering
    push:finish()
end

-- Function that render one couter of game's FPS
function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255/255, 0, 255/255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)
end

-- Function that render one couter of game's players points
function displayScore()
    -- Choose font
    love.graphics.setFont(scoreFont)
    
    -- Player 1's points
    love.graphics.print(
        tostring(player1Score),
        VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3
    )
    
    -- Player 2'Points
    love.graphics.print(
        tostring(player2Score),
        VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3
    )
end