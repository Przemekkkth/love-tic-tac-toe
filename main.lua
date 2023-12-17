require 'TitTacToe'

function love.load()
    love.window.setMode(BOARD_SIZE.x, BOARD_SIZE.y)
    m_tictactoe = TicTacToe()
end

function love.update(dt)
    m_tictactoe:update(dt)
    love.window.setTitle("LOVE TicTacToe Current Player: "..m_tictactoe:currentPlayer().." Steps: "..m_tictactoe:gameSteps())
end

function love.draw()
    m_tictactoe:draw()
end

function love.keyreleased(key)
    if key == "escape" then
       love.event.quit()
    elseif key == "z" then
        m_tictactoe = TicTacToe()
    end
 end