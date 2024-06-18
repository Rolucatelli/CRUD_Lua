DataBaseUtility = {}
DataBaseUtility.__index = DataBaseUtility

local mysql = require "luasql.mysql"

function DataBaseUtility.getConnection()
    local env = mysql.mysql()
    local conn = env:connect("mydb", "Rodrigo", "123456", "localhost", 3306)
    if not conn then
        error("Could not connect to the database")
    end
    return conn
end

function DataBaseUtility.insert(col, val)
    local sql = "INSERT INTO products " .. col .. " VALUES " .. val
    local conn = DataBaseUtility.getConnection()
    local stmt = conn:execute(sql)
    stmt:close()
    conn:close()
end

function DataBaseUtility.update(col, id)
    local sql = "UPDATE products SET " .. col .. " WHERE id = " .. id
    local conn = DataBaseUtility.getConnection()
    local stmt = conn:execute(sql)
    stmt:close()
    conn:close()
end

function DataBaseUtility.delete(id)
    local sql = "DELETE FROM products WHERE id = " .. id
    local conn = DataBaseUtility.getConnection()
    local stmt = conn:execute(sql)
    stmt:close()
    conn:close()
end

function DataBaseUtility.getProduct(id)
    local sql = "SELECT * FROM products WHERE id = ?"
    local conn = DataBaseUtility.getConnection()
    local stmt = conn:prepare(sql)
    stmt:bind_param(1, id)
    return DataBaseUtility.getProductFromStatement(conn, stmt)
end

function DataBaseUtility.getProductByName(name)
    local sql = "SELECT * FROM products WHERE productName = ?"
    local conn = DataBaseUtility.getConnection()
    local stmt = conn:prepare(sql)
    stmt:bind_param(1, name)
    return DataBaseUtility.getProductFromStatement(conn, stmt)
end

function DataBaseUtility.getProductFromStatement(conn, stmt)
    local product = nil
    local cursor = stmt:execute()
    local row = cursor:fetch({}, "a")
    if row then
        if tonumber(row.cost) == 0 then
            product = Product.new(row.id, row.productName, row.shortDescription, row.brand, row.category, tonumber(row.listPrice), nil)
        else
            product = Product.new(row.id, row.productName, row.shortDescription, row.brand, row.category, tonumber(row.listPrice), tonumber(row.cost))
        end
    end
    cursor:close()
    conn:close()
    return product
end

function DataBaseUtility.getAllProducts()
    local sql = "SELECT * FROM products"
    local conn = DataBaseUtility.getConnection()
    local stmt = conn:prepare(sql)
    local cursor = stmt:execute()
    local list = {}

    local row = cursor:fetch({}, "a")
    while row do
        if tonumber(row.cost) == 0 then
            table.insert(list, Product.new(row.id, row.productName, row.shortDescription, row.brand, row.category, tonumber(row.listPrice), nil))
        else
            table.insert(list, Product.new(row.id, row.productName, row.shortDescription, row.brand, row.category, tonumber(row.listPrice), tonumber(row.cost)))
        end
        row = cursor:fetch({}, "a")
    end
    cursor:close()
    conn:close()
    return list
end
