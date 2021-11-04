//
//  InnLiHandler.swift
//  LPymLpost
//
//  Created by fly on 2021/11/02.
//  Copyright © 2021 flyue All rights reserved.
//

import UIKit
import WebKit

class InnLiHandler: NSObject {
    class func clearWebCache () {
        
        let storage:HTTPCookieStorage = HTTPCookieStorage.shared
        for cookie in storage.cookies ?? [] {
            storage.deleteCookie(cookie)
        }
     
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
    }
}
