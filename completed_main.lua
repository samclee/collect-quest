-- libs
Class = require 'libs/class'

-- classes
Object = Class{
	init = function(self, x, y, sprite)
		self.x = x
		self.y = y
		self.sprite = sprite
		self.w = sprite:getWidth()
		self.h = sprite:getHeight()
	end,

	draw = function(self)
		love.graphics.draw(self.sprite, self.x, self.y)
	end
}

-- Town
Town = Class{
	__includes = Object,

	init = function(self, x, y, sprite, id, msg)
		Object.init(self, x, y, sprite)
		self.id = id
		self.msg = msg
	end
}

-- player
player = Object(350, 250, love.graphics.newImage('assets/0.png'))
player.visited = {false, false, false}
player.update = function(self)
	local dx, dy = 0, 0

	if love.keyboard.isDown('left') then dx = dx - 1 end
	if love.keyboard.isDown('right') then dx = dx + 1 end
	if love.keyboard.isDown('up') then dy = dy - 1 end
	if love.keyboard.isDown('down') then dy = dy + 1 end

	local spd = 2
	self.x = self.x + dx * spd
	self.y = self.y + dy * spd
end

-- textbox
textbox = { w = 800, h = 120, x = 0, y = 600 - 120, msg = '', active = false}
textbox.draw = function(self)
	if self.active then
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
		love.graphics.setColor(1, 1, 1)
		love.graphics.printf(self.msg, self.x + 20, self.y, 760)
	end
end

-- callbacks
function love.load()
	love.graphics.setBackgroundColor(0.2, 0.8, 0.6)
	love.graphics.setNewFont('assets/orangekid.ttf', 48)
	bgm = love.audio.newSource('assets/pastorale.mp3', 'stream')
	bgm:setLooping(true)
	love.audio.play(bgm)

	towns = {
		Town(10, 10, love.graphics.newImage('assets/1.png'), 1, '>You see a big ear of corn. Dope, another to add to the collection. Corn GET'),
		Town(200, 400, love.graphics.newImage('assets/2.png'), 2, '>You find a fancy permanent marker. Time to vandalize something. Scribe ability +5'),
		Town(600, 200, love.graphics.newImage('assets/3.png'), 3, '>You get a free pack of napkins. They\'re kinda scratchy though. Hygiene LEVEL UP.'),
	}
end

function love.update(dt)
	player:update()
end

function love.draw()
	for i = 1, #towns do
		towns[i]:draw()
	end
	player:draw()
	textbox:draw()
	if player.visited[1] == true and player.visited[2] == true and player.visited[3] == true then
		love.graphics.printf("YOU COLLECTED ALL THE THINGS", 0, 100, 800, 'center')
	end
end

function love.keypressed(k)
	if k == 'x' then
		if textbox.active == true then
			textbox.active = false
		else
			for i = 1, #towns do
				if overlap(player, towns[i]) then
					textbox.msg = towns[i].msg
					player.visited[towns[i].id] = true
					textbox.active = true
				end
			end
		end
	end
end

-- util
function overlap(a, b) return a.x < b.x + b.w and a.x + a.w > b.x and a.y < b.y + b.h and a.y + a.h > b.y end