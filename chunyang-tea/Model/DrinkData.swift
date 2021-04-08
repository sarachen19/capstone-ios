//
//  DrinkData.swift
//  drink-order-app
//
//  Created by 郭家銘 on 2020/12/15.
//

import Foundation


class DrinkData {
    var name_en: String
    var description: String
    var imageUrl: String
    var priceM: Double
    var maxCalorieM: Int
    var priceL: Double
    var maxCalorieL: Int
    var isCanAddWhiteBubble: Bool
    var isCanAddBlackBubble: Bool
    var isSugarFixed: Bool
    var isPopular: Bool
    var deducted:Bool
    
    init(name_en: String, description : String, imageUrl : String, priceM : Double,maxCalorieM: Int, priceL : Double, maxCalorieL : Int, isCanAddWhiteBubble:Bool, isCanAddBlackBubble : Bool, isSugarFixed : Bool, isPopular:Bool ) {
        self.name_en = name_en
        self.description = description
        self.imageUrl = imageUrl
        self.priceM = priceM
        self.maxCalorieM = maxCalorieM
        self.priceL = priceL
        self.maxCalorieL = maxCalorieL
        self.isCanAddWhiteBubble = isCanAddWhiteBubble
        self.isCanAddBlackBubble = isCanAddBlackBubble
        self.isSugarFixed = isSugarFixed
        self.isPopular = isPopular
        self.deducted = false
    }
    }
