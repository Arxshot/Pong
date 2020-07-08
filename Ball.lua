--[[
    GD50 2018
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]



Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    
    self.player1 = null
    self.player2 = null

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
    
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]

function Ball:player1DefencePoint()
    local x  = self.x
    local y  = self.y
    local dx = self.dx
    local dy = self.dy
    local ray = Ray(x,y,dx + x,dy + y)
    for i = 0, 3, 1 do
      print("here")
      local vecX, vecY = ray:castray(self.player1.x+(self.player1.width/2), 0, self.player1.x+(self.player1.width/2), VIRTUAL_HEIGHT)
      if (vecX ~= nil and vecY ~= nil) then
        self.player1.defencePoint.y = vecY
        self.player1.defencePoint.x = vecX
        return
      end
      
      vecX, vecY = ray:castray(0, 0, VIRTUAL_WIDTH, 0)
      if (vecX ~= nil and vecY ~= nil) then
        dy = dy * -1
        x = vecX
        y = vecY
        
        ray.x = x
        ray.y = y
        ray.dx = dx + x
        ray.dy = dy + y           
        else
        vecX,vecY = ray:castray(0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        if (vecX ~= nil and vecy ~= nil) then
          dy = dy * -1
          x = vecX
          y = vecY
        
          ray.x = x
          ray.y = y
          ray.dx = dx + x
          ray.dy = dy + y     
          else
          vecX, vecY = ray:castray(self.player2.x+(self.player2.width/2), 0, self.player2.x+(self.player2.width/2), VIRTUAL_HEIGHT)
          if (vecX ~= nil and vecY ~= nil) then
            dx = dx * -1
            x = vecX
            y = vecY
        
            ray.x = x
            ray.y = y
            ray.dx = dx + x
            ray.dy = dy + y
          end
        end  
      end
      
    end
end

function Ball:player2DefencePoint()
    local x  = self.x
    local y  = self.y
    local dx = self.dx
    local dy = self.dy
    local ray = Ray(x,y,dx + x,dy + y)
    --for i = 0, 3, 1 do
      local vecX, vecY = ray:castray(self.player2.x+(self.player2.width/2), 0, self.player2.x+(self.player2.width/2), VIRTUAL_HEIGHT)
      if (vecX ~= nil and vecy ~= nil) then
        self.player2.defencePoint.y = vecY
        self.player2.defencePoint.x = vecX
        return
      end
      
      vecX, vecY = ray:castray(0, 0, VIRTUAL_WIDTH, 0)
      if (vecX ~= nil and vecY ~= nil) then
        dy = dy * -1
        x = vecX
        y = vecY
        
        ray:set(x,y,dx + x,dy + y)
      else
        vecX,vecYy = ray:castray(0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
        if (vecX ~= nil and vecY ~= nil) then
          dy = dy * -1
          x = vecX
          y = vecY
        
          ray:set(x,y,dx + x,dy + y)
        else
          vecX, vecY = ray:castray(self.player1.x+(self.player1.width/2), 0, self.player1.x+(self.player1.width/2), VIRTUAL_HEIGHT)
          if (vecX ~= nil and vecY ~= nil) then
            dx = dx * -1
            x = vecX
            y = vecY
        
            ray:set(x,y,dx + x,dy + y)
          end
        end  
      end
    --end
end

function Ball:DefencePoint(p1,p2,x,y,dx,dy)
  local ray = Ray(x,y,dx + x,dy + y)
    local vecX, vecY = ray:castray(p1.x+(p1.width/2), 0, p1.x+(p1.width/2), VIRTUAL_HEIGHT)
    if (vecX ~= nil and vecy ~= nil) then
      p1.defencePoint.y = vecY
      p1.defencePoint.x = vecX
      return
    end
    
    vecX, vecY = ray:castray(0, 0, VIRTUAL_WIDTH, 0)
    if (vecX ~= nil and vecY ~= nil) then
      Ball:DefencePoint(p1,p2,vecX,vecY,dx,-dy)
      return
    end

    vecX,vecYy = ray:castray(0, VIRTUAL_HEIGHT, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    if (vecX ~= nil and vecY ~= nil) then
      Ball:DefencePoint(p1,p2,vecX,vecY,dx,-dy)
      return
    end

    vecX, vecY = ray:castray(p2.x+(p2.width/2), 0, p2.x+(p2.width/2), VIRTUAL_HEIGHT)
    if (vecX ~= nil and vecY ~= nil) then
      Ball:DefencePoint(p1,p2,vecX,vecY,-dx,dy)
      return
    end
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    if gameState == 'play' then
      self:renderline(self.player1,self.player2,self.x, self.y, self.dx, self.dy,5)
    end
end

function Ball:renderline(p1,p2,x,y,dx,dy,num)
  if num == 0 then
    return
  end
    x = math.max(math.min(p2.x+(p2.width/2),p1.x+(p1.width/2)),x)
    x = math.min(math.max(p2.x+(p2.width/2),p1.x+(p1.width/2)),x)
    y = math.max(0,y)
    y = math.min(VIRTUAL_HEIGHT-self.height,y)
    local ray = Ray(x,y,dx + x,dy + y)
    
    local vecX, vecY

    vecX, vecY = ray:castray(p2.x+(p2.width/2), 0, p2.x+(p2.width/2), VIRTUAL_HEIGHT-self.height)
    if (vecX ~= nil and vecY ~= nil) then
      love.graphics.line(x,y,vecX,vecY)
      self:renderline(p1,p2,vecX,vecY,-dx,dy,num-1)
      return
    end

    vecX, vecY = ray:castray(p1.x+(p1.width/2), 0, p1.x+(p1.width/2), VIRTUAL_HEIGHT-self.height)
    if (vecX ~= nil and vecY ~= nil) then
      love.graphics.line(x,y,vecX,vecY)
      self:renderline(p1,p2,vecX,vecY,-dx,dy,num-1)
      return
    end

    vecX, vecY = ray:castray(0, 0, VIRTUAL_WIDTH, 0)
    if (vecX ~= nil and vecY ~= nil) then
      love.graphics.line(x,y,vecX,vecY)
      self:renderline(p1,p2,vecX,vecY,dx,-dy,num-1)
      return
    end

    vecX, vecY = ray:castray(0, VIRTUAL_HEIGHT-self.height, VIRTUAL_WIDTH, VIRTUAL_HEIGHT-self.height)
    if (vecX ~= nil and vecY ~= nil) then
      love.graphics.line(x,y,vecX,vecY)
      self:renderline(p1,p2,vecX,vecY,dx,-dy,num-1)
      return
    end

end