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

class OrderPlacedVC: UIViewController,UITableViewDelegate, UITableViewDataSource {

    // Create orderID to display info related to that order
    var orderID:String = ""
    // Firebase reference
    let ref = Database.database().reference()
    // The object to help stop the listener?
    var databaseHandle:DatabaseHandle?
    // Create a dictionary to store drink name and status
    var drinkListDict:NSDictionary?
    
    @IBOutlet weak var qNumber: UILabel!
    @IBOutlet weak var amountNotice: UITextView!
    @IBOutlet weak var drinksTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.drinkListDict!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    // When user click DONE, close this view and return to Menu VC.
    @IBAction func toMenuVC(_ sender: Any) {
        self.dismiss(animated: true) {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "menuVC") as UIViewController, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        // Set table view background color
        self.drinksTableView.backgroundColor = UIColor.init(named: "DeepBlueColor")
        
        // Get order info from firebase and set a listener monitoring any changes

            // Retrieve order info and put a listener
        databaseHandle = ref.child("orderList/\(orderID)/drinks").observe(.childChanged) { (snapshot) in
            //Code to execute when a child is changed
            let drinkListDict = snapshot.value as? NSDictionary
            print(drinkListDict?.count)
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
