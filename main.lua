require 'src/dependencies'

function love.load()
    cam = camera()
    world = wf.newWorld(0, 0)
    world:addCollisionClass('Tree')
    world:addCollisionClass('Player')
    world:addCollisionClass('Item')
    world:addCollisionClass('Door')
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Pixie')
    gameMap = sti('maps/test_map.lua')
    world:setQueryDebugDrawing(true) 

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    player = Player()
    lightManager = LightManager()
    itemManager = ItemManager()
    -- itemManager:addItems({{'apple', 100, 200}, {'apple', 300, 300}, {'pear', 230, 120}})
    itemManager:addItem('apple', 100, 200)
    itemManager:addItem('apple', 300, 300)
    itemManager:addItem('pear', 230, 120)
    itemManager:addItem('corn', 185, 400)
    itemManager:addItem('orange', 132, 103)
    itemManager:addItem('pomegranate', 174, 302)
    itemManager:addItem('strawberry', 20, 123)
    itemManager:addItem('tomato', 140, 211)
    itemManager:addItem('watermelon', 320, 249)
    itemManager:addItem('corn', 400, 400)
    createPortal(705, 1090, 63, 125)
    playerBackpack = BackpackManager(player.backpack)

    trees = TreeMaker()
    trees:findTrees()

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.update(dt)
    player:update(dt)
    trees:update(dt)
    -- apple:update(dt)
    cam:lookAt(player.x, player.y)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- left side limit for camera
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- top limit for camera
    if cam.y < h/2 then
        cam.y = h/2
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- right side limit for camera
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2) 
    end

    -- bottom limit for camera
    if cam.y > (mapH -h/2) then
        cam.y = (mapH -h/2)
    end

    -- lightManager:update(dt)
    itemManager:update()
    world:update(dt)
    playerBackpack:update(dt)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()

    cam:attach()
        -- gameMap:draw()
        gameMap:drawLayer(gameMap.layers['ground'])
        gameMap:drawLayer(gameMap.layers['home'])



        trees:renderTreesAbove()
        -- apple:renderItemAbove()
        itemManager:renderItemAbove()
        player:render()
        trees:renderTreesBelow()
        itemManager:renderItemBelow()

        --world:draw()
        lightManager:render()
    cam:detach()

    playerBackpack:render()
end


function love.keyboard.wasPressed(key)

    return love.keyboard.keysPressed[key]
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function createPortal(x, y, width, height)
    door = world:newRectangleCollider(x, y, width, height)
    door:setCollisionClass('Door')
    -- door:setFixedRotation(true)
    door:setType('static')
end