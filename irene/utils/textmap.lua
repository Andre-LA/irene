local ins = require 'inspect'
local textmap = {}

local NL <const> = utf8.codepoint'\n'

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

local function text_to_char_matrix(text)
  local matrix = {}
  for line in string.gmatch(text, '([%g ]+)\n') do
    table.insert(matrix, {})
    for c = 1, #line do
      table.insert(matrix[#matrix], line:sub(c, c))
    end
  end
  return matrix
end

local function utf8_text_to_char_matrix(text)
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

local function iter_and_call(matrix, fn_all, fn_per_char, fn_per_region)
  for i, line in ipairs(matrix) do
    for j, char in ipairs(line) do
      fn_all(j, i, char)

      if fn_per_char[char] then
        fn_per_char[char](j, i)
      end
    end
  end

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

function textmap.from_text(text, fn_all, fn_per_char, fn_per_region)
  local map_matrix = text_to_char_matrix(text)
  iter_and_call(map_matrix, fn_all, fn_per_char, fn_per_region)
end

function textmap.from_utf8_text(text, fn_all, fn_per_char, fn_per_region)
  local map_matrix = utf8_text_to_char_matrix(text)
  iter_and_call(map_matrix, fn_all, fn_per_char, fn_per_region)
end

return textmap
