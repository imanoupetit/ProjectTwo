
import UIKit
import CoreMotion // Needed for CMMotionManager
import AVFoundation // Needed for AVAudioPlayer

struct Motion {
    static let manager = CMMotionManager()
}

class GameViewController: UIViewController, UICollisionBehaviorDelegate {
    
    let countdownPresentationController = CountdownPresentationController()
    let gameOverPresentationController = GameOverPresentationController()
    
    @IBOutlet weak var gameView: UIView!
    @IBOutlet weak var timerLabel: DisplayLabel!
    @IBOutlet weak var scoreLabel: DisplayLabel!
    
    let ball = UIImageView(image: UIImage(named: "bille"))
    let star = UIImageView(image: UIImage(named: "etoile-96"))
    var timer: NSTimer?

    var score = Constants.scoreInitialValue {
        didSet { scoreLabel.text = "\(score)" }
    }
    var timerValue = Constants.gameTimerInitialValue {
        didSet { timerLabel.text = Formatter.timerFormatter.stringFromTimeInterval(timerValue) }
    }
    
    var pockAudioPlayer: AVAudioPlayer!
    var squeezeAudioPlayer: AVAudioPlayer!
    var sparklingAudioPlayer: AVAudioPlayer!
    var musicAudioPlayer: AVAudioPlayer!
    
    var animator: UIDynamicAnimator!
    let gravityBehavior = UIGravityBehavior()
    let colliderBehavior = UICollisionBehavior()
    let noRotationBehavior = UIDynamicItemBehavior()
    var snapBehavior: UISnapBehavior?
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Audio setup
        let pockURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Pock", ofType: ".mp3")!)
        let squeezeURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Squeeze", ofType: ".mp3")!)
        let sparklingURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Sparkling", ofType: ".mp3")!)
        let musicURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Music", ofType: ".mp3")!)
        
        pockAudioPlayer = try! AVAudioPlayer(contentsOfURL: pockURL)
        squeezeAudioPlayer = try! AVAudioPlayer(contentsOfURL: squeezeURL)
        sparklingAudioPlayer = try! AVAudioPlayer(contentsOfURL: sparklingURL)
        musicAudioPlayer = try! AVAudioPlayer(contentsOfURL: musicURL)
        [pockAudioPlayer, squeezeAudioPlayer, sparklingAudioPlayer, musicAudioPlayer].forEach { $0.prepareToPlay() }
        
        // Set view
        gameView.backgroundColor = .clearColor()
        scoreLabel.text = "\(score)"
        timerLabel.text = Formatter.timerFormatter.stringFromTimeInterval(timerValue)
        [ball, star].forEach { $0.frame.size = Constants.itemSize } // Set items size
        
