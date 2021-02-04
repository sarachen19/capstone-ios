//
//  Order.swift
//

import Foundation

class CartItem {
    var tea: DrinkData?
    var drinkTemp: Temp?
    var drinkSugar: Sugar?
    var drinkSize: Size?
    var addOn: Array<AddOn> = []
    var saySomething: String = "想說點什麼呢..."
    var totalPrice: Double?
    let lastUpdateTime: String
    
    init(tea: DrinkData?,
         drinkTemp: Temp?,
         drinkSugar: Sugar?,
         drinkSize: Size?,
         totalPrice: Double?,
         lastUpdateTime: String) {
        self.tea = tea
        self.drinkTemp = drinkTemp
        self.drinkSugar = drinkSugar
        self.drinkSize = drinkSize
        self.totalPrice = totalPrice
        self.lastUpdateTime = lastUpdateTime
    }
    
    func reset() {
        tea = nil
        drinkTemp = nil
        drinkSugar = nil
        drinkSize = nil
        addOn = []
        saySomething = "想說點什麼呢..."
        totalPrice = nil
    }
}
