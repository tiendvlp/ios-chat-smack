import Foundation
import SWRevealViewController

extension SWRevealViewController {
    static func getRevealToggle () -> Selector {
        return #selector(self.revealToggle(_:))
    }
}
