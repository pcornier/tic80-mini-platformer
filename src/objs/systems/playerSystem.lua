
playerSystem = {
 filter = { 'player' }
}

function playerSystem:process(e, dt)
 if e.grounded and (e.animation.anim ~= 'stand' and e.animation.anim ~= 'blink' and e.animation.anim ~= 'hit') then
  e.animation.anim = 'stand'
 end

 if btn(2) then
  e.vel.x = math.max(-1, e.vel.x - 0.2)
  e.animation.anim = e.grounded and 'walk' or 'djump'
  e.flip = 1
 end

 if btn(3) then
  e.vel.x = math.min(1, e.vel.x + 0.2)
  e.animation.anim = e.grounded and 'walk' or 'djump'
  e.flip = 0
 end

 if btn(4) and e.grounded then
  e.animation.anim = 'djump'
  e.vel.y = -2.5
 end

 if btn(5) then
  e.animation.anim = 'fire'
  if e.shooting < 3 then
   spr(12, e.pos.x - (e.flip * 2 - 1) * 8, e.pos.y, 0, 1, e.flip)
   e.shooting = e.shooting + 1
   Bus:emit('shoot', e.pos.x, e.pos.y, e.flip)
  elseif e.shooting < 6 then
   e.shooting = e.shooting + 1
  else
   e.shooting = 0
  end
 end

 e.pos.x = e.pos.x + e.vel.x
 e.pos.y = e.pos.y + e.vel.y
 e.vel.x = e.vel.x * 0.7

 if e.pos.x > 236 then
  Bus:emit('move', 'right', e)
 elseif e.pos.x < 4 then
  Bus:emit('move', 'left', e)
 elseif e.pos.y > 132 then
  Bus:emit('move', 'down', e)
 elseif e.pos.y < 4 then
  Bus:emit('move', 'up', e)
 end

end
