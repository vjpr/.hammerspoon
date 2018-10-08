function tableLength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function tableMerge(t1, t2)
  for k,v in pairs(t2) do
    if type(v) == "table" then
      if type(t1[k] or false) == "table" then
        tableMerge(t1[k] or {}, t2[k] or {})
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end

function dump(o)
   if type(o) == 'table' then
      local s = '{\n'
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ',\n'
      end
      return s .. '} \n'
   else
      return tostring(o)
   end
end

function tableConcat(t1, t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

-- table.filter({"a", "b", "c", "d"}, function(o, k, i) return o >= "c" end)  --> {"c","d"}
--
-- @FGRibreau - Francois-Guillaume Ribreau
-- @Redsmin - A full-feature client for Redis http://redsmin.com
table.filter = function(t, filterIter)
  local out = {}

  for k, v in pairs(t) do
    if filterIter(v, k, t) then out[k] = v end
  end

  return out
end

function printObj(obj, hierarchyLevel) 
  if (hierarchyLevel == nil) then
    hierarchyLevel = 0
  elseif (hierarchyLevel == 4) then
    return 0
  end

  local whitespace = ""
  for i=0,hierarchyLevel,1 do
    whitespace = whitespace .. "-"
  end
  io.write(whitespace)

  print(obj)
  if (type(obj) == "table") then
    for k,v in pairs(obj) do
      io.write(whitespace .. "-")
      if (type(v) == "table") then
        printObj(v, hierarchyLevel+1)
      else
        print(v)
      end           
    end
  else
    print(obj)
  end
end