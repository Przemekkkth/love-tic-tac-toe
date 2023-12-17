Object = require("libraries.classic.classic")
TicTacToe = Object:extend()

local Input = require("libraries.boipushy.Input")

BOARD_SIZE = {x = 768, y = 768}
local PLAYER_TYPE = {
    NONE = 0, O = 10, X = 200, DRAW = 300
}
local COLUMNS = 3
local ROWS    = 3
local CELL_SIZE = {x = BOARD_SIZE.x/3, y = BOARD_SIZE.y/3}

--COLORS
GREEN3     = {.05, .21, .05}--(15 ,  56, 15);
GREEN2     = {.18, .38, .18}--(48 ,  98, 48);
GREEN1     = {.54, .67, .05}--(139, 172, 15);
GREEN0     = {.6,  .73, .05}--(155, 188, 15);

function TicTacToe:new()
    input = Input()
    input:bind('mouse1', 'leftButtonPressed')
    --
    self.m_gameArray = {
        {PLAYER_TYPE.NONE, PLAYER_TYPE.NONE, PLAYER_TYPE.NONE},
        {PLAYER_TYPE.NONE, PLAYER_TYPE.NONE, PLAYER_TYPE.NONE},
        {PLAYER_TYPE.NONE, PLAYER_TYPE.NONE, PLAYER_TYPE.NONE}
    }
    
    self.m_winner = PLAYER_TYPE.NONE
    self.m_player = PLAYER_TYPE.O
    self.m_gameSteps = 0
    self.m_linePoits = {x0 = 0, y0 = 0, x1 = 0, y1 = 0}

    self.m_lineIndicesArray = {
    --[[{{0, 0}, {0, 1}, {0, 2}},
        {{1, 0}, {1, 1}, {1, 2}},
        {{2, 0}, {2, 1}, {2, 2}},
        {{0, 0}, {1, 0}, {2, 0}},
        {{0, 1}, {1, 1}, {2, 1}},
        {{0, 2}, {1, 2}, {2, 2}},
        {{0, 0}, {1, 1}, {2, 2}},
        {{0, 2}, {1, 1}, {2, 0}}]]
        
        {{1, 1}, {1, 2}, {1, 3}},
        {{2, 1}, {2, 2}, {2, 3}},
        {{3, 1}, {3, 2}, {3, 3}},
        {{1, 1}, {2, 1}, {3, 1}},
        {{1, 2}, {2, 2}, {3, 2}},
        {{1, 3}, {2, 3}, {3, 3}},
        {{1, 1}, {2, 2}, {3, 3}},
        {{1, 3}, {2, 2}, {3, 1}}
    }
    self.oImage  = love.graphics.newImage("assets/sprites/o.png")
    self.xImage  = love.graphics.newImage("assets/sprites/x.png")
    self.bgImage = love.graphics.newImage("assets/sprites/bg.png")
    self.font    = love.graphics.newFont("assets/fonts/early_gameboy.ttf", CELL_SIZE.y / 3)
end

function TicTacToe:update(dt)
    if input:released('leftButtonPressed') then
        local x, y = love.mouse.getPosition()
        --add + 1 because in Lua start accessing from 1       
        x = math.floor(x/CELL_SIZE.x) + 1 
        y = math.floor(y/CELL_SIZE.y) + 1
        if self.m_gameArray[y][x] == PLAYER_TYPE.NONE and self.m_winner == PLAYER_TYPE.NONE then
            self.m_gameArray[y][x] = self.m_player
            if self.m_player == PLAYER_TYPE.O then
                self.m_player = PLAYER_TYPE.X
            else
                self.m_player = PLAYER_TYPE.O
            end
            self.m_gameSteps = self.m_gameSteps + 1
            self:checkWinner()
        end        
    end
end
    
function TicTacToe:draw()
    love.graphics.draw(self.bgImage, 0, 0)
    for x = 1, COLUMNS do 
        for y = 1, ROWS do
            if self.m_gameArray[y][x] == PLAYER_TYPE.O then
                local posx = (x-1) * CELL_SIZE.x
                local posy = (y-1) * CELL_SIZE.y
                love.graphics.draw(self.oImage, posx, posy)
            elseif self.m_gameArray[y][x] == PLAYER_TYPE.X then
                local posx = (x-1) * CELL_SIZE.x
                local posy = (y-1) * CELL_SIZE.y
                love.graphics.draw(self.xImage, posx, posy)
            end
        end
    end
    self:drawWinner()
end

