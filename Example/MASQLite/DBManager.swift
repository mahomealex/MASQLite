//
//  DBManager.swift
//  MASQLite
//
//  Created by 林东鹏 on 29/08/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import SQLite
import MASQLite


class DBManager  {
    static let sharedInstance = DBManager()
    
    fileprivate var _db:Connection!
    
    
    fileprivate var _operation : MAOperation?
    
    private init() {
        
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
        /*
            if you wanna provide different db for different account, just modify your authId
         */
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
        //clean old schema cache, so db can upgrade table if needed
        MASchemaCache.cleanAll()
        
        //upgrade table if needed
        _db.dbUpdate()
        
        //some migration here
    }
    
}

extension DBManager {
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
