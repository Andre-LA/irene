-- arr map, reads an array table and converts to a map matrix

--[[
  Copyright (c) 2020-2022 André Luiz Alvares

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  SPDX-License-Identifier: MPL-2.0
]]

local arrmap = {}

function arrmap.arr_to_matrix(array, width)
  local matrix = {
    rect_tile_count = 0,
    line_count = 0,
    map_max_width = width,
  }

  local n = 0

  for _ = 1, #array do
    local line = {}

    for _ = 1, width do
      n = n + 1
      table.insert(line, array[n])
    end

    table.insert(matrix, line)
    matrix.line_count = matrix.line_count + 1
  end

  matrix.rect_tile_count = matrix.line_count * matrix.map_max_width

  return matrix
end

return arrmap
