
import UIKit

struct Constants {
    
    static let timerUnit: NSTimeInterval = 1
    static let countdownInitialValue: NSTimeInterval = 5
    static let gameTimerInitialValue: NSTimeInterval = 20
    static let scoreInitialValue = 0
    static let popoverSize = CGSize(width: 260, height: 260) // size for popover view controllers
    static let itemSize: CGSize = {
        let deviceIdiom = UIScreen.mainScreen().traitCollection.userInterfaceIdiom
        return deviceIdiom == .Pad ? CGSize(width: 80, height: 80) : CGSize(width: 40, height: 40) // size for star & ball
        }()
    
}
