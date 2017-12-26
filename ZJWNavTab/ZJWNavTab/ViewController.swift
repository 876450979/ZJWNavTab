//
//  ViewController.swift
//  ZJWNavTab
//
//  Created by 赵建卫 on 2017/12/26.
//  Copyright © 2017年 赵建卫. All rights reserved.
//

import UIKit
let BOUNDS_WIDTH = UIScreen.main.bounds.size.width
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.view.backgroundColor = UIColor.white
        
        let filesave = FileSave.sharedManager
        let btnlist = filesave.loadGameData(fileName: "BtnList.txt")
        //添加SegmentView
        let seg = SegmentView(frame: CGRect(x:0,y:64,width:BOUNDS_WIDTH,height:50), titles: btnlist)
        seg.backgroundColor = UIColor.red.withAlphaComponent(0.3)
        seg.SelectedBlock = { selectedItem in
            print("🍓----\(selectedItem)")
        }
        self.view.addSubview(seg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

