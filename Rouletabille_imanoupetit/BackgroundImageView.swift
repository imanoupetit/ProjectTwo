
import UIKit

/*
// Enum to toggle images in the BackgroundImageView class below
*/

private enum ImageEnum {
    
    case Eau, Mosaique, Phobos, Voutes
    var image: UIImage {
        switch self {
        case Eau:      return UIImage(named: "rouletabille-fond-eau")!
        case Mosaique: return UIImage(named: "rouletabille-fond-mosaique")!
        case Phobos:   return UIImage(named: "rouletabille-fond-phobos")!
        case Voutes:   return UIImage(named: "rouletabille-fond-voutes")!
        }
    }
    
    
    init() { self = Eau }
    mutating func toggleImageEnum() {
        switch self {
        case Eau:      self = Mosaique
        case Mosaique: self = Phobos
        case Phobos:   self = Voutes
        case Voutes:   self = Eau
        }
    }
    
}

/*
// UIImageView used to display various image in game view controller
*/

class BackgroundImageView: UIImageView {
    
    private var imageEnum = ImageEnum() // Must be var to allow mutating function toggleImageEnum()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        becomeFirstResponder() // Make view respond to a shake of the device
        contentMode = .ScaleAspectFill
        image = imageEnum.image
    }
    
    // MARK: - First responder management
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        // Toggle imageEnum then display a new image
        imageEnum.toggleImageEnum()
        image = imageEnum.image
    }
    
    // No need to implement -canResignFirstResponder because it returns true when not implemented in UIView subclasses
    override func canBecomeFirstResponder() -> Bool {
        return true
    }

}
