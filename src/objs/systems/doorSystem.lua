
doorSystem = function()
 local system = {}

 function system:added()
  Bus:register('bulletHitMap', function(x, y)
   local doors = self.world:filter({ 'door' })
   for _,e in pairs(doors) do
    if e.pos.my == y and e.pos.mx == x then
     e.tile.state = 'once'
     e.door.tile.state = 'once'
    end
   end
  end)
 end

 return system
end

