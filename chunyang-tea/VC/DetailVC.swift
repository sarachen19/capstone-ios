//
//  DetailVC.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-04.
//

import UIKit

var tempItem = CartItem(tea: nil, drinkTemp: nil, drinkSugar: nil, drinkSize: nil, totalPrice: nil, lastUpdateTime: "")

class DetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tea : DrinkData?
    var image : UIImage?
    
    @IBOutlet weak var nameZHLabel: UILabel!
    @IBOutlet weak var nameENLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var drinkImageView: UIImageView!
    
    @IBOutlet weak var calorieMLabel: UILabel!
    @IBOutlet weak var calorieLLabel: UILabel!
    
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var temperatureTableView: UITableView!
    @IBOutlet weak var sugarView: UIView!
    @IBOutlet weak var sugarTableView: UITableView!
    @IBOutlet weak var sizeView: UIView!
    @IBOutlet weak var sizeTableView: UITableView!
    @IBOutlet weak var addOnView: UIView!
    @IBOutlet weak var addOnTableView: UITableView!
    @IBOutlet weak var saySomethingView: UIView!
    @IBOutlet weak var saySomethingTextView: UITextView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var orderBtn: UIButton!
    
    var currentOption: OptionType? = nil
    
    //    private let bottomY: CGFloat = 740
        let sectionPosition: [OptionType : [String : CGFloat]] = [
            .temp: [
                "up": 152,
                "down": 740-51*5
            ],
            .sugar: [
                "up": 152+51,
                "down": 740-51*4
            ],
            .size: [
                "up": 152+51*2,
                "down": 740-51*3
            ],
            .addOn: [
                "up": 152+51*3,
                "down": 740-51*2
            ],
            .saySomething: [
                "up": 152+51*4,
                "down": 740-51
            ],
        ]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tempItem.tea = tea
        // 設定 table view 大小
        temperatureTableView.frame.size.height = CGFloat(48*Temp.allCases.count)
        sugarTableView.frame.size.height = CGFloat(48*Sugar.allCases.count)
        sizeTableView.frame.size.height = CGFloat(48*Size.allCases.count)
        // 設定 btn style and disabled
        orderBtn.layer.cornerRadius = 6
        orderBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        setOrderBtnEnabled(false)
        
        // 設定選項縮小
        optionExpand()
        // 設定初始資訊
        setBasicInfo()
        
        // 設定 NotificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(clearTempCellStyle), name: NSNotification.Name("clearTempCellStyle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearSugarCellStyle), name: NSNotification.Name("clearSugarCellStyle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearSizeCellStyle), name: NSNotification.Name("clearSizeCellStyle"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBrief), name: NSNotification.Name("updateBrief"), object: nil)
    }
    
    // 更新 brief 與 確認是否可購買
    @objc func updateBrief() {
        var outputStr: String = ""
        var totalPrice: Double = 0.0
        var isCanOrder: Bool = false
        if let priceM = tea?.priceM {
            totalPrice = priceM
        }
        
        if let temp = tempItem.drinkTemp {
            let str = temp.rawValue.components(separatedBy: " ")[0]
            outputStr += "\(str)、"
        }
        if let sugar = tempItem.drinkSugar {
            let str = sugar.rawValue.components(separatedBy: " ")[0]
            outputStr += "\(str)、"
        }
        if let size = tempItem.drinkSize {
            let str = size.rawValue.components(separatedBy: " ")[0]
            outputStr += "\(str)"
            // 中杯、大杯價格
            if size == .medium,
               let priceM = tea?.priceM {
                totalPrice = priceM
            } else if size == .large,
              let priceL = tea?.priceL {
                totalPrice = priceL
            }
        }
        for ingredient in tempItem.addOn {
            let str = ingredient.rawValue.components(separatedBy: " ")[0].prefix(2)
            outputStr += "、加\(str)"
            // 加白玉墨玉加錢
            if ingredient == .whiteBubble {
                totalPrice += 2
            } else if ingredient == .blackBubble {
                totalPrice += 3
            }
        }

        // 檢查是否訂購
        if let _ = tempItem.drinkTemp, let _ = tempItem.drinkSugar, let _ = tempItem.drinkSize {
            isCanOrder = true
        }

        
        isCanOrder = true
        tempItem.totalPrice = totalPrice
        
        briefLabel.text = outputStr
        priceLabel.text = "$\(totalPrice)"
        //order.totalPrice = totalPrice
        setOrderBtnEnabled(isCanOrder)
    }
    
    func setOrderBtnEnabled(_ isEnabled: Bool) {
        if isEnabled {
            orderBtn.isEnabled = true
            orderBtn.tintColor = UIColor.systemYellow
        } else {
            orderBtn.isEnabled = false
            orderBtn.tintColor = UIColor.clear
        }
    }
    
    func setBasicInfo() {
        nameZHLabel.text = tea!.name_en
        nameENLabel.text = tea!.name_en
        descriptionLabel.text = tea!.description
        calorieMLabel.text = String(tea!.maxCalorieM)
        calorieLLabel.text = String(tea!.maxCalorieL)
        // 圖片
        drinkImageView.image = image
        // 價錢
        priceLabel.text = "$\((tea?.priceM)!)"
        // brief
        briefLabel.text = "請選擇飲品溫度、甜度、份量"
    }
    
    func optionExpand() {
        var tempPosY: CGFloat?, sugarPosY: CGFloat?, sizePosY: CGFloat?, addOnPosY: CGFloat?, saySomePosY: CGFloat?
        
        switch currentOption {
        case .temp:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["down"]
            sizePosY = sectionPosition[.size]!["down"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .sugar:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["down"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .size:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["up"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .addOn:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["up"]
            addOnPosY = sectionPosition[.addOn]!["up"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        case .saySomething:
            tempPosY = sectionPosition[.temp]!["up"]
            sugarPosY = sectionPosition[.sugar]!["up"]
            sizePosY = sectionPosition[.size]!["up"]
            addOnPosY = sectionPosition[.addOn]!["up"]
            saySomePosY = sectionPosition[.saySomething]!["up"]
        default:
            tempPosY = sectionPosition[.temp]!["down"]
            sugarPosY = sectionPosition[.sugar]!["down"]
            sizePosY = sectionPosition[.size]!["down"]
            addOnPosY = sectionPosition[.addOn]!["down"]
            saySomePosY = sectionPosition[.saySomething]!["down"]
        }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.temperatureView.frame.origin.y = tempPosY!
            self.sugarView.frame.origin.y = sugarPosY!
            self.sizeView.frame.origin.y = sizePosY!
            self.addOnView.frame.origin.y = addOnPosY!
            self.saySomethingView.frame.origin.y = saySomePosY!
        }
        
        // 取消文字編輯
        saySomethingTextView.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var counts: Int?
        switch tableView {
        case self.temperatureTableView:
            counts = Temp.allCases.count
        case self.sugarTableView:
            if tea?.isSugarFixed == true {
                counts = 1
            } else {
                counts = Sugar.allCases.count
            }
        case self.sizeTableView:
            if tea?.priceL == 0.0 {
                counts = 1
            } else {
                counts = Size.allCases.count
            }
        case self.addOnTableView:
            var count = AddOn.allCases.count
            if tea?.isCanAddWhiteBubble == false {
                count -= 1
            }
            if tea?.isCanAddBlackBubble == false {
                count -= 1
            }
            counts = count
        default:
            counts = 0
        }
        return counts!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView {
        case self.temperatureTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionSelectCell", for: indexPath) as! OptionSelectCell
            (cell as! OptionSelectCell).optionType = .temp
            (cell as! OptionSelectCell).option = Temp.allCases[indexPath.row]
        case self.sugarTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionSelectCell", for: indexPath) as! OptionSelectCell
            (cell as! OptionSelectCell).optionType = .sugar
            (cell as! OptionSelectCell).option = Sugar.allCases[indexPath.row]
        case self.sizeTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionSelectCell", for: indexPath) as! OptionSelectCell
            (cell as! OptionSelectCell).optionType = .size
            (cell as! OptionSelectCell).option = Size.allCases[indexPath.row]
        case self.addOnTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "OptionCheckCell", for: indexPath) as! OptionCheckCell
            var addOnArr = AddOn.allCases
            if tea?.isCanAddWhiteBubble == false {
                addOnArr = addOnArr.filter({ $0 != .whiteBubble })
            }
            if tea?.isCanAddBlackBubble == false {
                addOnArr = addOnArr.filter({ $0 != .blackBubble })
            }
            (cell as! OptionCheckCell).option = addOnArr[indexPath.row].rawValue
        default:
            break
        }
        return cell
    }
    
    // 設定當前 option view
    @IBAction func setMode(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            if currentOption == .temp {
                currentOption = nil
            } else {
                currentOption = .temp
            }
        case 1:
            if currentOption == .sugar {
                currentOption = nil
            } else {
                currentOption = .sugar
            }
        case 2:
            if currentOption == .size {
                currentOption = nil
            } else {
                currentOption = .size
            }
        case 3:
            if currentOption == .addOn {
                currentOption = nil
            } else {
                currentOption = .addOn
            }
        case 4:
            if currentOption == .saySomething {
                currentOption = nil
            } else {
                currentOption = .saySomething
            }
        default:
            break
        }
        optionExpand()
    }
    
    
    @objc func clearTempCellStyle() {
        temperatureTableView.visibleCells.forEach({
            ($0 as? OptionSelectCell)?.setBtnStyle(isActive: false)
        })
    }
    @objc func clearSugarCellStyle() {
        sugarTableView.visibleCells.forEach({
            ($0 as? OptionSelectCell)?.setBtnStyle(isActive: false)
        })
    }
    @objc func clearSizeCellStyle() {
        sizeTableView.visibleCells.forEach({
            ($0 as? OptionSelectCell)?.setBtnStyle(isActive: false)
        })
    }
    
    
    @IBAction func addToCart(_ sender: Any) {
        // 訂購按鈕鎖定
        setOrderBtnEnabled(false)
        
        if tempItem.tea != nil {SharedData.shoppingList.append(tempItem);}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shoppingCart" {
            let shoppingCart = segue.destination as? ShoppingCartVC
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        tempItem = CartItem(tea: nil, drinkTemp: nil, drinkSugar: nil, drinkSize: nil, totalPrice: nil, lastUpdateTime: "")
    }
    
}
