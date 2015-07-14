--local robot = {}
robot = {}

function robot.name()
    return "test"
end

function robot.detect()
    return true, "solid"
end

function robot.detectUp()
    return true, "solid"
end

function robot.detectDown()
    return true, "solid"
end

function robot.select(slot)
    return 0
end

function robot.inventorySize()
    return 32
end

function robot.count(slot)
    return 32
end

function robot.space(slot)
    return 32
end

function robot.transferTo(slot, count)
    return true
end

function robot.compareTo(slot)
    return false
end

function robot.compare()
    return false
end

function robot.compareUp()
    return false
end

function robot.compareDown()
    return false
end

function robot.drop(count)
    return true
end

function robot.dropUp(count)
    return true
end

function robot.dropDown(count)
    return true
end

function robot.suck(count)
    return false
end

function robot.suckUp(count)
    return false
end

function robot.suckDown(count)
    return false
end

function robot.place(side, sneaky)
    return true
end

function robot.placeUp(side, sneaky)
    return true
end

function robot.placeDown(side, sneaky)
    return true
end

function robot.durability()
    return 1, 1, 1
end

function robot.durability(side, sneaky)
    return 1, 1, 1
end

function robot.swing()
    return true, "block"
end

function robot.swingUp()
    return true, "block"
end

function robot.swingDown()
    return true, "block"
end

function robot.use(side, sneaky, duration)
    return true, "block_activated "
end

function robot.useUp(side, sneaky, duration)
    return true, "block_activated "
end

function robot.useDown(side, sneaky, duration)
    return true, "block_activated "
end

function robot.useDown(side, sneaky, duration)
    return true, "block_activated "
end

function robot.forward()
    return true
end

function robot.back()
    return true
end

function robot.up()
    return true
end

function robot.down()
    return true
end

function robot.turnLeft()
end

function robot.turnRight()
end

function robot.turnAround()
end

-- пропущена работа с баками

--return robot