function TicTacToe:checkWinner()
    for _, lineIndices in ipairs(self.m_lineIndicesArray) do
        local sum_line = 0
        for _, indexPair in ipairs(lineIndices) do
            local i = indexPair[1]
            local j = indexPair[2]
            sum_line = sum_line + self.m_gameArray[i][j];
            if sum_line == 3*PLAYER_TYPE.O then
                self.m_winner = PLAYER_TYPE.O
                self.m_linePoits.x0 = (lineIndices[1][2] - 1) * CELL_SIZE.x + CELL_SIZE.x / 2
                self.m_linePoits.y0 = (lineIndices[1][1] - 1) * CELL_SIZE.y + CELL_SIZE.y / 2
                self.m_linePoits.x1 = (lineIndices[3][2] - 1) * CELL_SIZE.x + CELL_SIZE.x / 2
                self.m_linePoits.y1 = (lineIndices[3][1] - 1) * CELL_SIZE.y + CELL_SIZE.y / 2
                return
            end
            if sum_line == 3*PLAYER_TYPE.X then
                self.m_winner = PLAYER_TYPE.X
                self.m_linePoits.x0 = (lineIndices[1][2] - 1) * CELL_SIZE.x + CELL_SIZE.x / 2
                self.m_linePoits.y0 = (lineIndices[1][1] - 1) * CELL_SIZE.y + CELL_SIZE.y / 2
                self.m_linePoits.x1 = (lineIndices[3][2] - 1) * CELL_SIZE.x + CELL_SIZE.x / 2
                self.m_linePoits.y1 = (lineIndices[3][1] - 1) * CELL_SIZE.y + CELL_SIZE.y / 2
                return
            end     
        end
    end

    for x=1, COLUMNS do
        for y=1, ROWS do
            if self.m_gameArray[x][y] == PLAYER_TYPE.NONE then
                return
            end
        end
    end
    self.m_winner = PLAYER_TYPE.DRAW
end

function TicTacToe:drawWinner()
    if self.m_winner ~= PLAYER_TYPE.NONE then
        love.graphics.setLineWidth(CELL_SIZE.x/4)
        love.graphics.setColor(GREEN3)
        love.graphics.line(self.m_linePoits.x0, self.m_linePoits.y0, self.m_linePoits.x1, self.m_linePoits.y1)
        
        local rectangleWidth, rectangleHeight = 2*CELL_SIZE.x, CELL_SIZE.y
        love.graphics.setColor(GREEN1)
        love.graphics.rectangle("fill", BOARD_SIZE.x / 2 - rectangleWidth / 2, BOARD_SIZE.y / 2 - rectangleHeight / 2, rectangleWidth, rectangleHeight)
        love.graphics.setColor(GREEN2)
        love.graphics.setLineWidth(5)
        love.graphics.rectangle("line", BOARD_SIZE.x / 2 - rectangleWidth / 2, BOARD_SIZE.y / 2 - rectangleHeight / 2, rectangleWidth, rectangleHeight)

        local text
        if self.m_winner == PLAYER_TYPE.O then
            text = "O wins"
        elseif self.m_winner == PLAYER_TYPE.X then
            text = "X wins"
        else
            text = "Draw"
        end

        love.graphics.setFont(self.font)
        love.graphics.setColor(GREEN3)
        local font = love.graphics.getFont()
        local textWidth = font:getWidth(text)
        local textHeight = font:getHeight()
        love.graphics.print(text, BOARD_SIZE.x / 2 - 4, BOARD_SIZE.y / 2, 0, 1, 1, textWidth/2, textHeight/2)
        love.graphics.print(text, BOARD_SIZE.x / 2 + 4, BOARD_SIZE.y / 2, 0, 1, 1, textWidth/2, textHeight/2)
        love.graphics.print(text, BOARD_SIZE.x / 2, BOARD_SIZE.y / 2 - 4, 0, 1, 1, textWidth/2, textHeight/2)
        love.graphics.print(text, BOARD_SIZE.x / 2, BOARD_SIZE.y / 2 + 4, 0, 1, 1, textWidth/2, textHeight/2)
        love.graphics.setColor(GREEN0)
        love.graphics.print(text, BOARD_SIZE.x / 2, BOARD_SIZE.y / 2, 0, 1, 1, textWidth/2, textHeight/2)

        love.graphics.setColor(1,1,1)
    end
end

function TicTacToe:currentPlayer()
    if self.m_player == PLAYER_TYPE.O then
        return "Player O turn"
    elseif self.m_player == PLAYER_TYPE.X then
        return "Player X turn"
    else
        return ""
    end
end

function TicTacToe:gameSteps()
    return self.m_gameSteps
end