import UIKit

public protocol FolioDelegate: AnyObject {
    func numberOfSections(in tableView: UITableView) -> Int
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    func reachedBottom(in tableView: UITableView)
    func reachedTop(in tableView: UITableView)
}

public extension FolioDelegate {
    // default implemention to make this function optional to implement. 
    func reachedTop(in tableView: UITableView) {
    }
}

/**
 Tells you when you scroll to the bottom of the tableview.

 Use by...
 1. setting delegate
 2. call `tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)` from your delegate
 */
public class Folio {
    public weak var delegate: FolioDelegate?

    // Prevent spamming the delegate by only notifying it when data is reloaded. That's it.
    private var alertedReachedBottom = false
    private var alertedReachedTop = false
    private var firstTimeReachTop = true // We don't want to notify the user the first time we reach the top because that means the tableview was loaded for the first time. We skip the first notify and will notify for the future calls which means the user has scrolled.

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
        // Folio only cares about the *last section* and the *last row* of the tableview. 
        let newNumberOfSections = delegate.numberOfSections(in: tableView)
        let newNumberOfRowsInLastSection = delegate.tableView(tableView, numberOfRowsInSection: newNumberOfSections - 1) // zero index the section number

        if oldNumberOfSections != newNumberOfSections || oldNumberOfRowsInLastSection != newNumberOfRowsInLastSection { // A reload happened
            numberOfSections = newNumberOfSections
            numberOfRowsInLastSection = newNumberOfRowsInLastSection

            // reset
            alertedReachedBottom = false
            alertedReachedTop = false
        }
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let delegate = self.delegate, let tableView = self.tableView else {
            return
        }
        
        // Determine the last section and last row of that section in your tableview. That way we know when to call your delegate. 
        detectIfDataReloaded(delegate: delegate, tableView: tableView)
        
        handleDetectStartOfTable(indexPath: indexPath, delegate: delegate, tableView: tableView)
        handleDetectEndOfTable(indexPath: indexPath, delegate: delegate, tableView: tableView)
    }
    
    private func handleDetectEndOfTable(indexPath: IndexPath, delegate: FolioDelegate, tableView: UITableView) {
        // Determine if `willDisplay` is about to display the last row of the last section of your tableview. If it is, let's call the delegate.
        let isLastSection = indexPath.section == (numberOfSections! - 1)
        guard isLastSection else {
            return
        }

        var isCloseToEnd = true
        if numberOfRowsInLastSection! > 5 {
            isCloseToEnd = indexPath.row > ((numberOfRowsInLastSection! - 1) - 5)
        }
        
        guard isCloseToEnd else {
            return
        }
        
        // to prevent spamming the delegate, only call once until you call `.reloadData()`
        if !alertedReachedBottom {
            delegate.reachedBottom(in: tableView)
            alertedReachedBottom = true
        }
    }
    
    private func handleDetectStartOfTable(indexPath: IndexPath, delegate: FolioDelegate, tableView: UITableView) {
        let isFirstSection = indexPath.section == 0
        guard isFirstSection else {
            return
        }

        let isTopOfTable = indexPath.row == 0
        guard isTopOfTable else {
            return
        }
        
        guard !firstTimeReachTop else {
            firstTimeReachTop = false
            return
        }

        // to prevent spamming the delegate, only call once until you call `.reloadData()`
        if !alertedReachedTop {
            delegate.reachedTop(in: tableView)
            alertedReachedTop = true
        }
    }
}
