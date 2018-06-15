
animatedTileSystem = {
 filter = { 'pos', 'tile' }
}

-- state: paused, once, reverse, reverseOnce
-- speed (anim speed): number or string 'random'
function animatedTileSystem:process(e, dt)
 if e.tile.state ~= 'paused' then
  e.timer = e.timer or 0
  local frame = 1 + (e.timer % #e.tile.sequence) // 1
  mset(e.pos.mx, e.pos.my, e.tile.sequence[frame])
  local speed = e.tile.speed ~= 'random' and e.tile.speed or math.random()
  local direction = (e.tile.state == 'reverse' or e.tile.state == 'reverseOnce') and -1 or 1
  e.timer = e.timer + (dt * speed) * direction
  if (e.tile.state == 'once' or e.tile.state == 'reverseOnce') and frame == #e.tile.sequence then
   e.tile.state = 'paused'
  end
 end
end