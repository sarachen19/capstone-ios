//
//  MemberInfoVC.swift
//  chunyang-tea
//
//  Created by Brad Guo on 2021-02-26.
//

import UIKit
import FirebaseUI
import FirebaseCore
import FirebaseDatabase

class CreditsInfoVC: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    let ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        
        welcomeLabel.text = UserDefaults.standard.string(forKey: "userEmail")
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}