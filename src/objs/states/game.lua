
------------------------------
-- Game state
------------------------------

game = {
 level = 0,
 inventory = {
  items = {}
 }
}

function game:enter()
 self:load()
end

function game:load(noplayer)
 sync(true)
 Bus:clear()

 world = World()

 local levelx = (self.level % 8) * 30
 local levely = (self.level // 8) * 17
 local walls = index({
  27, 28, 29, 32, 33, 37, 38, 45, 46, 47,
  72, 75, 105, 106, 107, 121, 122, 123, 137,
  138, 139, 153, 154, 155
 })
 local backgroundId = 0

 local function isWalkable(x, y)
  if walls[mget(x, y+1)] and not walls[mget(x, y)] then return true end
  return false
 end

 local function isWall(x, y)
  return walls[mget(x, y)]
 end

 -- scan level for player, monsters...
 for x=levelx, levelx + 29 do
  for y=levely, levely + 17 do

   local id = mget(x, y)

   if game.inventory.items[x .. ',' .. y] then

    mset(x, y, 0)

   elseif id >= 48 and id <= 52 then

    backgroundId = id - 48
    mset(x, y, 0)

   elseif id == 61 then -- secret way

    local secret = {
     pos = {
      x = x * 8 - levelx * 8,
      y = y * 8 - levely * 8
     },
     sprite = id,
     layer = 3
    }

    world:addEntity(secret)

   elseif id == 6 then -- player

    if not noplayer then
     local player = {
      player = true,
      platformer = true,
      pos = {
       x = x * 8 - levelx * 8,
       y = y * 8 - levely * 8
      },
      vel = { x = 0, y = 0 },
      sprite = 6,
      animation = {
       anim = 'stand',
       sequences = {
        walk = { frames = { 1, 2, 3, 4, 5, 6 }, speed = 1 },
        jump = { frames = { 6 }, speed = 1 },
        djump = { frames = { 7, 8, 9, 10 }, speed = 1 },
        fire = { frames = { 11 }, speed = 1 },
        stand = { frames = { 6, 6 }, speed = 0.1, thn = 'blink' },
        blink = { frames = { 6, 16, 6 }, speed = 1, thn = 'stand' }
       }
      },
      flip = 0,
      aabb = { 2, 0, 6, 8 },
      gravity = 1,
      shooting = 0,
      hp = 100,
      layer = 2
     }
     world:addEntity(player)
    end
    mset(x, y, 0)

   elseif id == 21 then -- critter

    local critter = {
     pos = {
      x = x * 8 - levelx * 8,
      y = y * 8 - levely * 8,
      mx = x, my = y
     },
     vel = { x = 0, y = 0 },
     sprite = 21,
     animation = {
      anim = 'walk',
      sequences = {
       walk = { frames = { 21, 22 }, speed = 0.5 },
       hit = { frames = { 25, 26 }, speed = 2, thn = 'walk' }
      }
     },
     flip = 0,
     aabb = { 0, 0, 8, 8 },
     hp = 50,
     aiBounce = true,
     enemy = true
    }

    world:addEntity(critter)
    mset(x, y, 0)

   elseif id == 56 then -- green critter

    local critter = {
     pos = {
      x = x * 8 - levelx * 8,
      y = y * 8 - levely * 8,
      mx = x, my = y
     },
     vel = { x = 0, y = 0 },
     sprite = 21,
     animation = {
      anim = 'walk',
      sequences = {
       walk = { frames = { 56, 57 }, speed = 0.5 },
       hit = { frames = { 58, 59 }, speed = 2, thn = 'walk' },
       explode = { frames = { 56, 60 }, speed = 0.5, thn = 'walk' }
      }
     },
     flip = 0,
     aabb = { 0, 0, 8, 8 },
     hp = 80,
     aiBounce = true,
     aiExplode = true,
     enemy = true
    }
    world:addEntity(critter)
    mset(x, y, 0)

   elseif id == 88 then -- sticky critter

    local critter = {
     pos = {
      x = x * 8 - levelx * 8,
      y = y * 8 - levely * 8,
      mx = x, my = y
     },
     vel = { x = 0, y = 0 },
     sprite = 88,
     animation = {
      anim = 'walk',
      sequences = {
       walk = { frames = { 88, 89 }, speed = 0.5 },
       hit = { frames = { 90, 91 }, speed = 1, thn = 'walk' }
      }
     },
     flip = 0,
     aabb = { 0, 0, 8, 8 },
     hp = 50,
     aiSticky = true,
     enemy = true
    }
    world:addEntity(critter)
    mset(x, y, 0)

   elseif id == 33 then -- green door

    if mget(x, y+1) == id then

     local door1 = {
      pos = { mx = x, my = y },
      tile = {
       sequence = { 33, 34, 0 },
       speed = 1,
       state = 'paused'
      }
     }

     local door2 = {
      pos = { mx = x, my = y+1 },
      tile = {
       sequence = { 33, 35, 0 },
       speed = 1,
       state = 'paused'
      },
      door = door1
     }

     world:addEntity(door1)
     world:addEntity(door2)
    end

   elseif id == 54 then -- water rect

    if mget(x-1, y) ~= id and mget(x, y-1) ~= id then

     local bx = x
     local by = y
     -- search for bottom right corner
     while mget(bx, y) == id do bx = bx + 1 end
     while mget(x, by) == id do by = by + 1 end

     local x1 = x - levelx
     local y1 = y - levely
     local x2 = bx - levelx
     local y2 = by - levely

     local base = (y1 * 8 * 240 + x1 * 8) // 2
     local w = (x2 - x1) * 4 - 1
     local h = (y2 - y1) * 8 - 1

     local waterblock = {
      rect = {
       base = base,
       w = w,
       h = h
      },
      water = true
     }
     world:addEntity(waterblock)

    end

   elseif id == 39 then -- plant

    local plant = {
     pos = {
      x = x * 8 - levelx * 8,
      y = y * 8 - levely * 8,
      mx = x, my = y
     },
     sprite = 39,
     animation = {
      anim = 'stand',
      sequences = {
       stand = { frames = { 39, 40, 41, 42 }, speed = 'random' },
       hit = { frames = { 42 }, speed = 1, thn = 'stand' }
      }
     },
     hp = 10,
     enemy = true,
     layer = 0
    }
    world:addEntity(plant)
    mset(x, y, 0)

   elseif id == 19 then -- health capsule

    local health = {
     pos = {
       x = x * 8 - levelx * 8,
       y = y * 8 - levely * 8
     },
     sprite = 19,
     collectible = true,
     health = true,
     layer = 0
    }
    world:addEntity(health)
    mset(x, y, 0)

   elseif id == 20 then -- bonus capsule

    local bonus = {
     pos = {
      x = x * 8 - levelx * 8,
      y = y * 8 - levely * 8
     },
     sprite = 20,
     collectible = true,
     bonus = true,
     layer = 0
    }
    world:addEntity(bonus)
    mset(x, y, 0)

   end
  end
 end

 world:addSystem(mapSystem(levelx, levely, backgroundId))
 world:addSystem(animatedTileSystem)
 world:addSystem(animatedSpriteSystem)
 world:addSystem(playerCollisionSystem())
 world:addSystem(mortalSystem)
 world:addSystem(godSystem)
 world:addSystem(spriteRenderingSystem)
 world:addSystem(aiBounceSystem(isWalkable, levelx, levely))
 world:addSystem(aiStickySystem(isWall, levelx, levely))
 world:addSystem(gravitySystem)
 world:addSystem(mapCollisionSystem(levelx, levely, isWall))
 world:addSystem(bulletSystem(levelx, levely, isWall))
 world:addSystem(particlesSystem)
 world:addSystem(waterSystem)
 world:addSystem(doorSystem(levelx, levely))
 world:addSystem(aiExplodeSystem)
 world:addSystem(statusBarSystem)
 world:addSystem(playerSystem)

 world:addEntity(game.inventory)


 Bus:register('move', function(dir, player)
  if dir == 'right' then
   self.level = self.level + 1
   player.pos.x = 8
  elseif dir == 'left' then
   self.level = self.level - 1
   player.pos.x = 232
  elseif dir == 'down' then
   self.level = self.level + 8
   player.pos.y = 8
  elseif dir == 'up' then
    self.level = self.level - 8
    player.pos.y = 128
  end
  self:load(true)
  world:addEntity(player)
 end)

 Bus:register('collect', function(player, item)
  local key = levelx + (item.pos.x // 8) .. ',' .. levely + (item.pos.y // 8)
  game.inventory.items[key] = true
  world:removeEntity(item)
  if item.health then player.hp = math.min(player.hp+10, 100) end
  if item.bonus then
   game.inventory.bonuses = (game.inventory.bonuses or 0) + 1
  end
 end)

 Bus:register('death', function(e)
  local key = e.pos.mx .. ',' .. e.pos.my
  game.inventory.items[key] = true
 end)
end

function game:update(dt)
 world:update(dt)

 if world.shake and world.shake > 0 then
  poke(0x3FF9,math.random(-2,2))
  poke(0x3FF9+1,math.random(-2,2))
  world.shake = world.shake - 1
  if world.shake == 0 then memset(0x3FF9,0,2) end
 end
end

function index(list)
 local tmp = {}
 for _, n in pairs(list) do
  tmp[n] = true
 end
 return tmp
end