
import UIKit

/*
// Presentation controller used to display GameOverViewController instances as popover
*/

class GameOverPresentationController: UIPresentationController, UIPopoverPresentationControllerDelegate {

    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        // Set to .None to allow custom sized popOver on all device
        return .None
    }
    
    func popoverPresentationControllerShouldDismissPopover(popoverPresentationController: UIPopoverPresentationController) -> Bool {
        // Don't allow the user to tap on the dimming view to dismiss the presented view controller
        return false // default (when non implemented) is true
    }
    
}