        // Set behaviors
        animator = UIDynamicAnimator(referenceView: gameView)
        colliderBehavior.translatesReferenceBoundsIntoBoundary = true
        colliderBehavior.collisionDelegate = self
        noRotationBehavior.allowsRotation = false
        gravityBehavior.addItem(ball)
        colliderBehavior.addItem(ball)
        colliderBehavior.addItem(star)
        noRotationBehavior.addItem(star)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        performCountdownSegue() // Display a countdown in a popover
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Reset persistent objects (timer & motion manager) when view controller is dismissed
        timer?.invalidate()
        timer = nil
        Motion.manager.stopAccelerometerUpdates()
    }
    
    // MARK: - Start a new game
    
    // This method is called from CountdownViewController & GameOverController when they disappear
    func startGame() {
        // Items frame
        ball.center = CGPoint(x: gameView.bounds.midX, y: gameView.bounds.midY)
        star.frame.origin = randomNewOriginPoint() // generates a random initial position for star item
        
        // Animate items appearance
        [ball, star].forEach { $0.alpha = 0 }
        [ball, star].forEach(self.gameView.addSubview)
        UIView.animateWithDuration(0.5) {
            [self.ball, self.star].forEach { $0.alpha = 1 }
        }

        // Start accelerometer
        if Motion.manager.accelerometerAvailable {
            Motion.manager.startAccelerometerUpdatesToQueue(NSOperationQueue.mainQueue()) { (data, _) in
                if let data = data {
                    self.gravityBehavior.gravityDirection = CGVector(dx: data.acceleration.x, dy: -data.acceleration.y)
                }
            }
        }
        
        // (Re)add dynamic behaviors to animator
        [colliderBehavior, gravityBehavior, noRotationBehavior].forEach(self.animator.addBehavior)
        
        // Play music
        musicAudioPlayer.currentTime = 0 // force music to start at the beginning
        musicAudioPlayer.play()
        
        // (Re)set initial values & launch timer
        timerValue = Constants.gameTimerInitialValue
        score = Constants.scoreInitialValue
        timer = NSTimer.scheduledTimerWithTimeInterval(Constants.timerUnit, target: self, selector: #selector(GameViewController.fireTimer), userInfo: nil, repeats: true)
    }
    
    // MARK: - star item origin point
    
    func randomNewOriginPoint() -> CGPoint {
        let newX = Int(arc4random_uniform(UInt32(gameView.bounds.width - star.bounds.width)))
        let newY = Int(arc4random_uniform(UInt32(gameView.bounds.height - star.bounds.height)))
        let newOriginPoint = CGPoint(x: newX, y: newY)

        // Prevent items to block one the other: if star & ball are one on the other, set a new random position for star
        if CGRectContainsPoint(CGRectInset(ball.frame, 5, 5), newOriginPoint) { randomNewOriginPoint() }
        return newOriginPoint
    }
    
    // MARK: - Snap behavior management
    
    func snapHandler() {
        // Reset snapBehavior property with a new star position when the two items collide
        if let snapBehavior = snapBehavior {
            animator.removeBehavior(snapBehavior)
        }
        snapBehavior = UISnapBehavior(item: star, snapToPoint: randomNewOriginPoint())
        animator.addBehavior(snapBehavior!)
    }
    
    // MARK: - Timer
    
    func fireTimer() {
        if timerValue > 0 {
            timerValue -= 1
        } else {
            // Reset timer, motion manager, music, dynamic behaviors, remove items from superview, then present game over view controller
            timer?.invalidate()
            timer = nil
            Motion.manager.stopAccelerometerUpdates()
            animator?.removeAllBehaviors()
            [ball, star].forEach { $0.removeFromSuperview() }
            musicAudioPlayer.pause()
            sparklingAudioPlayer.play()
            performSegueWithIdentifier("gameOverSegue", sender: nil)
        }
    }
    
    // MARK: - UICollisionBehaviorDelegate
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint) {
        // Update score & play sound when the two items collide, then perform a snap behavior to change star position
        score += 1
        squeezeAudioPlayer.play()
        snapHandler()
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint) {
        // Play pock sound when ball and gameView borders collide
        if item === ball { pockAudioPlayer.play() }
    }
    
    // MARK: - User interaction
    
    @IBAction func menuButtonAction(sender: MenuButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // Called from viewWillAppear & game over controller
    func performCountdownSegue() {
        performSegueWithIdentifier("countDownSegue", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Prepare popover view controllers before display with presentation style
        // Set segues as modal in storyboard for the following popover view controllers to allow modalPresentationStyle
        if segue.identifier == "countDownSegue" {
            let controller = segue.destinationViewController as! CountdownViewController
            setPresentationForController(controller, withPresentationDelegate: countdownPresentationController)
        } else if segue.identifier == "gameOverSegue" {
            let controller = segue.destinationViewController as! GameOverController
            controller.score = score
            setPresentationForController(controller, withPresentationDelegate: gameOverPresentationController)
        }
    }
    
    func setPresentationForController(controller: UIViewController, withPresentationDelegate delegate: UIPopoverPresentationControllerDelegate) {
        // adaptivePresentationStyleForPresentationController must return .None so that preferredContentSize can work for small devices
        controller.preferredContentSize = Constants.popoverSize
        controller.modalPresentationStyle = .Popover
        
        let popoverPresentationController = controller.popoverPresentationController
        popoverPresentationController?.delegate = delegate
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
        popoverPresentationController?.permittedArrowDirections = .Any
    }

}
