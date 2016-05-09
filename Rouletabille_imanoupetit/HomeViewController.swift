
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var newGameButton: StyledButton!
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "rouletabille-fond-eau")
        imageView.contentMode = .ScaleAspectFill
        newGameButton.setTitle("Start a new game", forState: .Normal)        
    }
    
    // MARK: - Navigation
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        // This method allows the system to perform an unwind segue from another viewController to this viewController
        // No implementation needed
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Present game view controller with a cross dissolve transition
        // Set segue as modal in storyboard to allow this
        let controller = segue.destinationViewController as! GameViewController
        controller.modalTransitionStyle = .CrossDissolve
    }
    
}
