-- Importação da biblioteca push, para criar a resolução virtual
push = require 'push'

-- Configuração da resolução
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Configuração da resolução virtual
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Configuração da velocidade do 'remo'
PADDLE_SPEED = 200

-- Configurações iniciais do jogo
function love.load()
    -- Configuração do filtro de imagens
    love.graphics.setDefaultFilter('nearest')

    -- Criação da fonte geral
    smallFont = love.graphics.newFont('font.ttf', 16)

    -- Criação da fonte para os pontos
    scoreFont = love.graphics.newFont('font.ttf', 32)
    
    -- Uso da fonte
    love.graphics.setFont(smallFont)

    -- Configuração da tela
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- Variaveis para armazenar os pontos dos jogadores
    player1Score = 0
    player2Score = 0

    -- Variaveis para armazenar a posição dos jogadores
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end

-- Função para atualizar os itens na tela
function love.update(dt)
    -- Controle do jogador 1
    -- Mover para cima
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt
    -- Mover para baixo
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    -- Controle do jogador 2
    -- Mover para cima
    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
    --Mover para baixo
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end

-- Função para acompanhar os botões apertados em qualquer momento do jogo
function love.keypressed(key)
    -- Fechar do jogo
    if key == 'escape' then
        love.event.quit()
    end
end

-- Função para desenhar componentes na tela
function love.draw()
    -- Inicio da renderização virtual pelo push
    push:apply('start')

    -- Configuração das cores de fundo do jogo
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- Define a fonte que será usada na próxima vez que será escrito algo na tela
    love.graphics.setFont(smallFont)
    -- Escreve na tela Hello Pong!
    love.graphics.printf(
        'Hello Pong!',
        0,
        20,
        VIRTUAL_WIDTH,
        'center'
    )

    -- Define a font em scoreFont para ser usada na próxima vez que for escrito algo na tela
    love.graphics.setFont(scoreFont)
    -- Escreve os pontos do jogador 1 na tela
    love.graphics.print(
        tostring(player1Score),
        VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3
    )
    -- Escreve os pontos do jogador 2 na tela
    love.graphics.print(
        tostring(player2Score),
        VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3
    )

    -- Desenha um retangulo que representa o jogador 1
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    -- Desenha um retangulo que representa o jogador 2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)

    -- Desenha um retangulo que representa a bola
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 4, 4)

    -- Fim da renderização virtual pelo push
    push:apply('end')
end