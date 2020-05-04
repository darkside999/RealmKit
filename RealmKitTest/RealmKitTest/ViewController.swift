//
//  ViewController.swift
//  RealmKitTest
//
//  Created by Indir Amerkhanov on 04.05.2020.
//  Copyright © 2020 Indir Amerkhanov. All rights reserved.
//

import UIKit
import RealmKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dataManager: DataManagerProtocol = BaseDataManager.shared
        do {
            try dataManager.save(entity: Receipt(id: 1, sum: 2333, date: Date()))
            try dataManager.save(entity: Receipt(id: 2, sum: 10100, date: Date()))
        } catch {
            print(error)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            dataManager.fetch(Receipt.self, predicate: nil, sorted: nil) { print($0) }
        }
    }


}

