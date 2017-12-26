//
//  FileSave.swift
//  Duo Er Wen Hua
//
//  Created by zhangdan on 2017/11/28.
//  Copyright © 2017年 Sui Zhou Duo Er Wen Hua Chuan Bo. All rights reserved.
//

import UIKit

class FileSave: NSObject {

    internal static let sharedManager = FileSave()
    
    func saveGameData(data:NSMutableArray,saveFileName fileName:String) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        if  documentsDirectory == "" || documentsDirectory == nil {
            print("Documents directory not found!")
            return false
        }
        
        let appFile = documentsDirectory.stringByAppendingPathComponent(path: fileName)
        
        return data.write(toFile: appFile, atomically: true)
    }
    
    func loadGameData(fileName:String) -> NSMutableArray {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let appFile = documentsDirectory.stringByAppendingPathComponent(path: fileName)
        
        let myData = NSMutableArray.init(contentsOfFile: appFile)
        
        return myData!
    }
}
