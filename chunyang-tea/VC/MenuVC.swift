//
//  MenuVC.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-03.
//

import UIKit

import FirebaseUI
import FirebaseCore

class MenuVC : UIViewController, FUIAuthDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var teaList : [DrinkData] = [DrinkData]()
    var ref: DatabaseReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure();
            }
        readListData()
        //test username
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.set("test@gmail.com", forKey:"userEmail");
        UserDefaults.standard.synchronize();
        
        // Hide the navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)


    }
    
    func readListData() {
        ref = Database.database().reference()
        if ref != nil {
            ref!.child("teaList").observeSingleEvent(of: .value, with: { (snapshot) in
              // Get  value
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let name_en = snap.childSnapshot(forPath:"name_en").value as? String ?? ""
                    let description = snap.childSnapshot(forPath:"description").value as? String ?? ""
                    let imageUrl = snap.childSnapshot(forPath:"imageUrl").value  as? String ?? ""
                    let isCanAddBlackBubble = snap.childSnapshot(forPath:"isCanAddBlackBubble").value  as? Bool ?? true
                    let isCanAddWhiteBubble = snap.childSnapshot(forPath:"isCanAddWhiteBubble").value  as? Bool ?? true
                    let isPopular = snap.childSnapshot(forPath:"isPopular").value  as? Bool ?? true
                    let isSugarFixed = snap.childSnapshot(forPath:"isSugarFixed").value  as? Bool ?? true
                    let maxCalorieL = snap.childSnapshot(forPath:"maxCalorieL").value  as? Int ?? 0
                    let maxCalorieM = snap.childSnapshot(forPath:"maxCalorieM").value  as? Int ?? 0
                    let priceL = snap.childSnapshot(forPath:"priceL").value  as? Double ?? 0.0
                    let priceM = snap.childSnapshot(forPath:"priceM").value as? Double ?? 0.0

                    let tea : DrinkData = DrinkData(name_en:name_en, description:description, imageUrl:imageUrl, priceM:priceM, maxCalorieM:maxCalorieM, priceL:priceL, maxCalorieL:maxCalorieL, isCanAddWhiteBubble:isCanAddWhiteBubble, isCanAddBlackBubble: isCanAddBlackBubble, isSugarFixed:isSugarFixed, isPopular:isPopular);
                    self.teaList.append(tea);
                }
                DispatchQueue.main.async { self.tableView.reloadData(); }
              // ...
              }) { (error) in
                print(error.localizedDescription)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teaList.count
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teaListCell", for: indexPath) as! MenuTableViewCell
        let tea = self.teaList[indexPath.row]
        cell.cellNameLbl!.text = tea.name_en
        cell.cellDescLbl!.text = tea.description
        cell.cellPriceLbl!.text = "\(tea.priceM) + "
        FirebaseHelper.shared.getImageData(url: tea.imageUrl) { (data) in
            if let data = data {
                DispatchQueue.main.async {[unowned self]in
                    cell.cellImage.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tea = self.teaList[indexPath.row]
        
   }
    
//    override func viewWillAppear(_ animated: Bool) {
//        
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "menuToDetail" {
            let detailViewController = segue.destination as? DetailVC
            let selectedCell = sender as! MenuTableViewCell

            let index = tableView.indexPath(for: selectedCell)!
            let tea = self.teaList[index.row]
            let image : UIImage = selectedCell.cellImage.image!
            detailViewController?.tea = tea
            detailViewController?.image = image
        }
    }
}
