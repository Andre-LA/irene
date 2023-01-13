-- text map, reads a string text and converts to a map matrix

--[[
  Copyright (c) 2020-2022 André Luiz Alvares

  This Source Code Form is subject to the terms of the Mozilla Public
  License, v. 2.0. If a copy of the MPL was not distributed with this
  file, You can obtain one at https://mozilla.org/MPL/2.0/.

  SPDX-License-Identifier: MPL-2.0
]]

local textmap = {}

local NL <const> = utf8.codepoint'\n'

function textmap.from_text(text)
  local matrix = {
    line_count = 0,
    map_max_width = 0,
    rect_tile_count = 0
  }

  for line in string.gmatch(text, '([%g ]+)\n') do
    table.insert(matrix, {})
    matrix.line_count = matrix.line_count + 1

    if #line > matrix.map_max_width then
      matrix.map_max_width = #line
    end

    for c = 1, #line do
      table.insert(matrix[#matrix], line:sub(c, c))
    end
  end

  matrix.rect_tile_count = matrix.line_count * matrix.map_max_width

  return matrix
end

function textmap.from_utf8_text(text)
  local matrix = {
    {},
    line_count = 0,
    map_max_width = 0,
    rect_tile_count = 0
  }

  for _, codepoint in utf8.codes(text) do
    if codepoint == NL then
      if #matrix[#matrix] > matrix.map_max_width then
        matrix.map_max_width = #matrix[#matrix]
      end

      table.insert(matrix, {})
      matrix.line_count = matrix.line_count + 1
    else
      table.insert(matrix[#matrix], codepoint)
    end
  end

  matrix.rect_tile_count = matrix.line_count * matrix.map_max_width

  return matrix
end

return textmap
