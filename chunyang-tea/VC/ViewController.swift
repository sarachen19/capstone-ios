//
//  ViewController.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-03.
//

import UIKit
import FirebaseUI
import FirebaseCore

class ViewController: UIViewController, FUIAuthDelegate {
    @IBAction func login(_ sender: Any) {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure();
        }
        
        let authUI = FUIAuth.defaultAuthUI()
        authUI!.delegate = self
        let providers = [FUIEmailAuth()]
        authUI?.providers = providers
        let authViewController = authUI!.authViewController()
        self.present(authViewController, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
      // handle user and error as necessary
        if user != nil {
            //store username
           let email = user?.email ?? "no email"
           UserDefaults.standard.removeObject(forKey: "userEmail")
            UserDefaults.standard.set(email, forKey:"userEmail");
            UserDefaults.standard.synchronize();
            let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
            self.navigationController!.pushViewController(mainVC, animated: true)
        }
    }

        


}

