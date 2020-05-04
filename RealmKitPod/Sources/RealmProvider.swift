//
//  RealmProvider.swift
//
//  Created by Indir Amerkhanov on 09.03.2020.
//  Copyright © 2020 Indir Amerkhanov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
    let configuration: Realm.Configuration
    
    init(configuration: Realm.Configuration) {
        self.configuration = configuration
    }
    
    private var realm: Realm? {
        do {
            return try Realm(configuration: configuration)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private static let defaultConfig = Realm.Configuration(schemaVersion: 1)

    public static var `default`: Realm? = {
        return RealmProvider(configuration: RealmProvider.defaultConfig).realm
    }()
}
