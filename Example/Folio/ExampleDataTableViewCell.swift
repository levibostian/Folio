//
//  ExampleDataTableViewCell.swift
//  Folio
//
//  Created by Levi Bostian on 6/11/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

class ExampleDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    func populate(data: String) {
        self.label.text = data
    }
    
}
