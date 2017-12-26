//
//  AppDelegate.swift
//  ZJWNavTab
//
//  Created by 赵建卫 on 2017/12/26.
//  Copyright © 2017年 赵建卫. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds);
        window?.rootViewController = UINavigationController.init(rootViewController: ViewController())
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        
        
        
        //网易新闻头部菜单数据
        let hostList:NSMutableArray = ["头条","娱乐","热点","体育","泉州","网易号","财经","科技","汽车","时尚","图片","跟贴","房产","直播","轻松一刻","段子","军事","历史","家居","独家","游戏","健康","政务","哒哒趣闻","美女","NBA","社会","彩票"]
        
        let addList:NSMutableArray = ["漫画","影视歌","中国足球","国际足球","CBA","跑步","手机","数码","移动互联","云课堂","态度公开课","旅游","读书","酒香","教育","亲子","暴雪游戏","情感","艺术","博客","论坛","型男","萌宠"]
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0]
        
        let BtnList = documentDirectory.stringByAppendingPathComponent(path: "BtnList.txt")
        let ADDList = documentDirectory.stringByAppendingPathComponent(path: "ADDList.txt")
        print(BtnList)
        print(ADDList)
        
        let manager = FileManager()
        if !manager.fileExists(atPath: BtnList) {
            manager.createFile(atPath: BtnList, contents: nil, attributes: nil)
            hostList.write(toFile: BtnList, atomically: true)
        }
        
        if !manager.fileExists(atPath: ADDList) {
            manager.createFile(atPath: ADDList, contents: nil, attributes: nil)
            addList.write(toFile: ADDList, atomically: true)
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
extension String {
    func stringByAppendingPathComponent(path: String) -> String {
        let nsString = self as NSString
        return nsString.appendingPathComponent(path)
    }
}
