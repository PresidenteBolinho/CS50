-- Aqui, é importado uma biblioteca lua chamada push
-- Ela nos permite criar uma resolução virtual que preencherá toda a tela
-- Ajudando a manter uma visual mais retro ao jogo
push = require 'push'

-- Resolução final do jogo
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


-- Resolução virtual do jogo
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Função que carrega as configurações do jogo
function love.load()
    -- Aqui, é usado um filtro do Love2D para ajudar a manter o visual retro
    love.graphics.setDefaultFilter('nearest')

    -- Agora, não usamos mais o Love2D para carregar as configurações da janela, mas sim
    -- a biblioteca push, pois ela será responsável por criar a resolução virtual
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Vamos usar agora, uma outra função do Love2D chamada keypressed, que ficará acompanhando
-- quais teclas são precionada enquanto o jogo roda
function love.keypressed(key)
    -- Usamos de uma condição para caso uma determinada tecla seja pressionada, executar uma ação
    if key == 'escape' then
        -- Se a tecla escape for pressionada, então o jogo fecha
        love.event.quit()
    end
end

-- Função com o objetivo de desenhar os componentes na tela
function love.draw()

    push:apply('start')

    -- Agora, é usado a resolução virtual ao invés da resolução final
    love.graphics.printf(
        'Hello Pong!',
        0,
        VIRTUAL_HEIGHT / 2,
        VIRTUAL_WIDTH,
        'center'
    )

    push:apply('end')
end