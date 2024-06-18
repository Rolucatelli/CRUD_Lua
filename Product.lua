Product = {}
Product.__index = Product

local idSet = {}

function Product.new(id, name, shortDescription, brand, category, listPrice, cost)
    if name == nil or name == '' then
        error("Name can't be null", 2)
    end
    if listPrice < 0 then
        error("List Price can't be negative", 2)
    end

    local self = setmetatable({}, Product)
    self.id = id
    self.name = name
    self.shortDescription = shortDescription
    self.brand = brand
    self.category = category
    self.listPrice = listPrice
    self.cost = cost or -1.0
    self.costString = tostring(self.cost)
    return self
end

function Product.new_with_cost_string(id, name, shortDescription, brand, category, listPrice, cost)
    if name == nil or name == '' then
        error("Name can't be null", 2)
    end
    if listPrice < 0 then
        error("List Price can't be negative", 2)
    end

    local self = setmetatable({}, Product)
    self.id = id
    self.name = name
    self.shortDescription = shortDescription
    self.brand = brand
    self.category = category
    self.listPrice = listPrice
    self.costString = cost
    return self
end

function Product.new_no_cost(id, name, shortDescription, brand, category, listPrice)
    return Product.new(id, name, shortDescription, brand, category, listPrice, -1.0)
end

function Product.new_with_brand(id, name, shortDescription, brand, listPrice)
    return Product.new(id, name, shortDescription, brand, nil, listPrice, -1.0)
end

function Product.new_with_short_description(id, name, shortDescription, listPrice)
    return Product.new(id, name, shortDescription, nil, nil, listPrice, -1.0)
end

function Product.new_basic(id, name, listPrice)
    return Product.new(id, name, nil, nil, nil, listPrice, -1.0)
end

function Product.findNextId()
    local i = 1
    while idSet[i] do
        i = i + 1
    end
    idSet[i] = true
    return i
end

function Product.removeId(id)
    idSet[id] = nil
end

function Product.readIds()
    local linkedList = ProductController.getAllProducts()
    for i = 1, #linkedList do
        idSet[linkedList[i]:getId()] = true
    end
end

function Product:getId()
    return self.id
end

function Product:getName()
    return self.name
end

function Product:getShortDescription()
    return self.shortDescription
end

function Product:getBrand()
    return self.brand
end

function Product:getCategory()
    return self.category
end

function Product:getListPrice()
    return self.listPrice
end

function Product:getCost()
    return self.cost
end

function Product:getCostString()
    return self.costString
end
