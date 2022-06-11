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

return function (matrix, fn_all, fn_per_char, fn_per_region)
  for i, line in ipairs(matrix) do
    for j, char in ipairs(line) do
      if fn_all then
        fn_all(j, i, char)
      end

      if fn_per_char and fn_per_char[char] then
        fn_per_char[char](j, i)
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
