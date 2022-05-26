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
