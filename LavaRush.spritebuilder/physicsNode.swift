//
//  physicsNode.swift
//  LavaRush
//
//  Created by Chris Zhang on 8/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class physicsNode: CCNode {
    /*
    var images: [String] = []
    var imageName: String?
    
    func didLoadCCB() {
        initializeImage()
        physicsBody.type = CCPhysicsBodyType.Static
        physicsBody.affectedByGravity = true
    }
    
    private func initializeImage() {
        println("initializing")
        let path = NSBundle.mainBundle().pathForResource("FallingObjectImages", ofType: "plist")
        let imageDictionary:Dictionary = NSDictionary(contentsOfFile: path!) as! [String: AnyObject]
        images = imageDictionary["FallingObjectImages"] as! [String]
        let randomIndex = randomInteger(images.count)
        imageName = images[randomIndex]
        anchorPoint = ccp(0, 0)
        if let block = getChildByName("block", recursively: false) as? CCSprite {
            println(imageName)
            block.spriteFrame = CCSpriteFrame(imageNamed: imageName)
            
        }
    }
    */
   
}
