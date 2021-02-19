//
//  CheckoutVC.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-04.
//

import UIKit

import FirebaseUI
import FirebaseCore
import FirebaseDatabase

class ShoppingCartVC : UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var shoppingList : [CartItem]?
    @IBOutlet weak var tableView: UITableView!
    
    // Firebase reference
    let ref = Database.database().reference()
    
    
    // ⚠️Action when user click confirm
    // 1. Add all drinks inside cart into Database
    // 2. Clear the cart
    // 3. Close this VC & Navigate to OrderPlaceVC
    @IBAction func confirmAction(_ sender: Any) {
        

    // ⚠️Make sure the confirmButton is available only if the cart is not empty
        
        // 1. Add all drinks inside cart into Database
        ref.child("orderList").childByAutoId().setValue([
                                                            "Drink1":[
                                                                        "Ice":"Less",
                                                                        "Sugar":"Normal"
                                                                     ],
                                                            "Drink2":[
                                                                        "Ice":"Less",
                                                                        "Sugar":"Normal"
                                                                     ],
                                                            "orderTime":"2021-02-19 22:40:01",
                                                            "totalPrice":12
                                                        ])
        let length = shoppingList?.count
        if length! > 0 {
            for index in 0...(length!-1){
                print(shoppingList![index].tea?.name_en)
            }
        }

        
        // 3. Close this VC & Navigate to OrderPlaceVC
        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "OrderPlacedVC") as UIViewController, animated: true)
    }
    
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
        
//        let ref = Database.database().reference()
////        ref.child("userCredits/userID").setValue("2@gmail.com")
//        let orderID:String = "test12345"
////        ref.child("userCredits/2@gmail,com/orderID").setValue(orderID)
//        ref.child("userCredits/2@gmail,com").child(orderID).setValue([
//                                                               "creditBefore":70,
//                                                               "creditAfter":80,
//                                                               "creditChange":10
//                                                              ])

    }

    
    
}
