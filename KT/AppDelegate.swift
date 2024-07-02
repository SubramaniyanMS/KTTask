//
//  AppDelegate.swift
//  KT
//
//  Created by Subramani MAC on 6/29/24.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController = UINavigationController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyD0kACOietBw9It5g_iGNE2vrJrRnv-cmY")
        
        let vC = SignInSignUpViewController()
        navigationController = UINavigationController(rootViewController: vC)
        navigationController.isNavigationBarHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()

        return true
    }

}
