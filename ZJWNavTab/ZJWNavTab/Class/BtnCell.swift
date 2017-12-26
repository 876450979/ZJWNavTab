//
//  BtnCell.swift
//  Duo Er Wen Hua
//
//  Created by zhangdan on 2017/11/28.
//  Copyright © 2017年 Sui Zhou Duo Er Wen Hua Chuan Bo. All rights reserved.
//

import UIKit

class BtnCell: UICollectionViewCell {
    // collectionview 名称
    var itemName:String?
    var isSelecting:Bool?  //该按钮是否在scrollview中被选中 如果是 则将字体颜色改成红色
    var indexPath:IndexPath? {
        didSet {
            
        }
    }
    var deleteBtn:UIButton?
}
