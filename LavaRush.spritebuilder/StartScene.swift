import Foundation
import CoreMotion

public extension Int {
    static func random(range: Range<Int> ) -> Int {
        var offset = 0
        if range.startIndex < 0 {
            offset = abs(range.startIndex)
        }
        
        let mini = UInt32(range.startIndex + offset)
        let maxi = UInt32(range.endIndex   + offset)
        
        return Int(mini + arc4random_uniform(maxi - mini)) - offset
    }
}

class StartScene: CCNode {
    
    weak var hero: CCSprite!
    weak var ground: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
    weak var background: CCNode!
    weak var sunMidground: CCNode!
    weak var scoreLabel: CCLabelTTF!
    weak var lavaSprite: CCSprite!
    weak var followNode: CCNode!
    
    private let fallingSpeed = 175.0
    private let spawnFrequency: Double = 1.9
    
    var motionManager = CMMotionManager()
    var velX = 0.0
    var canJump: Bool = true
    var points: NSInteger = 0
    var maxPoints: NSInteger = 0
    var blockArray: [String] = ["Red", "Blue", "Yellow", "Green"]
    var blockQueue = 0
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
    }
    
    //Blocks hitting lava physics collisions.
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, blueBlock: CCNode!, lava: CCNode!) -> Bool {
        blueBlock.removeFromParent()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, yellowBlock: CCNode!, lava: CCNode!) -> Bool {
        yellowBlock.removeFromParent()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, redBlock: CCNode!, lava: CCNode!) -> Bool {
        redBlock.removeFromParent()
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, greenBlock: CCNode!, lava: CCNode!) -> Bool {
        greenBlock.removeFromParent()
        return true
    }
    
    //Hero touching ground physics collision.
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, hero: CCNode!, ground: CCNode!) -> Bool {
        println("Hero touched ground.")
        canJump = true
        return true
    }
    
    //Blocks hitting hero physics collisions.
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, blueBlock: CCNode!, hero: CCNode!) -> Bool {
        canJump = true
        if (abs(blueBlock.physicsBody.velocity.y) > CGFloat(200)) {
            println("I'm Dead")
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, yellowBlock: CCNode!, hero: CCNode!) -> Bool {
        canJump = true
        if (abs(yellowBlock.physicsBody.velocity.y) > CGFloat(200)) {
            println("I'm Dead")
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, redBlock: CCNode!, hero: CCNode!) -> Bool {
        canJump = true
        if (abs(redBlock.physicsBody.velocity.y) > CGFloat(200)) {
            println("I'm Dead")
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, greenBlock: CCNode!, hero: CCNode!) -> Bool {
        canJump = true
        if (abs(greenBlock.physicsBody.velocity.y) > CGFloat(200)) {
            println("I'm Dead")
        }
        return true
    }
    
    //Blocks hitting ground physics collisions.
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, blueBlock: CCNode!, ground: CCNode!) -> Bool {
        var triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.randFuncBlue(blueBlock)
        })
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, yellowBlock: CCNode!, ground: CCNode!) -> Bool {
        var triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.randFuncYellow(yellowBlock)
        })
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, redBlock: CCNode!, ground: CCNode!) -> Bool {
        var triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.randFuncRed(redBlock)
        })
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, greenBlock: CCNode!, ground: CCNode!) -> Bool {
        var triggerTime = (Int64(NSEC_PER_SEC) * 1)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
            self.randFuncGreen(greenBlock)
        })
        return true
    }
    
    //Blocks hitting blocks physics collisions.
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, greenBlock: CCNode!, yellowBlock: CCNode!) -> Bool {
        if (blockQueue == 3) {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncYellow(yellowBlock)
            })
        } else {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncGreen(greenBlock)
            })
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, greenBlock: CCNode!, blueBlock: CCNode!) -> Bool {
        if (blockQueue == 2) {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncBlue(blueBlock)
            })
        } else {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncGreen(greenBlock)
            })
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, greenBlock: CCNode!, redBlock: CCNode!) -> Bool {
        if (blockQueue == 1) {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncRed(redBlock)
            })
        } else {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncGreen(greenBlock)
            })
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, yellowBlock: CCNode!, blueBlock: CCNode!) -> Bool {
        if (blockQueue == 2) {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncBlue(blueBlock)
            })
        } else {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncYellow(yellowBlock)
            })
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, yellowBlock: CCNode!, redBlock: CCNode!) -> Bool {
        if (blockQueue == 1) {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncRed(redBlock)
            })
        } else {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncYellow(yellowBlock)
            })
        }
        return true
    }
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, blueBlock: CCNode!, redBlock: CCNode!) -> Bool {
        if (blockQueue == 1) {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncRed(redBlock)
            })
        } else {
            var triggerTime = (Int64(NSEC_PER_SEC) * 1)
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, triggerTime), dispatch_get_main_queue(), { () -> Void in
                self.randFuncBlue(blueBlock)
            })
        }
        return true
    }
    
    //Functions to turn the blocks from dynamic to static.
    
    func randFuncBlue(blockNode: CCNode!) {
        blockNode.position = ccp(blockNode.position.x, blockNode.position.y)
        blockNode.physicsBody.type = CCPhysicsBodyType(rawValue: UInt(1))!
    }
    
    func randFuncRed(blockNode: CCNode!) {
        blockNode.position = ccp(blockNode.position.x, blockNode.position.y)
        blockNode.physicsBody.type = CCPhysicsBodyType(rawValue: UInt(1))!
    }
    
    func randFuncGreen(blockNode: CCNode!) {
        blockNode.position = ccp(blockNode.position.x, blockNode.position.y)
        blockNode.physicsBody.type = CCPhysicsBodyType(rawValue: UInt(1))!
    }
    
    func randFuncYellow(blockNode: CCNode!) {
        blockNode.position = ccp(blockNode.position.x, blockNode.position.y)
        blockNode.physicsBody.type = CCPhysicsBodyType(rawValue: UInt(1))!
    }
    
    //Touch began function. Makes hero jump.
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        if (canJump == true) {
            hero.physicsBody.applyImpulse(ccp(0, 450))
        }
        canJump = true
    }
    
    //Update function. Runs the whole game.
    
    override func update(delta: CCTime) {
        let maxX = gamePhysicsNode.boundingBox().size.width
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), 530)
        
        let actionFollow = CCActionFollow(target: hero, worldBoundary: CGRectMake(0, 0, maxX, 1600))
        runAction(actionFollow)
        
        lavaSprite.position.y = lavaSprite.position.y + CGFloat(delta) * 14.5
        followNode.position.y = hero.position.y
        
        hero.physicsBody.velocity = ccp(CGFloat(velX), CGFloat(velocityY))
        hero.rotation = Float(velX) / 16.66
        
        if (hero.position.x >= maxX) {
            hero.position.x = 0.0
        }
        
        if (hero.position.x <= 0.0) {
            hero.position.x = maxX
        }
        
        background.position.y = 415.0 - (hero.position.y)/10
        sunMidground.position.y = 55.0 - (hero.position.y)/7
        scoreLabel.position = ccp(scoreLabel.position.x, scoreLabel.position.y)
        
        if (hero.position.y >= 2700.0) {
            background.position.y = 445.0 - 270.0
        }
        
        points = NSInteger(hero.position.y) - 184
        
        if (points >= maxPoints) {
            maxPoints = points
            scoreLabel.string = String(maxPoints)
        }
        
        if (blockQueue == 4) {
            blockQueue = 0
        }
        
        println("FollowNode Pos: \(followNode.position) :: Hero Pos: \(hero.position)")
    }
    
    //Starts running when the current scene finishes presenting itself.  Useful for spawning objects after player presses the start button and not before.
    
    override func onEnterTransitionDidFinish() {
        super.onEnterTransitionDidFinish()
        schedule("spawnObject", interval: spawnFrequency)
        
        if (motionManager.accelerometerAvailable == true) {
            motionManager.accelerometerUpdateInterval = 0.045
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue(),
                withHandler: { (accelerometerData: CMAccelerometerData!, error: NSError!) -> Void
                    in
                    self.outputAccelerationData(accelerometerData.acceleration)
                    if (error != nil){
                        println("\(error)")
                    }
            })
        }
    }
    
    func outputAccelerationData(acceleration: CMAcceleration) {
        velX = acceleration.x * 750
    }
    
    
    //Function for spawning a block.  Appends one random object from FallingObject class into an array, then sets that objects position and scales it down.
    
    func spawnObject() {
        
        var images: [String] = []
        var imageName: String?
        var blockSpawnHeight = hero.position.y + 568.0
        
        let newBlock: CCNode = CCBReader.load("physicsNode\(blockArray[blockQueue])")
        let xSpawnRange = Int(contentSizeInPoints.width - newBlock.contentSize.width)
        let spawnPosition = ccp(CGFloat(randomInteger(xSpawnRange)), blockSpawnHeight)
        
        newBlock.position = spawnPosition
        newBlock.scaleX = 1.0
        newBlock.scaleY = 1.0
        
        blockQueue += 1

        gamePhysicsNode.addChild(newBlock)
        
    }
}



























