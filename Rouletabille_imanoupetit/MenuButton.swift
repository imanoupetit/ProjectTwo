
import UIKit

/*
// Hamburger menu in GameViewController
*/

class MenuButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setTitle(nil, forState: .Normal)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Draw image
        let radius: CGFloat = 2
        let smallMargin: CGFloat = 4
        let bigMargin: CGFloat = 5
        let barWidth = rect.width - smallMargin * 2
        let barHeight = (rect.height - smallMargin * 2 - bigMargin * 2) / 3

        let rectanglePath1 = UIBezierPath(roundedRect: CGRect(x: smallMargin, y: smallMargin, width: barWidth, height: barHeight), cornerRadius: radius)
        UIColor.whiteColor().setFill()
        rectanglePath1.fill()

        let rectanglePath2 = UIBezierPath(roundedRect: CGRect(x: smallMargin, y: smallMargin + bigMargin + barHeight, width: barWidth, height: barHeight), cornerRadius: radius)
        UIColor.whiteColor().setFill()
        rectanglePath2.fill()

        let rectanglePath3 = UIBezierPath(roundedRect: CGRect(x: smallMargin, y: smallMargin + bigMargin * 2 + barHeight * 2, width: barWidth, height: barHeight), cornerRadius: radius)
        UIColor.whiteColor().setFill()
        rectanglePath3.fill()
    }
    
}
