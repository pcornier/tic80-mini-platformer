
mapCollisionSystem = function(levelx, levely, cbIsWall)

 system = {
  filter = { 'pos', 'vel', 'platformer', 'aabb' }
 }

 function system:process(e)
  e.grounded = false
  local function collideMap(ex, ey)
   local x1 = (8 * levelx + ex + e.aabb[1]) // 8
   local y1 = (8 * levely + ey + e.aabb[2]) // 8
   local x2 = (8 * levelx + ex + e.aabb[3]) // 8
   local y2 = (8 * levely + ey + e.aabb[4]) // 8
   local n = 0
   local flags = 0
   for x=x1,x2 do
    for y=y1,y2 do
     if cbIsWall(x, y) then
      flags = flags | 1 << n
     end
     n = n + 1
    end
   end
   return flags
  end

  local x, y = e.pos.x, e.pos.y
  local colinfo = collideMap(x, y)
  -- colinfo:
  -- +-----+-----+
  -- |  1--|--4  |
  -- +--|--+--|--+
  -- |  2--|--8  |
  -- +-----+-----+
  if colinfo > 0 then
   local npx = math.floor((e.pos.x+.5)/8)*8
   local npy = math.floor(e.aabb[2]+(e.pos.y+.5)/8)*8
   if colinfo == 8 then
    if e.vel.y > 0 then
     e.pos.y = npy
     e.grounded = true
     e.vel.y = 0
    end
   elseif colinfo == 2 or colinfo == 8 or colinfo == 10 then
    e.pos.y = npy
    e.grounded = true
    e.vel.y = 0
   elseif colinfo == 1 or colinfo == 4 or colinfo == 5 then
    if e.pos.y + 4 > npy and e.pos.y + 4 < npy + 8 then
     if colinfo == 1 then
      e.pos.x = npx + e.aabb[3]
      e.vel.x = 0
     else
      e.pos.x = npx + e.aabb[1]
      e.vel.x = 0
     end
    else
     e.pos.y = npy + 8
     e.vel.y = 0
    end
   elseif colinfo == 3 then
    e.pos.x = npx + e.aabb[3]
    e.vel.x = 0
   elseif colinfo == 12 then
    e.pos.x = npx + e.aabb[1]
    e.vel.x = 0
   elseif colinfo == 11 or colinfo == 14 then
    if colinfo == 11 then
     e.pos.x = npx + e.aabb[3]
    else
     e.pos.x = npx + e.aabb[1]
    end
    e.pos.y = npy
    e.vel.x = 0
    e.vel.y = 0
    e.grounded = true
   elseif colinfo == 7 or colinfo == 13 then
    if colinfo == 7 then
     e.pos.x = npx + e.aabb[3]
    else
     e.pos.x = npx + e.aabb[1]
    end
    e.pos.y = npy + 8
    e.vel.x = 0
    e.vel.y = 0
   end
  end

 end

 return system

end

