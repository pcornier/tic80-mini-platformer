
bulletSystem = function(levelx, levely, cbIsWall)

 local system = { filter = { 'bullet' } }

 function system:added()
  Bus:register('shoot', function(x, y, d)
   x = x // 8
   y = y // 8
   local candidates = {}
   local critters = self.world:filter({ 'hp' })
   for _,e in pairs(critters) do
    if e.pos.y // 8 == y then
     local i = e.pos.x // 8
     candidates[i] = candidates[i] or {}
     table.insert(candidates[i], e)
    end
   end

   dir = -(d * 2 - 1)
   local stop = dir == -1 and 0 or 30
   for bx=x+dir,stop,dir do
    if candidates[bx] then
     for _,e in pairs(candidates[bx]) do
      e.hit = 1
      e.animation.anim = 'hit'
     end
     break
    end
    if cbIsWall(bx + levelx, y + levely) then
     self.world:addEntity({
      bullet = true,
      x = (bx - dir) * 8,
      y = y * 8,
      d = d,
      f = 14
     })
     Bus:emit('bulletHitMap', bx + levelx, y + levely)
     break
    end
   end

  end)
 end

 function system:process(e)
  spr(e.f, e.x, e.y, 0, 1, e.d)
  e.f = e.f + 0.5
  if e.f >= 16 then self.world:removeEntity(e) end
 end

 return system
end

