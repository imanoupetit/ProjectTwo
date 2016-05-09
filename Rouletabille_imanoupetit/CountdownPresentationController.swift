
import UIKit

/*
// Presentation controller used to display CountDownViewController instances as popover
*/

class CountdownPresentationController: UIPresentationController, UIPopoverPresentationControllerDelegate {

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Set to .None to allow custom sized popOver on all device
        return .None
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        // Allow user to tap on the dimming view to cancel the countdown and start the game immediately
        return true // default (when non implemented) is true
    }
    
    func popoverPresentationControllerDidDismissPopover(popoverPresentationController: UIPopoverPresentationController) {
        // When user tap on the dimming view, perform the following while the view controller is dismissed
        let countdownViewController = popoverPresentationController.presentedViewController as! CountdownViewController
        let gameViewController = popoverPresentationController.presentingViewController as! GameViewController
        countdownViewController.invalidateTimer()
        gameViewController.startGame()
    }
    
}
