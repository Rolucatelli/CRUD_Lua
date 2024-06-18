local fusio = require("fusio")
local FXMLLoader = require("fusio.fxml.FXMLLoader")
local Image = require("fusio.scene.image.Image")
local Stage = require("fusio.stage.Stage")
local Scene = require("fusio.scene.Scene")

local Main = {}

function Main:main(args)
    fusio.application.start(self)
end

function Main:start(stage)
    local root
    local ok, err = pcall(function()
        root = FXMLLoader:load("main.fxml")
    end)
    if not ok then
        print(err)
        return
    end

    stage:setTitle("Sistema")
    stage:setScene(Scene.new(root))
    stage:show()
end

return Main
