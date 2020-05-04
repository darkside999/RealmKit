//
//  Receipt.swift
//  RealmKitTest
//
//  Created by Indir Amerkhanov on 04.05.2020.
//  Copyright © 2020 Indir Amerkhanov. All rights reserved.
//

import Foundation
import RealmSwift
import RealmKit

class ReceiptObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var sum: Int = 0
    @objc dynamic var date: Date = Date()
    
    override class func primaryKey() -> String? { "id" }
}

struct Receipt: Mappable {
    let id: Int
    let sum: Int
    let date: Date
    
    func mapToPersistenceObject() -> ReceiptObject {
        let receipt = ReceiptObject()
        receipt.id = id
        receipt.sum = sum
        receipt.date = date
        return receipt
    }
    
    static func mapFromPersistenceObject(_ object: ReceiptObject) throws -> Receipt {
        Receipt(id: object.id, sum: object.sum, date: object.date)
    }
}
