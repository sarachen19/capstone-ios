//
//  FirebaseHelper.swift
//  chunyang-tea
//
//  Created by 陈西 on 2021-02-03.
//

import Foundation
import Firebase

protocol ServiceDelegate {
    func ServiceDelegateDidFinishWithTeaList(list : NSArray)
    func ServiceDelegateDidFinishWithOrderList(list : NSArray)
}

class FirebaseHelper {
    var delegate : ServiceDelegate?

    static var shared : FirebaseHelper = FirebaseHelper()
    
    /*
     ------------------get image from url-----------------
     =====================================================
     use completion handler
     */
    func getImageData(url: String?, complition: @escaping (Data?)->Void) {
        guard let thisURl = url else {return}
        guard let url = URL(string: thisURl) else {return}
        URLSession.shared.dataTask(with: url) { (data, request, error) in
            complition(data)
        }.resume()
        
    }
    
    
    
}
