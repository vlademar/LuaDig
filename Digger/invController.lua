invController = {}

function invController.getInventorySize(side)
    return nil, "no inventory"
end

function invController.getStackInSlot(side, slot)
    return { damage = 0.5, maxDamage = 1, size = 1, maxSize = 1, id = 0, name = "none", hasTag = false }
end

function invController.getStackInInternalSlot(slot)
    return { damage = 0.5, maxDamage = 1, size = 1, maxSize = 1, id = 0, name = "none", hasTag = false }
end

function invController.dropIntoSlot(side, slot, count)
    return true
end

function invController.suckFromSlot(side, slot, count)
    return true
end

function invController.equip()
    return true
end



