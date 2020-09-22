//
//  ViewController.swift
//  Folio
//
//  Created by Levi Bostian on 06/11/2020.
//  Copyright (c) 2020 Levi Bostian. All rights reserved.
//

import UIKit
import Folio

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var folio: Folio!
    fileprivate var data: ExampleData!
    fileprivate var areMorePages: Bool = true
    fileprivate var repository = ExampleRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        folio = Folio(tableView: tableView)
        folio.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        repository.observeExampleData { [weak self] (exampleData)  in
            guard let self = self else { return }
            
            self.data = exampleData.data
            self.areMorePages = exampleData.areMorePages
            
            self.tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, FolioDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.keys.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyForSection = self.data.keys[section]
        let sectionData = self.data.value(forKey: keyForSection)!
        
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keyForSection = self.data.keys[section]
        
        return keyForSection
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Loading section: \(indexPath.section), row: \(indexPath.row)")
        
        folio.tableView(tableView, willDisplay: cell, forRowAt: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let keyForSection = self.data.keys[indexPath.section]
        let sectionData = self.data.value(forKey: keyForSection)!
        let cellData = sectionData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExampleDataTableViewCellId") as! ExampleDataTableViewCell
        
        cell.populate(data: cellData)

        return cell
    }

    func reachedBottom(in tableView: UITableView) {
        guard areMorePages else {
            print("Reached bottom, but no more pages.")
            
            return
        }
        
        repository.goToNextPage()
        
        print("Going to next page...")
    }
    
    func reachedTop(in tableView: UITableView) {
        print("Reached the top.")
    }
}
