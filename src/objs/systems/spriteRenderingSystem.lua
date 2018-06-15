

spriteRenderingSystem = {
 filter = { 'pos', 'sprite' }
}

function spriteRenderingSystem:update()
 table.sort(self.entities, function(a, b)
  a.layer = a.layer or 1
  b.layer = b.layer or 1
  return a.layer < b.layer
 end)
end

function spriteRenderingSystem:process(e, dt)
 spr(e.sprite, e.pos.x, e.pos.y, 0, 1, e.flip, e.rotate or 0)
end
