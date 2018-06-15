
gravitySystem = {
 filter = { 'gravity', 'vel' }
}

function gravitySystem:process(e, dt)
 e.vel.y = e.vel.y + e.gravity * dt
end
