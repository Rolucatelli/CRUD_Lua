ProductController = {}
ProductController.__index = ProductController

function ProductController.insert(product)
    local pName = product:getName()
    local price = product:getListPrice()
    local col = "("
    local lin = "("

    col = col .. "id, productName"
    lin = lin .. product:getId()
    lin = lin .. ", \"" .. pName .. "\""

    if product:getShortDescription() ~= nil and product:getShortDescription() ~= "" then
        col = col .. ", shortDescription"
        lin = lin .. ", \"" .. product:getShortDescription() .. "\""
    end

    if product:getBrand() ~= nil and product:getBrand() ~= "" then
        col = col .. ", brand"
        lin = lin .. ", \"" .. product:getBrand() .. "\""
    end

    if product:getCategory() ~= nil and product:getCategory() ~= "" then
        col = col .. ", category"
        lin = lin .. ", \"" .. product:getCategory() .. "\""
    end

    col = col .. ", listPrice"
    lin = lin .. ", " .. price

    if product:getCost() >= 0.0 then
        col = col .. ", cost"
        lin = lin .. ", " .. product:getCost()
    end

    col = col .. ")"
    lin = lin .. ")"
    DataBaseUtility.insert(col, lin)
end

function ProductController.update(oldP, newP)
    local firstItem = true
    local sql = ""

    if oldP:getName() ~= newP:getName() then
        sql = sql .. "productName = \"" .. newP:getName() .. "\""
        firstItem = false
    end

    if not (newP:getShortDescription() == nil and oldP:getShortDescription() == nil) then
        if oldP:getShortDescription() == nil then
            if oldP:getShortDescription() ~= newP:getShortDescription() then
                if not firstItem then sql = sql .. ", " end
                sql = sql .. "shortDescription = \"" .. newP:getShortDescription() .. "\""
                firstItem = false
            end
        else
            if not firstItem then sql = sql .. ", " end
            sql = sql .. "shortDescription = null"
            firstItem = false
        end
    end

    if not (newP:getBrand() == nil and oldP:getBrand() == nil) then
        if oldP:getBrand() == nil then
            if oldP:getBrand() ~= newP:getBrand() then
                if not firstItem then sql = sql .. ", " end
                sql = sql .. "brand = \"" .. newP:getBrand() .. "\""
                firstItem = false
            end
        else
            if not firstItem then sql = sql .. ", " end
            sql = sql .. "brand = null"
            firstItem = false
        end
    end

    if not (newP:getCategory() == nil and oldP:getCategory() == nil) then
        if oldP:getCategory() == nil then
            if newP:getCategory() ~= oldP:getCategory() then
                if not firstItem then sql = sql .. ", " end
                sql = sql .. "category = \"" .. newP:getCategory() .. "\""
                firstItem = false
            end
        else
            if not firstItem then sql = sql .. ", " end
            sql = sql .. "category = null"
            firstItem = false
        end
    end

    if oldP:getListPrice() ~= newP:getListPrice() then
        if not firstItem then sql = sql .. ", " end
        sql = sql .. "listPrice = " .. newP:getListPrice()
        firstItem = false
    end

    if oldP:getCost() ~= newP:getCost() then
        if not firstItem then sql = sql .. ", " end
        if newP:getCost() < 0 then
            sql = sql .. "cost = null"
        else
            sql = sql .. "cost = " .. newP:getCost()
        end
    end

    DataBaseUtility.update(sql, oldP:getId())
end

function ProductController.consult(id)
    return DataBaseUtility.getProduct(id)
end

function ProductController.delete(id)
    local temp = DataBaseUtility.getProduct(id)
    if temp == nil then
        error("Product is null. It must be something", 2)
    end
    DataBaseUtility.delete(id)
end

function ProductController.getIdByProductName(name)
    return DataBaseUtility.getProductByName(name):getId()
end

function ProductController.getAllProducts()
    return DataBaseUtility.getAllProducts()
end
