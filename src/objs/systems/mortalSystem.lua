
mortalSystem = { filter = { 'hit', 'hp' } }

function mortalSystem:process(e)
 e.hp = e.hp - e.hit
 e.hit = nil

 if e.hp <= 0 then
  self.world:removeEntity(e)
  Bus:emit('particles', e.pos.x, e.pos.y, 2, 20, 6, 0.5)
  Bus:emit('death', e)
  self.world.shake = 10
 end

end