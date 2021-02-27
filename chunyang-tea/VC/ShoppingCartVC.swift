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
    var orderUID:String!
    
    @IBOutlet weak var tableView: UITableView!
    
    // Firebase reference
    let ref = Database.database().reference()
    
    
    // ⚠️Action when user click confirm
    // 1. Add all drinks inside cart into Database
    // 2. Clear the cart
    // 3. Modify reward points
    // 4. Close this VC & Navigate to OrderPlaceVC
    @IBAction func confirmAction(_ sender: Any) {
        

    // ⚠️Make sure the confirmButton is available only if the cart is not empty
        
        // 1. Add all drinks inside cart into Database
        
            //get UID of this order for locating it
        orderUID = ref.child("orderList").childByAutoId().key! as! String
        
            // Get current toronto time (UTC-5)
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC-5")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: now)
            //Set up refernce number - 取餐号码
        let letters = "ABCDEFGHIJKLMNPQRSTUVWXYZ"
        let numbers = "0123456789"
        let qNum = String((0..<1).map{ _ in letters.randomElement()! }) + String((0..<4).map{ _ in numbers.randomElement()! })
            // 1.1 Add some basic info of this order first
        ref.child("orderList/\(String(describing: orderUID as! String))")
           .setValue([
                            "orderTime":"\(dateString)",
                            "payVia":"App_Cash",
            "userEmail":"\( String( UserDefaults.standard.string(forKey: "userEmail")!))",
                            "qNum":"\(qNum)"
                    ])
        
            // Get the length of the cart list
        let length = shoppingList?.count
        var orderTotalPrice:Double = 0
        
            // 1.2 For each tea in cart, add detail into database
        for index in 0...(length!-1){
            let teaInCart = shoppingList?[index]
            orderTotalPrice += teaInCart?.totalPrice ?? 0
            ref.child("orderList/\(String(describing: orderUID as! String))")
               .child("drinks")
               .child("\(String(describing: teaInCart?.tea?.name_en as! String))")
               .setValue([
                            "drinkSize":"\(String(describing: teaInCart?.drinkSize?.rawValue as? String ?? "默认 Default"))",
                            "name_en":"\("\(String(describing: teaInCart?.tea?.name_en as! String))")",
                            "drinkSugar":"\(String(describing: teaInCart?.drinkSugar?.rawValue as? String ?? "默认 Default"))",
                            "drinkTemp":"\(String(describing: teaInCart?.drinkTemp?.rawValue as? String ?? "默认 Default"))",
                            "addOn":"\(String(describing: teaInCart?.addOn.description as? String ?? " "))",
                            "saySomething":"\(String(describing: teaInCart?.saySomething as? String ?? " "))",
                            "deduction":"False",
                            "price":"\(String(describing: teaInCart?.totalPrice as? Double ?? 0))",
                            "lastUpdateTime":"\(dateString)",
                            "currentStatus":"orderPlaced"
                        ])
        }
        
            // 1.3 Finally add the order total price in to DB
        ref.child("orderList/\(String(describing: orderUID as! String))")
           .child("orderTotalPrice")
           .setValue("\(orderTotalPrice)")

        // 2. Clear the Cart
        SharedData.shoppingList.removeAll()
        
        // 3. Modify reward points
//        userMustHasCreditRecord(userEmail: UserDefaults.standard.string(forKey: "userEmail")!)
        
//        self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "OrderPlacedVC") as UIViewController, animated: false)
    }
    
    // A function to test if the user already has credit record
    func userMustHasCreditRecord(userEmail : String) {
        ref.child("orderList/userCredits").observeSingleEvent(of: .value, with: { (snapshot) in

             if snapshot.hasChild("test"){

             }else{

                self.ref.child("orderList/userCredits/\(userEmail)")
                    .setValue(0)
             }

         })
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toOrderPlacedVC" {
            if let placedVC = segue.destination as? OrderPlacedVC{
                placedVC.orderID = self.orderUID
            }
        }
    }
    
}
