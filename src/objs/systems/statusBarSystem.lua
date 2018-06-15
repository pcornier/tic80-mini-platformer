
statusBarSystem = {}

function statusBarSystem:update()
 local x, y = 5, 5
 local inventory = self.world:pick({ 'items' })
 local player = self.world:pick({ 'player' })
 if player then
  rect(x, y, 100, 3, 1)
  rect(x, y, player.hp, 3, 6)
  spr(20, 220, y-2, 0)
  print((inventory.bonuses or 0), 230, y)
 end
end