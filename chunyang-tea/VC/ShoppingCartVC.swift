//
//  CheckoutVC.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-04.
//

import UIKit

import FirebaseUI
import FirebaseCore

class ShoppingCartVC : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var shoppingList : [CartItem]?
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartItem", for: indexPath)
        let item = self.shoppingList![indexPath.row]
        cell.textLabel!.text = item.tea?.name_en
        //cell.detailTextLabel!.text = String(item.totalPrice!)
        
        return cell
    }
    
    override func viewDidLoad() {
        self.shoppingList = SharedData.shoppingList
        print(UserDefaults.standard.string(forKey: "userEmail"))
    }

    
    
}
