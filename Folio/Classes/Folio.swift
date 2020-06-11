import UIKit

public protocol FolioDelegate: AnyObject {
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func reachedBottom(in tableView: UITableView)
}

/**
 Tells you when you scroll to the bottom of the tableview.
 use by
 1. setting delegate
 2. call `tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)` from your delegate
 */
public class Folio {
    public weak var delegate: FolioDelegate?

    // Prevent spamming the delegate by only notifying it when data is reloaded. That's it.
    private var alertedReachedBottom = false

    weak var tableView: UITableView?

    public init(tableView: UITableView) {
        self.tableView = tableView
    }

    public var numberOfRowsInLastSection: Int?
    public var numberOfSections: Int?

    // Rather then asking the developer to call `reloadData()` on this class when they call it on their `tableView` instance, we simply check to see if we can detect that a reload happened.
    private func detectIfDataReloaded(delegate: FolioDelegate, tableView: UITableView) {
        let oldNumberOfSections = numberOfSections
        let oldNumberOfRowsInLastSection = numberOfRowsInLastSection

        let newNumberOfSections = delegate.numberOfSections(in: tableView)
        let newNumberOfRowsInLastSection = delegate.tableView(tableView, numberOfRowsInSection: newNumberOfSections - 1) // zero index the section number
        if oldNumberOfSections != newNumberOfSections || oldNumberOfRowsInLastSection != newNumberOfRowsInLastSection {
            numberOfSections = newNumberOfSections
            numberOfRowsInLastSection = newNumberOfRowsInLastSection

            alertedReachedBottom = false // reset
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = self.delegate, let tableView = self.tableView else {
            return
        }
        
        detectIfDataReloaded(delegate: delegate, tableView: tableView)

        let isLastSection = indexPath.section == (numberOfSections! - 1)
        guard isLastSection else {
            return
        }

        var isCloseToEnd = true
        if numberOfRowsInLastSection! > 5 {
            isCloseToEnd = indexPath.row > ((numberOfRowsInLastSection! - 1) - 5)
        }

        if isCloseToEnd {
            // to prevent spamming the delegate
            if !alertedReachedBottom {
                delegate.reachedBottom(in: tableView)
                alertedReachedBottom = true
            }
        }
    }
}
