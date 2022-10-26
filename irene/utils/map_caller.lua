-- map caller, an utility to generate code from a map matrix by calling macros

--[[
  Copyright (c) 2020-2022 André Luiz Alvares

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  SPDX-License-Identifier: MPL-2.0
]]

local tabler = require 'nelua.utils.tabler'

local function count_line_chars(line, char, pos)
  local count = 0
  for i = pos, #line do
    if line[i] == char then
      count = count + 1
    else
      break
    end
  end
  return count
end

local function count_column_char(matrix, char, pos_x, pos_y)
  local count = 0
  for i = pos_y, #matrix do
    if matrix[i][pos_x] == char then
      count = count + 1
    else
      break
    end
  end
  return count
end

local function erase_line(line, pos, count)
  for i = pos, pos+count-1 do
    line[i] = ''
  end
end

local function erase_column(matrix, pos_x, pos_y, count)
  for i = pos_y, pos_y+count-1 do
    matrix[i][pos_x] = ''
  end
end

local function map_caller(matrix, fn_all, fn_per_tile, fn_per_region)
  -- copy matrix to preserve original
  local matrix = tabler.imap(matrix, tabler.icopy)

  for i, line in ipairs(matrix) do
    for j, char in ipairs(line) do
      if fn_all then
        fn_all(j, i, char)
      end

      if fn_per_tile and fn_per_tile[char] then
        fn_per_tile[char](j, i)
      end
    end
  end

  if fn_per_region then
    for i, line in ipairs(matrix) do
      for j, char in ipairs(line) do
        if fn_per_region[char] then
          local count_h = count_line_chars(line, char, j)
          local count_v = count_column_char(matrix, char, j, i)

          if count_h >= count_v then
            erase_line(line, j, count_h)
            fn_per_region[char]({x=j, y=i, w=count_h, h=1})
          else
            erase_column(matrix, j, i, count_v)
            fn_per_region[char]({x=j, y=i, w=1, h=count_v})
          end
        end
      end
    end
  end
end

return map_caller
