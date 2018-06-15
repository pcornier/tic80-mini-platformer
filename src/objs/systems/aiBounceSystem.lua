
aiBounceSystem = function(cbIsWalkable, levelx, levely)
 local system = {
   filter = { 'aiBounce' }
 }

 function system:process(e, dt)
  e.pos.x = e.pos.x + (e.flip * 2 - 1) * dt
  if not cbIsWalkable(e.pos.x // 8 + e.flip + levelx, e.pos.y // 8 + levely) then
   e.flip = 1 - e.flip
  end
 end

 return system
end

