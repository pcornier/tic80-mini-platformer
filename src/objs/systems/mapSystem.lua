
mapSystem = function(x, y, bg)
  local system = {}

  function system:update()
    -- bg
    map(bg * 30, 119)
    -- map
    map(x, y, 30, 17, 0, 0, 0)
  end

  return system
end

