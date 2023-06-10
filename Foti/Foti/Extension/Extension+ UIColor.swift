
import Foundation
import UIKit
extension UIColor{
    
    static func rgbConverter(red : CGFloat , green : CGFloat, blue :CGFloat) -> UIColor {
        return UIColor(red: red/255 , green: green/255 , blue: blue/255, alpha: 1)
    }
}
