
Player = Class{}

function Player:init()
    self.x = 400
    self.y = 200
    self.speed = 300
    self.spriteSheet = love.graphics.newImage('images/characters/boy-charecter.png')
    self.grid = anim8.newGrid( 12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight() )

    self.width = 12
    self.height = 16

    self.collider = world:newBSGRectangleCollider(self.x, self.y, 8*6, 14*6, 10)
    self.collider:setCollisionClass('Player')
    self.collider:setFixedRotation(true)

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid('1-4', 1), 0.1 )
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.1 )
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.1 )
    self.animations.up = anim8.newAnimation( self.grid('1-4', 4), 0.1 )

    self.anim = self.animations.down
end

function Player:update(dt)
    local isMoving = false

    local vx = 0
    local vy = 0

    if love.keyboard.isDown("right") then
        vx = self.speed
        self.anim = self.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        vx = - self.speed
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        vy = self.speed
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        vy = - self.speed
        self.anim = self.animations.up
        isMoving = true
    end

    if not isMoving then
        self.anim:gotoFrame(2)
    end

    self.collider:setLinearVelocity(vx, vy)

    self.x = self.collider:getX()
    self.y = self.collider:getY()
    self.anim:update(dt)

    -- map borders provider
    if self.y <= 0 + 8*6 then
        self.collider:setLinearVelocity(vx, math.max(0, vy))
    end
    if self.y >= MAP_HEIGHT - 8*6 then
        self.collider:setLinearVelocity(vx, math.min(0, vy))
    end
    if self.x <= 0 + 5*6 then
        self.collider:setLinearVelocity(math.max(0, vx), vy)
    end
    if self.x >= MAP_WIDTH - 5*6 then
        self.collider:setLinearVelocity(math.min(0, vx), vy)
    end
    --corners
    if self.y <= 0 + 8*6 and self.x <= 0 + 5*6 then
        self.collider:setLinearVelocity(math.max(0, vx), math.max(0, vy))
    end
    if self.y >= MAP_HEIGHT - 8*6 and self.x <= 0 + 5*6 then
        self.collider:setLinearVelocity(math.max(0, vx), math.min(0, vy))
    end
    if self.y <= 0 + 8*6 and self.x >= MAP_WIDTH - 5*6 then
        self.collider:setLinearVelocity(math.min(0, vx), math.max(0, vy))
    end
    if self.y >= MAP_HEIGHT - 8*6 and self.x >= MAP_WIDTH - 5*6 then
        self.collider:setLinearVelocity(math.min(0, vx),  math.min(0, vy))
    end

end

function Player:render()
    self.anim:draw(player.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
end