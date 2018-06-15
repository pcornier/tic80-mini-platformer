
aiStickySystem = function(cbIsWall, levelx, levely)
 local system = {
  filter = { 'aiSticky' }
 }

 function system:process(e, dt)
  local angle = e.rotate or 0

  if angle == 0 then
   e.pos.x = e.pos.x - 1 * dt
   local turn = not cbIsWall((e.pos.x + 4) // 8 + levelx, e.pos.y // 8 + levely + 1)
   if turn then
    e.pos.x = e.pos.x // 8 * 8
    e.pos.y = e.pos.y // 8 * 8 + 4
    e.rotate = 3
   end

   elseif angle == 3 then
    e.pos.y = e.pos.y + 1 * dt
    local turn = not cbIsWall(e.pos.x // 8 + levelx + 2, (e.pos.y - 4) // 8 + levely + 1)
    if turn then
     e.rotate = 2
     e.pos.x = e.pos.x // 8 * 8 + 4
     e.pos.y = e.pos.y // 8 * 8 + 8
    end

   elseif angle == 2 then
    e.pos.x = e.pos.x + 1 * dt
    local turn = not cbIsWall((e.pos.x - 4) // 8 + levelx + 1, e.pos.y // 8 + levely - 1)
    if turn then
     e.rotate = 1
     e.pos.x = e.pos.x // 8 * 8 + 8
     e.pos.y = e.pos.y // 8 * 8 - 4
    end

   elseif angle == 1 then
    e.pos.y = e.pos.y - 1 * dt
    local turn = not cbIsWall(e.pos.x // 8 + levelx - 1, (e.pos.y + 4) // 8 + levely)
    if turn then
     e.rotate = 0
     e.pos.x = e.pos.x // 8 * 8 - 4
     e.pos.y = e.pos.y // 8 * 8
    end

  end

 end

 return system
end

