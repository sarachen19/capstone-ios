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
    @IBOutlet weak var creditLabel: UILabel!
    
    var userID:String = ""
    let ref = Database.database().reference()
    
    func getInfo() {
        
        self.ref.child("userCredits/\(userID)/credit")
            .observeSingleEvent(of: .value) { (snapshot) in
                self.creditLabel.text = snapshot.value as? String ?? "0"
            }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.userID = Auth.auth().currentUser!.uid
        getInfo()
        welcomeLabel.text = UserDefaults.standard.string(forKey: "uid")
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        getInfo()
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
