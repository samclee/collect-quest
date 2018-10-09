-- libs

-- classes

-- Town

-- player

-- textbox

-- callbacks
function love.load()

end

function love.update(dt)

end

function love.draw()

end

function love.keypressed(k)

end

-- util
function overlap(a, b) return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y end