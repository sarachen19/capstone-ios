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
    
    var orderTotalPrice:Double = 0
    var shoppingList : [CartItem]?
    var orderUID:String!
    var userCredit:String = ""
    var creditDeduction:Bool = false
    var creditChangeTo:Int = 0
    var userID:String = ""
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderTotalPriceLabel: UILabel!
    
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
                            "qNum":"\(qNum)",
                            "userID":userID,
                            "orderID":orderUID
                    ])
        
            // Get the length of the cart list
        let length = shoppingList?.count

        
            // 1.2 For each tea in cart, add detail into database
        for index in 0...(length!-1){
            let teaInCart = shoppingList?[index]
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
    func userMustHasCreditRecord(uid : String) {
        ref.child("userCredits").observeSingleEvent(of: .value, with: { (snapshot) in

             if snapshot.hasChild("\(uid)"){
                
             }else{

                self.ref.child("userCredits/\(uid)")
                    .setValue(["credit":"0"])
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
    
    // Check the credit,  use credit to deduction.
    // if enough, adjust the shopping list cart
    // Comprehensively check the credit status
    func comprehensiveCheck() {
        
        // Make sure this user has credit record
        userMustHasCreditRecord(uid:userID)
        print("userCredits/\(userID)/credit")
        
        // Check how many credits user have
        self.ref.child("userCredits/\(userID)/credit")
            .observeSingleEvent(of: .value) { (snapshot) in
                self.userCredit = snapshot.value as! String
            }
        
        print(self.userCredit)
        
        // If the cart has at least 1 item
        if shoppingList!.count > 0{
            
            // if userCredit > 100 then activate the deduction
            if Int(userCredit)! >= 100{
                //Re-sort the cart list
                shoppingList?.sort{ $0.totalPrice! > $1.totalPrice!}
                // Set the first item's price to 0
                shoppingList![0].totalPrice = 0
                // Set deduction to true
                creditDeduction = true
                // Calculate the change of credit in this order
                creditChangeTo = Int(userCredit)! - 100 + (shoppingList!.count-1)*10
            }else{
                // Calculate the change of credit in this order
                creditChangeTo = Int(userCredit)!  + (shoppingList!.count)*10
            }
            // calculate the total price of this order base on new list
            for index in 0...(shoppingList!.count-1){
                orderTotalPrice += shoppingList![index].totalPrice ?? 0
            }
        }
    }
    
    override func viewDidLoad() {
        self.shoppingList = SharedData.shoppingList
        self.userID = Auth.auth().currentUser!.uid
//        print(UserDefaults.standard.string(forKey: "userEmail"))
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        // If the cart is empty, disable the confirm button
        if self.shoppingList!.count<1{
            confirmButton.isEnabled = false
            confirmButton.backgroundColor = UIColor.darkGray
        }
        
        comprehensiveCheck()
        self.orderTotalPriceLabel.text = "$\(orderTotalPrice)"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toOrderPlacedVC" {
            if let placedVC = segue.destination as? OrderPlacedVC{
                placedVC.orderID = self.orderUID
            }
        }
    }
    
}
