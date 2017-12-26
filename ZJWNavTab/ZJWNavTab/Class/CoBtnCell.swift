//
//  CoBtnCell.swift
//  Duo Er Wen Hua
//
//  Created by zhangdan on 2017/11/28.
//  Copyright © 2017年 Sui Zhou Duo Er Wen Hua Chuan Bo. All rights reserved.
//

import UIKit

class CoBtnCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var imageview: UIImageView!
    
    // collectionview 名称
    var itemName:String?
    
    var isSelecting:Bool?  //该按钮是否在scrollview中被选中 如果是 则将字体颜色改成红色
    var indexPath:IndexPath? {
        didSet {
            createView()
            self.deleteBtn.tag = (indexPath?.row)!
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    fileprivate func createView() {
        label.text = itemName!
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        if indexPath?.row == 0 && indexPath?.section == 0 {
            label.textColor = UIColor.gray
        }else{
            
        }
        
        if isSelecting! {
            label.textColor = UIColor.red
        }
    }
    

}
