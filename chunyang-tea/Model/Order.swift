//
//  Order.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-04-08.
//

import Foundation
class Order {
    var userEmail: String
    var status: String
    var orderTotalPrice: String
    var orderTime: String
    
    init(userEmail: String, status: String, orderTotalPrice : String,orderTime:String ) {
        self.userEmail = userEmail;
        self.status = status;
        self.orderTime = orderTime;
        self.orderTotalPrice = orderTotalPrice;
    }
}

