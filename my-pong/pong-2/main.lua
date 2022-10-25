-- Importação da biblioteca push
push = require 'push'

-- Definição da resolução
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Definição da resolução virtual
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Carregamento das configurações do jogo
function love.load()
    -- Uso de um filtro para melhorar a qualidade da resolução virtual
    love.graphics.setDefaultFilter('nearest')

    -- Escolha da fonte que será usada
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- Uso da fonte escolhida
    love.graphics.setFont(smallFont)

    -- Configurações da tela
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Função para capturar os eventos de pressionar teclas
function love.keypressed(key)
    -- Evento de sair do jogo caso ESC seja pressionada
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    -- Função onde determina o inicio da renderização virtual
    push:apply('start')

    -- Função manipula a cor do fundo do jogo
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- Escreve Hello Pong! na tela
    love.graphics.printf(
        'Hello Pong!',
        0,
        20,
        VIRTUAL_WIDTH,
        'center'
    )

    -- Desenha o retangulo que representa o player 1 no lado esquerdo da tela
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- Desenha o retangulo que representa o player 2 no lado direito da tela
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- Desenha o retangulo que representa a bola no centro da tela
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2, 5, 5)

    -- Função que determina o fim da renderização virtual
    push:apply('end')
end