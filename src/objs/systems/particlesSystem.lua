
particlesSystem = {
 particles = {}
}

function particlesSystem:added()
 Bus:register('particles', function(x, y, radius, life, color, gravity)
  for i=1,10 do
   local xp = x + math.random(-3, 3)
   local yp = y + math.random(-3, 3)
   local vx = xp - x
   local vy = yp - y
   local d = math.sqrt(vx*vx + vy*vy)
   local p = {
    x = xp,
    y = yp,
    vx = vx / d,
    vy = vy / d,
    c = color,
    r = radius or 2,
    mlife = life or 20,
    life = math.random(life or 20),
    gravity = gravity or 0
   }
   table.insert(self.particles, p)
  end
 end)
end

function particlesSystem:update()

 for i, p in pairs(self.particles) do
  p.x = p.x + p.vx
  p.y = p.y + p.vy + p.gravity
  circ(p.x, p.y, p.r, p.c)
  p.r = p.r - (p.r/p.mlife)
  p.life = p.life - 1
  if p.life <= 0 then
   self.particles[i] = nil
  end
 end

end