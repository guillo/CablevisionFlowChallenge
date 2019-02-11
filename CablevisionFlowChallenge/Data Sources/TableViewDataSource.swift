//
//  TableViewDataSource.swift
//  CablevisionFlowChallenge
//
//  Created by Mario Guillermo Boaglio on 07/02/2019.
//  Copyright © 2019 Mario Guillermo Boaglio. All rights reserved.
//

import Foundation
import UIKit

class TableViewDataSource<Cell :UITableViewCell,ViewModel> : NSObject, UITableViewDataSource, UITableViewDelegate {
    private var cellIdentifier :String!
    private var items :[ViewModel]!
    var configureCell :(Cell,ViewModel) -> ()
    
    init(cellIdentifier :String, items :[ViewModel], configureCell: @escaping (Cell,ViewModel) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! Cell
        let item = self.items[indexPath.row]
        self.configureCell(cell,item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60;
    }
    
}
