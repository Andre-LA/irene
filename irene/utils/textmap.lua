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
  local matrix = {}
  for line in string.gmatch(text, '([%g ]+)\n') do
    table.insert(matrix, {})
    for c = 1, #line do
      table.insert(matrix[#matrix], line:sub(c, c))
    end
  end
  return matrix
end

function textmap.from_utf8_text(text)
  local matrix = { {} }
  for _, codepoint in utf8.codes(text) do
    if codepoint == NL then
      table.insert(matrix, {})
    else
      table.insert(matrix[#matrix], codepoint)
    end
  end
  return matrix
end

return textmap
