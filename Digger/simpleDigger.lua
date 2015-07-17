local moves = require("smartMoves")
local robot = require("robot")
local computer = require("computer")
local term = require("term")
local component = require("component")
local invController = component.inventory_controller

local function selectSlotWithTorch()
    local item = invController.getStackInInternalSlot()
    if item ~= nil and item.label == "Torch" then
        return true
    end

    for i = 1, robot.inventorySize() do
        local itemData = invController.getStackInInternalSlot(i)
        if itemData ~= nil and itemData.label == "Torch" then
            robot.select(i)
            return true
        end
    end

    return false
end

local function putTorch()
    if not selectSlotWithTorch() then
        return false
    end
    moves.turnLeft()
    robot.swing()
    robot.place()
    moves.turnRight()
    return true
end

local function dig()
    local minEnergyLevel = 0.3 * computer.maxEnergy() 
    local tillInventoryCheck = 30
    local tillTorch = 0
    local stepCount = 0

    while true do
        if not moves.forward() then
            print("Way is blocked")
            return
        end

        robot.swingUp()
        robot.swingDown()

        if computer.energy() < minEnergyLevel then
            print("Low energy")
            return
        end

        if robot.durability() < 0.1 then
            print("Tool is nearly broken")
            return
        end

        if tillTorch == 0 then
            tillTorch = 10
            if not putTorch() then
                print("Out of torches")
                return 
            end
        end

        if tillInventoryCheck == 0 then
            tillInventoryCheck = 30
            if not moves.dropGarbage(3) then 
                print("Inventory full")
                return 
            end

            term.clear()
            print(stepCount.." steps")
        end

        stepCount = stepCount + 1
        tillInventoryCheck = tillInventoryCheck - 1
        tillTorch = tillTorch - 1
    end
end

moves.forward(20)
moves.turnRight()
dig()
moves.goToAbs(0,0,0,"yxz")
moves.turnAround()
computer.shutdown()
