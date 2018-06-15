
playerCollisionSystem = function()
 local system = { filter = { 'player' } }

 function system:process(player)
  local collide = function(e1, e2)
   if e1.pos.x > e2.pos.x + 8 then return false end
   if e1.pos.x + 8 < e2.pos.x then return false end
   if e1.pos.y > e2.pos.y + 8 then return false end
   if e1.pos.y + 8 < e2.pos.y then return false end
   return true
  end

  if not player.godmode then
   local enemies = self.world:filter({ 'enemy' })
   for _,enemy in pairs(enemies) do
    if collide(player, enemy) then
     player.hit = 5
     player.godmode = 100
     break
    end
   end
  end

  local collectibles = self.world:filter({ 'collectible' })
  for _,collectible in pairs(collectibles) do
   if collide(player, collectible) then
    Bus:emit('collect', player, collectible)
    break
   end
  end

  Bus:register('death', function(e)
   if not player.godmode then
    local dx = player.pos.x - e.pos.x
    local dy = player.pos.y - e.pos.y
    local di = dx * dx + dy * dy
    if di < 800 then
     player.hp = player.hp - 20
     player.godmode = 100
    end
   end
  end)

 end

 return system
end