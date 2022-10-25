-- Estas são duas variaveis contantes que representam o tamanho da janela do jogo
-- tanto em questão de altura quanto de largura
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Função responsável por executar o game. É executada apenas uma vez para iniciar o jogo
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

-- Chamado após atualização do Love2d. Tem a função de desenhar as coisas na tela, atualizado ou não.
function love.draw()
    love.graphics.printf(
        'Hello Pong!',
        0,
        WINDOW_HEIGHT / 2 - 6,
        WINDOW_WIDTH,
        'center'
    )
end