//
//  OrderPlacedVC.swift
//  chunyang-tea
//
//  Created by Brad Guo on 2021-02-19.
//

import UIKit
import FirebaseUI
import FirebaseCore
import FirebaseDatabase

class OrderPlacedVC: UIViewController{

    // Create orderID to display info related to that order
    var orderID:String = ""
    // Firebase reference
    let ref = Database.database().reference()
    
    @IBOutlet weak var qNumber: UILabel!
    @IBOutlet weak var amountNotice: UITextView!
    
    // When user click DONE, close this view and return to Menu VC.
    @IBAction func toMenuVC(_ sender: Any) {
        self.dismiss(animated: true)
//            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "menuVC") as UIViewController, animated: true)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Get order info from firebase
        self.ref.child("orderList/\(orderID)/qNum").getData { (error, snapshot) in
            DispatchQueue.main.async {
                self.qNumber.text = (snapshot.value as! String)
            }
        }
        
        self.ref.child("orderList/\(orderID)/orderTotalPrice")
            .getData { (error, snapshot) in
                DispatchQueue.main.async {
                    self.amountNotice.text = "$\(snapshot.value as! String) is to be paid when you arrive."
                }
        }
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
