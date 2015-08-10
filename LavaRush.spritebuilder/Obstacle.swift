
import Foundation

class Obstacle: CCNode {
    
    weak var block: CCNode!
    
    func setupRandomPos() {
        let random = 250
        block.position = ccp(CGFloat(random), CGFloat(900))
    }
    
    func didLoadFromCCB() {
        block.physicsBody.sensor = true
    }
}