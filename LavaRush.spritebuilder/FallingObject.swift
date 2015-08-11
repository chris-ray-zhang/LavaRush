
import UIKit

class FallingObject: CCSprite {
   
    enum FallingObjectType: Int {
        case Color
    }
    
    private(set) var type: FallingObjectType
    
    private static let imageNames = ImageNames()
    
    //Goes into the plist (FallingObjectImages) and constructs an array of the four different colors to choose from.
    private struct ImageNames {
        var images: [String]
        
        init() {
            let path = NSBundle.mainBundle().pathForResource("FallingObjectImages", ofType: "plist")
            let imageDictionary:Dictionary = NSDictionary(contentsOfFile: path!) as! [String: AnyObject]
            images = imageDictionary["FallingObjectImages"] as! [String]
        }
    }
    
    //Selects one of the four different colors from the array constructed above and sets the anchor point of that image to (0, 0).
    init(type: FallingObjectType) {
        
        self.type = type
        var imageName: String? = nil
        
        if (type == .Color) {
            let randomIndex = randomInteger(FallingObject.imageNames.images.count)
            imageName = FallingObject.imageNames.images[randomIndex]
        }
        
        let spriteFrame = CCSpriteFrame(imageNamed: imageName)
        /*
        super.init(texture: spriteFrame.texture, rect: spriteFrame.rect, rotated: false)
        */
        super.init(texture: spriteFrame.texture, rect: spriteFrame.rect, rotated: false)
        anchorPoint = ccp(0, 0)
    }
    
}
