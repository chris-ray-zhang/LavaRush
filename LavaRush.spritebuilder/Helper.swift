
import Foundation

func randomInteger(var maximum: Int) -> Int {
    if maximum > Int(Int32.max) {
        maximum = Int(Int32.max)
    }
    
    return Int(arc4random_uniform(UInt32(maximum)))
}

extension String {
    func pluralize(n: CCTime) -> String {
        return self.pluralize(Int(n))
    }

func pluralize(n: Int) -> String {
    return n == 1 ? self : "\(self)s"
    }
}