
animatedSpriteSystem = {
 filter = { 'animation', 'sprite' }
}

function animatedSpriteSystem:process(entity, dt)
 if entity.current_anim ~= entity.animation.anim then
  entity.timer = 0
  entity.current_anim = entity.animation.anim
 end
 local anim = entity.animation.sequences[entity.animation.anim]
 local idx = (entity.timer % #anim.frames+1) // 1
 entity.sprite = anim.frames[idx]
 local speed = anim.speed ~= 'random' and anim.speed or math.random()
 entity.timer = entity.timer + speed * dt
 if anim.thn and idx == #anim.frames then
  entity.animation.anim = anim.thn
 end
end
