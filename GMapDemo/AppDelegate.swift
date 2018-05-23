//
//  AppDelegate.swift
//  GMapDemo
//
//  Created by Kirill Khudiakov on 26.04.2018.
//  Copyright © 2018 Kirill Khudiakov. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        GMSServices.provideAPIKey("AIzaSyCVYL99yIj-AAK3NwYi2s51RHcoRLIuvHw")
        setUpRealm()
     
        return true
    }

}

extension AppDelegate {
    
    func setUpRealm() {
        performRealmMigration()
        printRealmPath()
    }
    
    private func performRealmMigration() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 { // the old (default) version is 0
                    
                }
        }
        )
    }
    
    private func printRealmPath() {
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "Realm not found")
    }
}
