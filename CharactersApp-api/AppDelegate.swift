//
//  AppDelegate.swift
//  CharactersApp-api
//
//  Created by Alex  on 17.07.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, 
		 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		
		let window = UIWindow()
		window.rootViewController = CharactersViewController()
		window.makeKeyAndVisible()
		self.window = window
		return true
	}


}

