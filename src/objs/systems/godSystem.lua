
godSystem = { filter = { 'sprite', 'godmode' } }

function godSystem:process(e)
 if not e.saved_hp then
  e.saved_hp = e.hp
 end
 e.hp = e.saved_hp

 e.godmode = e.godmode - 1
 if e.godmode > 0 then
  if e.godmode % 10 > 5 then
   e.sprite = 0
  end
 else
  e.godmode = nil
  e.saved_hp = nil
 end

end