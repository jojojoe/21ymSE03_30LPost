//
//  DataEncoding.swift
//  LPymLpost
//
//  Created by fly on 2021/11/02.
//  Copyright © 2021 flyue All rights reserved.
//

import UIKit
import SwiftyStoreKit
import StoreKit

class ExchangeManage: NSObject {
    class func exchangeWithSSK(objcetID: String, completion: @escaping (PurchaseResult) -> Void) {        
        SwiftyStoreKit.purchaseProduct(objcetID) { a in
            completion(a)
        }
    }
}
