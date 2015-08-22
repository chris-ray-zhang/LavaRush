
import UIKit

class MainScene: CCNode {
    
    weak var startButton: CCButton!
    
    func didLoadFromCCB() {
        userInteractionEnabled = true
    }
    
    func restart() {
        let startScene = CCBReader.loadAsScene("StartScene")
        CCDirector.sharedDirector().presentScene(startScene)
    }
    
}
















