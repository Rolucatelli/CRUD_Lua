local Controller = {}

local ObservableList = require("fusio.collections.ObservableList")
local TableView = require("fusio.controls.TableView")
local TableColumn = require("fusio.controls.TableColumn")
local TextField = require("fusio.controls.TextField")
local Label = require("fusio.controls.Label")
local PropertyValueFactory = require("fusio.controls.cell.PropertyValueFactory")
local Product = require("projeto.crud_java.beans.Product")
local ProductController = require("projeto.crud_java.tables.ProductController")

function Controller:init()
    self.id = TextField.new()
    self.prodName = TextField.new()
    self.shortDescription = TextField.new()
    self.brand = TextField.new()
    self.category = TextField.new()
    self.listPrice = TextField.new()
    self.cost = TextField.new()
    self.searchField = TextField.new()

    self.table = TableView.new()

    self.idCol = TableColumn.new()
    self.nameCol = TableColumn.new()
    self.shortDescriptionCol = TableColumn.new()
    self.brandCol = TableColumn.new()
    self.categoryCol = TableColumn.new()
    self.listPriceCol = TableColumn.new()
    self.costCol = TableColumn.new()
    self.errorMessage = Label.new()
    self.nameErrorMessage = Label.new()
    self.listPriceValueErrorMessage = Label.new()
    self.listPriceNullErrorMessage = Label.new()

    self.list = ObservableList.new(self:loadTable())

    self.table:getColumns():add(self.idCol)
    self.table:getColumns():add(self.nameCol)
    self.table:getColumns():add(self.shortDescriptionCol)
    self.table:getColumns():add(self.brandCol)
    self.table:getColumns():add(self.categoryCol)
    self.table:getColumns():add(self.listPriceCol)
    self.table:getColumns():add(self.costCol)

    self.idCol:setCellValueFactory(PropertyValueFactory.new("id"))
    self.nameCol:setCellValueFactory(PropertyValueFactory.new("name"))
    self.shortDescriptionCol:setCellValueFactory(PropertyValueFactory.new("shortDescription"))
    self.brandCol:setCellValueFactory(PropertyValueFactory.new("brand"))
    self.categoryCol:setCellValueFactory(PropertyValueFactory.new("category"))
    self.listPriceCol:setCellValueFactory(PropertyValueFactory.new("listPrice"))
    self.costCol:setCellValueFactory(PropertyValueFactory.new("costString"))
    self.table:setItems(self.list)

    self.table:getSelectionModel():selectedItemProperty():addListener(function(observable, oldValue, newValue)
        if newValue ~= nil then
            self.id:setText(tostring(newValue:getId()))
            self.prodName:setText(newValue:getName())
            self.shortDescription:setText(newValue:getShortDescription())
            self.brand:setText(newValue:getBrand())
            self.category:setText(newValue:getCategory())
            self.listPrice:setText(tostring(newValue:getListPrice()))
            self.cost:setText(newValue:getCostString())
        end
    end)

    self:initialize(nil, nil)
end

function Controller:create()
    self:clearErrorMessages()
    if self.listPrice:getText() == "" then
        if self.prodName:getText() == "" then
            self.nameErrorMessage:setVisible(true)
            self.listPriceNullErrorMessage:setVisible(true)
            return
        end
        self.listPriceNullErrorMessage:setVisible(true)
        return
    end

    local cst = self.cost:getText() == "" and -1.0 or tonumber(self.cost:getText())

    local product = Product.new(Product.findNextId(), self.prodName:getText(), self.shortDescription:getText(), self.brand:getText(), self.category:getText(), tonumber(self.listPrice:getText()), cst)

    ProductController.insert(product)
    self:clearTextFields()
    self:reloadTable()
end

function Controller:update()
    self:clearErrorMessages()
    if self.listPrice:getText() == "" then
        if self.prodName:getText() == "" then
            self.nameErrorMessage:setVisible(true)
            self.listPriceNullErrorMessage:setVisible(true)
            return
        end
        self.listPriceNullErrorMessage:setVisible(true)
        return
    end

    local cst = self.cost:getText() == "" and -1.0 or tonumber(self.cost:getText())

    local oldProduct = ProductController.consult(tonumber(self.id:getText()))
    local newProduct = Product.new(tonumber(self.id:getText()), self.prodName:getText(), self.shortDescription:getText(), self.brand:getText(), self.category:getText(), tonumber(self.listPrice:getText()), cst)
    ProductController.update(oldProduct, newProduct)
    self:clearTextFields()
    self:reloadTable()
end

function Controller:search()
    self:clearErrorMessages()
    if self.searchField:getText() ~= "" then
        local product = ProductController.consult(ProductController.getIdByProductName(self.searchField:getText()))
        self.table:getItems():clear()
        self.table:getItems():add(product)
    else
        self:reloadTable()
    end
end

function Controller:delete()
    self:clearErrorMessages()
    ProductController.delete(tonumber(self.id:getText()))
    Product.removeId(tonumber(self.id:getText()))
    self:clearTextFields()
    self:reloadTable()
end

function Controller:loadTable()
    return ProductController.getAllProducts()
end

function Controller:reloadTable()
    self.table:getItems():setAll(self:loadTable())
end

function Controller:clearTextFields()
    self.id:clear()
    self.prodName:clear()
    self.shortDescription:clear()
    self.brand:clear()
    self.category:clear()
    self.listPrice:clear()
    self.cost:clear()
end

function Controller:clearErrorMessages()
    self.listPriceValueErrorMessage:setVisible(false)
    self.listPriceNullErrorMessage:setVisible(false)
    self.nameErrorMessage:setVisible(false)
    self.errorMessage:setVisible(false)
end

function Controller:initialize(url, resourceBundle)
    self.table:getSelectionModel():selectedItemProperty():addListener(function(observable, oldValue, newValue)
        if newValue ~= nil then
            self.id:setText(tostring(newValue:getId()))
            self.prodName:setText(newValue:getName())
            self.shortDescription:setText(newValue:getShortDescription())
            self.brand:setText(newValue:getBrand())
            self.category:setText(newValue:getCategory())
            self.listPrice:setText(tostring(newValue:getListPrice()))
            self.cost:setText(newValue:getCostString())
        end
    end)

    Product.readIds()
end

return Controller
