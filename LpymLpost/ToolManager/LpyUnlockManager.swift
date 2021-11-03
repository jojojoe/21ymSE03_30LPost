//
//  LpyUnlockManager.swift
//  LpymLpost
//
//  Created by JOJO on 2021/11/2.
//

import Foundation
import SwiftyJSON


class LpyUnlockManager: NSObject {
    static let `default` = LpyUnlockManager()
    var k_ud_unlockName = "k_lp_unlockName"
    
    let freeList: [String] = ["原图", "LOMO", "黑白"]
    
    func hasUnlock(itemId: String) -> Bool {
        var freeAndUnlockList: [String] = []
        
        
        freeAndUnlockList.append(contentsOf: freeList)
        
        let unlockJsonStr = UserDefaults.standard.value(forKey: k_ud_unlockName) as? String ?? ""
        do {
            let data = try JSON.init(parseJSON: unlockJsonStr).rawData()
            let model = try JSONDecoder().decode([String].self, from: data)
            freeAndUnlockList.append(contentsOf: model)
        } catch {

        }
        
        if freeAndUnlockList.contains(itemId) {
            return true
        }
        return false
    }
    
    
    func unlock(itemId: String, completion: (()->Void)) {
        if let unlockJsonStr = UserDefaults.standard.value(forKey: k_ud_unlockName) as? String {
            do {
                let data = try JSON.init(parseJSON: unlockJsonStr).rawData()
                let model = try JSONDecoder().decode([String].self, from: data)
                var unlockList_m = model
                unlockList_m.append(itemId)
                let jsonStr = unlockList_m.toString
                UserDefaults.standard.setValue(jsonStr, forKey: k_ud_unlockName)
                completion()
            } catch {
                
            }
        } else {
            let jsonStr = [itemId].toString
            UserDefaults.standard.setValue(jsonStr, forKey: k_ud_unlockName)
            completion()
        }
    }
}
 
