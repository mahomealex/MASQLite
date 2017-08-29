//
//  ViewController.swift
//  MASQLite
//
//  Created by lindongpeng on 08/28/2017.
//  Copyright (c) 2017 lindongpeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //here's what we can do 
        
        DBManager.sharedInstance.accountChanged()
        
        let operation = DBManager.operation()!
        var ary = [UserModel]()
        NSLog("begin create and save single model")
        for idx in 0..<1000 {
            let user = UserModel()
            user.gender = 23
            user.name = "afd"
            user.uid = "\(idx)"
            
//            operation.save(model: user, inTableName: "user1")
//            operation.save(model: user, inTableName: "user2")
            ary.append(user)
        }
        operation.saveAll(models: ary, inTableName: "user1")
        NSLog("end create and save single model")
        
        NSLog("begin save 1000 users in table")
        operation.saveAll(models: ary, inTableName: "userArray")
        NSLog("end save 1000 users in table")
        
        //query
        NSLog("begin query users from table and convert to model array")
        let models1 = operation.queryAll(UserModel.self, inTableName: "user1")
        NSLog("end query users count = %d", models1.count)
        
        
        if let result = operation.query(UserModel.self, inTableName: "user1", primaryKey: "23") {
            print(result)
            print(result.uid)
        }
        
        if let result2 = operation.query(UserModel.self, inTableName: "notExistTable", primaryKey: "23") {
            print(result2)
            print(result2.uid)
        } else {
            print("query not result")
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

