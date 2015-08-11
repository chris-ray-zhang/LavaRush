import Foundation
import CoreMotion

class MainScene: CCNode {
    
    weak var hero: CCSprite!
    weak var ground: CCSprite!
    weak var gamePhysicsNode: CCPhysicsNode!
    
    private var fallingObjects = [FallingObject]()

    private let fallingSpeed = 175.0
    private let spawnFrequency = 3.0
    
    var motionManager = CMMotionManager()
    var velX = 0.0
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
        gamePhysicsNode.collisionDelegate = self
        motionManager.startAccelerometerUpdates() //Supposedly starts the accelerometer when didLoadFromCCB is called, collects iPhone tilt information.
    }
    
    override func touchBegan(touch: CCTouch!, withEvent event: CCTouchEvent!) {
        hero.physicsBody.applyImpulse(ccp(0, 530))
    }
    
    override func update(delta: CCTime) {
        let maxX = gamePhysicsNode.boundingBox().size.width
        let velocityY = clampf(Float(hero.physicsBody.velocity.y), -Float(CGFloat.max), 530)
        
        hero.physicsBody.velocity = ccp(CGFloat(velX), CGFloat(velocityY))
        hero.rotation = Float(velX) / 16.66
        
        for (var i = 0; i < fallingObjects.count; i++) {
            let fallingObject = fallingObjects[i]
            fallingObject.position = ccp(fallingObject.position.x, fallingObject.position.y - CGFloat(fallingSpeed * delta))
        }
        
        if (hero.position.x >= maxX) {
            hero.position.x = 0.0
        }
        
        if (hero.position.x <= 0.0) {
            hero.position.x = maxX
        }
        
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
    
    func ccPhysicsCollisionBegin(pair: CCPhysicsCollisionPair!, block: CCNode!, ground: CCNode!) -> Bool {
        block.position = ccp(block.position.x, block.position.y)
        block.physicsBody.type = CCPhysicsBodyType(rawValue: UInt(1))!
        return true
    }
    
    //Function for spawning a block.  Appends one random object from FallingObject class into an array, then sets that objects position and scales it down.
    func spawnObject() {
        
        var images: [String] = []
        var imageName: String?

        /*
        
        let path = NSBundle.mainBundle().pathForResource("FallingObjectImages", ofType: "plist")
        let imageDictionary:Dictionary = NSDictionary(contentsOfFile: path!) as! [String: AnyObject]
        images = imageDictionary["FallingObjectImages"] as! [String]
        let randomIndex = randomInteger(images.count)
        imageName = images[randomIndex]
        
        */
        
        
        let newBlock: CCNode = CCBReader.load("physicsNode")
        /*
        if let block = newBlock.getChildByName("block", recursively: false) as? CCSprite {
            block.spriteFrame = CCSpriteFrame(imageNamed: imageName)
        }
        */
        let xSpawnRange = Int(contentSizeInPoints.width - newBlock.contentSize.width)
        let spawnPosition = ccp(CGFloat(randomInteger(xSpawnRange)), contentSizeInPoints.height)
        newBlock.position = spawnPosition
        
        newBlock.scaleX = 1.0
        newBlock.scaleY = 1.0
        
        let physicNode = getChildByName("physicNode", recursively: false) as? CCPhysicsNode
        println("adding physicsNode")
        physicNode!.addChild(newBlock)
        
        
        
        
        
        
        
        
        /*
        newBlock = CCNode()
        imageOfBlock = CCSprite(imageNamed: imageName)
        imageOfBlock.anchorPoint = ccp(0, 0)
        
        newBlock.addChild(imageOfBlock)
        
        let xSpawnRange = Int(contentSizeInPoints.width)
        let spawnPosition = ccp(CGFloat(randomInteger(xSpawnRange)), contentSizeInPoints.height)
        
        newBlock.position = spawnPosition
        newBlock.scaleX = 0.5
        newBlock.scaleY = 0.5
        println("spawning object")
        self.addChild(newBlock)
        */
        
        
        /*
        if let physicNode = getChildByName("physicNode", recursively: false) as? CCPhysicsNode {
            println("adding physicsNode")
            physicNode.addChild(newBlock)
        }
        
        
        let fallingObjectType = FallingObject.FallingObjectType(rawValue: 0)!
        let fallingObject = FallingObject(type: fallingObjectType)

        
        
        fallingObjects.append(fallingObject)
        
        let xSpawnRange = Int(contentSizeInPoints.width - CGRectGetMaxX(fallingObject.boundingBox()))
        let spawnPosition = ccp(CGFloat(randomInteger(xSpawnRange)), contentSizeInPoints.height)
        
        fallingObject.position = spawnPosition
        fallingObject.scaleX = 0.5
        fallingObject.scaleY = 0.5
        
        if let physicNode = getChildByName("physicNode", recursively: false) as? CCPhysicsNode {
            println("adding physicsNode")
            physicNode.addChild(fallingObject)
        }
        addChild(fallingObject)
        */
    }
    
}























