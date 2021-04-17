local tabler = require 'nelua.utils.tabler'
local inspect = require 'nelua.thirdparty.inspect'

local metalib = {}

function metalib.get_var_field_codestr(rec, fname)
   -- check if this actually exists at compile time
   assert(rec.type:get_field(fname), "field %s.%s don't exist", rec.nickname, fname)
   local recname = assert(rec.name, 'rec.name is nil (rec is: %s)', rec)
   return string.format('%s.%s', recname, fname)
end

function metalib.tableunion(a,b)
   local t={}

   for i=1,#a do
      table.insert(t, a[i])
   end
   for i=1,#b do
      table.insert(t, b[i])
   end

   return t
end

function metalib.collect_doubles(start, _end, ...)
   local args, first, second = {...}, {}, {}

   if _end == nil or _end < 0 then
      _end = #args
   end

   for i = start, _end, 2 do
      table.insert(first, args[i])
      table.insert(second, args[i+1])
   end

   return first, second
end

function metalib.create_id_nodes(aster, names)
   local function name_to_id(name) return aster.Id{name} end
   return tabler.imap(names, name_to_id)
end

function metalib.create_call_node(aster, T, func_name, ...)
   return aster.Call{
      {...},
      aster.DotIndex{ func_name, aster.Id{ T.nickname } }
   }
end

function metalib.basic_typecheck(value, type_expected, custom_typechecker)
  local typechecker = custom_typechecker or type
  local value_type = typechecker(value)

  if value_type == type_expected or value_type == true then
    return value
  else
    return nil, string.format('"%s" expected, got "%s"', type_expected, value_type)
  end
end

function metalib.basic_arg_typecheck(argnumber, argname, argvalue, type_expected, custom_typechecker)
  local typecheck_result, err_msg = metalib.basic_typecheck(value, type_expected, custom_typechecker)
  if not typecheck_result then
    return nil, string.format('on #%s argument "%s", %s', argnumber, argname, err_msg)
  else
    return typecheck_result
  end
end

function metalib.pascalcase_to_snakecase(s)
  local words = {}

  for w in string.gmatch(s, "(%u%l*)") do
    table.insert(words, string.lower(w))
  end

  if #words > 0 then
    return table.concat(words, '_')
  else
    return s
  end
end

function metalib.ins(v, d)
  return inspect(v, {depth = d or 1})
end

return metalib
