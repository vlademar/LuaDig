smartMoves = { }

local math = require("math")
local robot = require("robot")
local sides = require("sides")
local component = require("component")
local invController = component.inventory_controller

local garbageList = 
{
    "Stone",
    "Cobblestone",
    "Dirt",
    "Gravel"
}

local face = sides.forward
local x, y, z = 0, 0, 0
local dX, dZ = 0, 1 

local function updateMoveDeltas()
    if face == sides.left then
        dX, dZ = 1, 0
    elseif face == sides.back then
        dX, dZ = 0, -1
    elseif face == sides.right then
        dX, dZ = -1, 0
    elseif face == sides.forward then
        dX, dZ = 0, 1
    end
end

function smartMoves.turnLeft()
    robot.turnLeft()

    if face == sides.forward then
        face = sides.left
    elseif face == sides.left then
        face = sides.back
    elseif face == sides.back then
        face = sides.right
    elseif face == sides.right then
        face = sides.forward
    end

    updateMoveDeltas()
end

function smartMoves.turnRight()
    robot.turnRight()

    if face == sides.back then
        face = sides.left
    elseif face == sides.right then
        face = sides.back
    elseif face == sides.forward then
        face = sides.right
    elseif face == sides.left then
        face = sides.forward
    end

    updateMoveDeltas()
end

function smartMoves.turnAround()
    robot.turnAround()

    if face == sides.back then
        face = sides.front
    elseif face == sides.right then
        face = sides.left
    elseif face == sides.forward then
        face = sides.back
    elseif face == sides.left then
        face = sides.right
    end

    updateMoveDeltas()
end

function smartMoves.face(dir)
    if ( face == sides.north and dir == sides.east ) or
       ( face == sides.east and dir == sides.south ) or
       ( face == sides.south and dir == sides.west ) or
       ( face == sides.west and dir == sides.north ) then
       return smartMoves.turnRight()       
    end

    if ( face == sides.north and dir == sides.west ) or
       ( face == sides.west and dir == sides.south ) or
       ( face == sides.south and dir == sides.east ) or
       ( face == sides.east and dir == sides.north ) then
       return smartMoves.turnLeft()
    end

    if ( face == sides.north and dir == sides.south ) or
       ( face == sides.south and dir == sides.north ) or
       ( face == sides.east and dir == sides.west ) or
       ( face == sides.west and dir == sides.east ) then
       return smartMoves.turnAround()
    end
end

function smartMoves.forward(stepCount)
    local stepCount = stepCount or 1

    if stepCount < 0 then
        local ok, count = smartMoves.back(-stepCount)
        return ok, -count
    end

    for stepNo = 1, stepCount do
        local attempt, moved, err = 0, false

        while attempt < 10 and not moved do
            moved, err = robot.forward()
            
            if moved then
                x, z = x + dX, z + dZ
            elseif err == "impossible move" then
                return false, stepNo - 1
            else
                robot.swing()
                attempt = attempt + 1
            end
        end
    end

    return true, stepCount
end

function smartMoves.back(stepCount)
    local stepCount = stepCount or 1 

    if stepCount < 0 then
        local ok, count = smartMoves.forward(-stepCount)
        return ok, -count
    end

    smartMoves.turnAround()

    local ok, count = smartMoves.forward(stepCount)
    
    smartMoves.turnAround()
    
    return ok, count
end
 
function smartMoves.up(stepCount)
    local stepCount = stepCount or 1
    
    if stepCount < 0 then
        local ok, count = smartMoves.down(-stepCount)
        return ok, -count
    end

    for stepNo = 1, stepCount do
        local attempt, moved, err = 0, false

        while attempt < 10 and not moved do
            moved, err = robot.up()
            
            if moved then
                y = y + 1
            elseif err == "impossible move" then
                return false, stepNo - 1
            else
                robot.swingUp()
                attempt = attempt + 1
            end
        end
    end

    return true, stepCount
end
 
function smartMoves.down(stepCount)
    local stepCount = stepCount or 1

    if stepCount < 0 then
        local ok, count = smartMoves.up(-stepCount)
        return ok, -count
    end

    for stepNo = 1, stepCount do
        local attempt, moved, err = 0, false

        while attempt < 10 and not moved do
            moved, err = robot.down()
            
            if moved then
                y = y - 1
            elseif err == "impossible move" then
                return false, stepNo - 1
            else
                robot.swingDown()
                attempt = attempt + 1
            end
        end
    end

    return true, stepCount
end

function smartMoves.goToAbs(absX, absY, absZ, mode)
    deltaX = ( absX or x ) - x
    deltaY = ( absY or y ) - y
    deltaZ = ( absZ or z ) - z

    return smartMoves.goToRel(deltaX, deltaY, deltaZ, mode)
end

function smartMoves.goToRel(deltaX, deltaY, deltaZ, mode)
    deltaX = ( deltaX or 0 )
    deltaY = ( deltaY or 0 )
    deltaZ = ( deltaZ or 0 )
    mode = mode or "yxz"

    if mode == "yxz" then
        if not smartMoves.up(deltaY) then
            return false
        end

        if deltaX >= 0 then
            smartMoves.face(sides.posx)
        else 
            smartMoves.face(sides.negx)
        end

        if not smartMoves.forward(math.abs(deltaX)) then 
            return false
        end

        if deltaZ >= 0 then
            smartMoves.face(sides.posz)
        else 
            smartMoves.face(sides.negz)
        end

        if not smartMoves.forward(math.abs(deltaZ)) then 
            return false
        end
    elseif mode == "zxy" then
        if deltaZ >= 0 then
            smartMoves.face(sides.posz)
        else 
            smartMoves.face(sides.negz)
        end

        if not smartMoves.forward(math.abs(deltaZ)) then 
            return false
        end 
        
        if deltaX >= 0 then
            smartMoves.face(sides.posx)
        else 
            smartMoves.face(sides.negx)
        end

        if not smartMoves.forward(math.abs(deltaX)) then 
            return false
        end

        if not smartMoves.up(deltaY) then
            return false
        end
    else
        print("smartMoves.goTo : invalid move mode")
        return false
    end

    return true
end

local function countFreeSlots()
    local freeSlots = 0

    for i = 1, robot.inventorySize() do
        local space = robot.space(i)
        local count = robot.count(i)
        if count > space * 3 then
            freeSlots = freeSlots + 1
        end
    end

    return freeSlots
end

local function itemIsInGarbageList(itemData)
    local label = itemData.label
    for _, name in pairs(garbageList) do
        if name == label then
            return true
        end
    end
    return false
end

function smartMoves.dropGarbage(minFreeSlotsCont)
    minFreeSlotsCont = minFreeSlotsCont or 5

    if countFreeSlots() >= minFreeSlotsCont then
        return true
    end

    for i = 1, robot.inventorySize() do
        local itemData = invController.getStackInInternalSlot(i)
        if itemData ~= nil and itemIsInGarbageList(itemData) then
            robot.select(i)
            robot.drop()
        end
    end

    return countFreeSlots() >= minFreeSlotsCont
end

return smartMoves