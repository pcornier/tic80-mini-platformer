
aiExplodeSystem = {
 filter = { 'aiExplode' }
}

function aiExplodeSystem:process(e, dt)
 local player = self.world:pick({'player'})
 if player then
  local dx = player.pos.x - e.pos.x
  local dy = player.pos.y - e.pos.y
  local di = dx * dx + dy * dy
  if di < 2000 then
   e.animation.anim = 'explode'
   e.explode = (e.explode or 0) + 1
   if e.explode > 100 then
    self.world:removeEntity(e)
    Bus:emit('particles', e.pos.x, e.pos.y, 2, 30, 11, 0.3)
    self.world.shake = 10
    if di < 1800 then
     player.hit = 10
     player.godmode = 100
    end
   end
  end
 end
end

