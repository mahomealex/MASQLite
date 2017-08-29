//
//  ContactsManager.swift
//  FaceU
//
//  Created by 林东鹏 on 3/20/17.
//  Copyright © 2017 miantanteam. All rights reserved.
//

import Foundation
import SQLite


class MADBAccount {
    
    static let sharedInstance = MADBAccount()
    
    fileprivate var _db : Connection!
    
    fileprivate var _operation : MAOperation?
    
    private  init() {
    }
    
    
    private func dbPath() -> String {
        //https://developer.apple.com/library/content/technotes/tn2406/_index.html
        //        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var path = ""
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            path = url.absoluteString
        } else {
            path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last!
        }
        let authId = "000"
        return "\(path)/db_\(authId).sqlite3"
    }
    
    
    class func operation() -> MAOperation? {
        return sharedInstance._operation
    }
    
    public func accountChanged() {
        do {
            let dbPath = self.dbPath()
            _db = try Connection(dbPath)
        } catch {
            MAOperation.sqliteError("create db fail:\(error)")
            return
        }
        _operation = MAOperation()
        _operation!.db = _db
        MASchemaCache.cleanAll()
        
        _db.dbUpdate()
        //整合下旧数据
        
    }
}

extension MADBAccount {
    fileprivate func count(condition:Table) -> Int {
        var count:Int = 0
        if let op = _operation {
            op.runOperationSynchronously {
                do {
                    count = try self._db.scalar(condition.count)
                } catch {
                    MAOperation.sqliteError("scalar db error:\(error)")
                }
            }
        }
        return count
    }
}
