-- tiled map matrix, reads tiled lua export flie and converts to a map matrix; also helps to
-- generate code for objects by calling macros.

--[[
  Copyright (c) 2020-2022 André Luiz Alvares

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  SPDX-License-Identifier: MPL-2.0
]]

local tiledmap = {}

local function find_layer(tbl, layer_type, layer_name)
  for i, layer in ipairs(tbl.layers) do
    if layer.type == layer_type and layer.name == layer_name then
      return layer
    end
  end
end

function tiledmap.from_tile_layer(tbl, layer_name)
  local layer = find_layer(tbl, 'tilelayer', layer_name)
  if not layer then
    return nil, string.format('could not find "%s" layer', layer)
  end

  local matrix = {
    rect_tile_count = layer.width * layer.height,
    line_count = layer.height,
    map_max_width = layer.width,
  }

  local n = 0

  for i = 1, layer.height do
    table.insert(matrix, {})

    for j = 1, layer.width do
      n = n + 1
      table.insert(matrix[#matrix], layer.data[n])
    end
  end

  return matrix
end

function tiledmap.call_per_object(tbl, layer_name, callback_by_class, callback_by_name)
  local layer = find_layer(tbl, 'objectgroup', layer_name)
  if not layer then
    return nil, string.format('could not find "%s" layer', layer)
  end

  for i, obj in ipairs(layer.objects) do
    if callback_by_class[obj.class] then
      callback_by_class[obj.class](obj)
    end

    if callback_by_name[obj.name] then
      callback_by_name[obj.name](obj)
    end
  end

  return true
end

return tiledmap
