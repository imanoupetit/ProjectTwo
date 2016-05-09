
import UIKit

/*
// Labels used in GameViewController to display score and timer
*/

class DisplayLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        font = .boldSystemFontOfSize(32)
        textColor = .whiteColor()
    }
    
}
