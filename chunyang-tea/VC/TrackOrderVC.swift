//
//  File.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-04-08.
//

import UIKit
import FirebaseUI
import FirebaseCore

class TrackOrderVC: ViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var table: UITableView!
    var orders : [Order] = []
    var ref: DatabaseReference!
    var email : String = ""

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackOrderCell", for: indexPath) as! TrackOrderCell
        let order = self.orders[indexPath.row]
        var time = order.orderTime;
        time = time.components(separatedBy: " ")[0]
        cell.cellNameLbl?.text = time
        cell.cellDescLbl?.text = order.status
        cell.cellPriceLbl?.text = order.orderTotalPrice


        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //self.orders = []
        readListData();
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if FirebaseApp.app() == nil {
            FirebaseApp.configure();
        }
        self.email = UserDefaults.standard.string(forKey: "userEmail")!
        readListData()
    }
    
    func readListData() {
        var temp : [Order] = []
        ref = Database.database().reference()
        if ref != nil {
            ref!.child("orderList").observeSingleEvent(of: .value, with: { (snapshot) in
              // Get  value
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let userEmail = snap.childSnapshot(forPath:"userEmail").value as? String ?? ""
                    let status = snap.childSnapshot(forPath:"status").value as? String ?? "Received"
                    let orderTotalPrice = snap.childSnapshot(forPath:"orderTotalPrice").value  as? String ?? ""
                    let orderTime = snap.childSnapshot(forPath:"orderTime").value  as? String ?? ""
                    //let drinks = snap.childSnapshot(forPath:"drinks")
                    
                    if userEmail ==  self.email{
                        let order : Order = Order(userEmail:userEmail, status:status, orderTotalPrice:orderTotalPrice, orderTime:orderTime);
                        temp.append(order);
                    }
                }
                self.orders = temp
                DispatchQueue.main.async { self.table.reloadData(); }
              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
}
