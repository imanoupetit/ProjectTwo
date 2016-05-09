
import UIKit

/*
// Orange buttons in HomeViewController & GameOverViewController
*/

class StyledButton: UIButton {

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        
        layer.backgroundColor = UIColor.orangeColor().CGColor
        tintColor = .whiteColor()
        layer.cornerRadius = 6
        // Give some space between the button's text and the button's borders
        let insetConstant: CGFloat = 10
        contentEdgeInsets = UIEdgeInsets(top: insetConstant, left: insetConstant, bottom: insetConstant, right: insetConstant)
    }

    override func intrinsicContentSize() -> CGSize {
        // Ensure that the button's width at least equals 200
        let defaultWidth: CGFloat = 200
        let superContentSize = super.intrinsicContentSize()
        let width = superContentSize.width > defaultWidth ? superContentSize.width : defaultWidth
        let heigth = superContentSize.height
        return CGSize(width: width, height: heigth)
    }
    
}
