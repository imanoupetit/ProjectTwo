
import UIKit

class GameOverController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var newGameButton: StyledButton!
    @IBOutlet weak var homeScreenButton: StyledButton!
    var score: Int!
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set view
        view.backgroundColor = .clearColor()
        
        // Set label
        scoreLabel.font = .boldSystemFontOfSize(48)
        scoreLabel.textColor = view.tintColor
        scoreLabel.text = "Score: \(score)"

        // Set buttons
        newGameButton.setTitle("Start a new game", forState: .Normal)
        homeScreenButton.setTitle("Cancel", forState: .Normal)
    }
    
    // MARK: - User interaction
    
    @IBAction func dismissPopOverController(sender: AnyObject) {
        // Dismiss this controller and start a new game via gameViewController.performCountdownSegue()
        let gameViewController = presentingViewController as! GameViewController
        gameViewController.dismissViewControllerAnimated(true) { gameViewController.performCountdownSegue() }
    }
    
    @IBAction func unwindSegueToHomeScreen(sender: AnyObject) {
        // Return directly to home screen 
        performSegueWithIdentifier("unwindSegue", sender: nil)        
    }
    
}
