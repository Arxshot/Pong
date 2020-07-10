Ray = Class{}

--[[
    The `init` function on our class is called just once, when the object
    is first created. Used to set up all variables in the class and get it
    ready for use.

    Our Paddle should take an X and a Y, for positioning, as well as a width
    and height for its dimensions.

    Note that `self` is a reference to *this* object, whichever object is
    instantiated at the time this function is called. Different objects can
    have their own x, y, width, and height values, thus serving as containers
    for data. In this sense, they're very similar to structs in C.
]]
function Ray:init(x1, y1, x2, y2)
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
end

function Ray:set(x1, y1, x2, y2)
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
end

function Ray:castray(x1, y1, x2, y2)
    local den = (x1 - x2) * (self.y1 - self.y2) - (y1 - y2) * (self.x1 - self.x2)
    if den == 0 then
      return nil, nil
    end
    
    local t =  ((x1 - self.x1) * (self.y1 -  self.y2) - (y1 -  self.y1) * (self.x1 -  self.x2)) / den
    local u =  -((x1 - x2) * (y1 -  self.y1) - (y1 -  y2) * (x1 -  self.x1)) / den
    
    if t > 0 and t < 1 and u > 0 then 
      local x = x1 + t * (x2 - x1)
      local y = y1 + t * (y2 - y1)
      return x, y
    else 
      return nil, nil
    end
    
    
end

function Ray:castray2(x1, y1, x2, y2)
  local den = (x1 - x2) * (self.y1 - self.y2) - (y1 - y2) * (self.x1 - self.x2)

  
  if den == 0 then
    return false
  end
  
  local t =  ((x1 - self.x1) * (self.y1 -  self.y2) - (y1 -  self.y1) * (self.x1 -  self.x2)) / den
  local u =  -((x1 - x2) * (y1 -  self.y1) - (y1 -  y2) * (x1 -  self.x1)) / den
  
  if t > 0 and t < 1 and u > 0 and u < 1 then 
    return true
  else 
    return false
  end
  
  
end

--[[
    To be called by our main function in `love.draw`, ideally. Uses
    LÖVE2D's `rectangle` function, which takes in a draw mode as the first
    argument as well as the position and dimensions for the rectangle. To
    change the color, one must call `love.graphics.setColor`. As of the
    newest version of LÖVE2D, you can even draw rounded rectangles!
]]
