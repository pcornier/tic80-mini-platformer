
waterSystem = {
 filter = { 'water', 'rect' }
}

function waterSystem:added()
 self.pal = 0x4000 + 55 * 32
end

function waterSystem:process(e, dt)

 e.timer = e.timer or 0

 local to = e.rect.base
 local from = to - 480
 for y=0,e.rect.h do
  for x=0,e.rect.w do
   local px = peek(from+x)
   local c1 = (px >> 4) & 0xf
   local c2 = px & 0xf
   local i1 = (c1 >> 1) + 8
   local i2 = (c2 >> 1) + 8
   local o1 = (c1 & 1) << 2
   local o2 = (c2 & 1) << 2
   local p1 = (peek(self.pal+i1) >> o1) & 0xf
   local p2 = (peek(self.pal+i2) >> o2) & 0xf
   poke(to+x,p1<<4|p2)
  end
  to = to + 120
  from = from - (math.sin(e.timer * y) + math.cos(e.timer * y) + math.pi) // 2 * 120
 end

 e.timer = e.timer + 0.01
end
