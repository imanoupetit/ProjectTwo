
import UIKit

/*
// Format timer label text with "m:ss" format
*/

struct Formatter {
    
    // Source: http://stackoverflow.com/a/29002893/1966109
    // Format NSTimeInterval with "m:ss" style
    static let timerFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.zeroFormattingBehavior = .Pad
        formatter.allowedUnits = [.Minute, .Second]
        formatter.unitsStyle = .Positional
        return formatter
        }()
    
    // Format NSTimeInterval with "mm minutes" or "ss seconds" style
    static let countdownDurationFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.allowedUnits = [.Minute, .Second]
        formatter.unitsStyle = .Full // Adds "minutes" or "seconds" to the formatted text
        formatter.zeroFormattingBehavior = .Pad
        return formatter
        }()

}
