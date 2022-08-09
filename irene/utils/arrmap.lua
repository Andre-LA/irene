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
  local matrix = {}

  local n = 0

  for _ = 1, #array do
    local line = {}

    for _ = 1, width do
      n = n + 1
      table.insert(line, array[n])
    end

    table.insert(matrix, line)
  end

  return matrix
end

return arrmap
