
import UIKit

class CountdownViewController: UIViewController {

    @IBOutlet weak var rulesLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    var timer: NSTimer?
    var countdownInterval = Constants.countdownInitialValue {
        didSet { countdownLabel.text = "\(Int(countdownInterval))" }
    }

    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clearColor()
        
        countdownLabel.font = .boldSystemFontOfSize(120)
        countdownLabel.textColor = view.tintColor
        countdownLabel.text = "\(Int(countdownInterval))"
        
        rulesLabel.font = .systemFontOfSize(15)
        rulesLabel.textColor = .orangeColor()
        rulesLabel.numberOfLines = 0
        let countdownDurationString = Formatter.countdownDurationFormatter.stringFromTimeInterval(Constants.gameTimerInitialValue)!
        rulesLabel.text = "Collect a maximum of stars in " + countdownDurationString + "."
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timer = NSTimer.scheduledTimerWithTimeInterval(Constants.timerUnit, target: self, selector: #selector(CountdownViewController.fireCountdown), userInfo: nil, repeats: true)
    }
    
    // MARK: - Timer
    
    func fireCountdown() {
        if countdownInterval > 0 {
            countdownInterval -= 1
        } else {
            // When countdown == 0, invalidate timer, dismiss popover & launch game
            invalidateTimer()
            let gameViewController = presentingViewController as! GameViewController
            gameViewController.dismissViewControllerAnimated(true, completion: { gameViewController.startGame() })
        }
    }
    
    func invalidateTimer() {
        // This method can be called from this class and from CountdownPresentationController
        timer?.invalidate()
        timer = nil
    }

}
