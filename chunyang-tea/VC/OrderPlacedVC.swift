//
//  OrderPlacedVC.swift
//  chunyang-tea
//
//  Created by Brad Guo on 2021-02-19.
//

import UIKit

class OrderPlacedVC: UIViewController {

    @IBAction func toMenuVC(_ sender: Any) {
        self.dismiss(animated: true) {
            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "menuVC") as UIViewController, animated: true)
        }
    }
    //    @IBOutlet weak var navigationBar: UINavigationItem!
    
    // When user click DONE, close this view and return to Menu VC.
//    @IBAction func toMenuVC(_ sender: Any) {
//        self.dismiss(animated: true) {
//            self.navigationController!.pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "menuVC") as UIViewController, animated: true)
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)

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
