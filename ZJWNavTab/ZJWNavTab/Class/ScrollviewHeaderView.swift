//
//  ScrollviewHeaderView.swift
//  Duo Er Wen Hua
//
//  Created by zhangdan on 2017/11/28.
//  Copyright © 2017年 Sui Zhou Duo Er Wen Hua Chuan Bo. All rights reserved.
//

import UIKit

class ScrollviewHeaderView: UIView {

    var explainLabel:UILabel!
    var selectBtn:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func createView() {
        
        explainLabel = UILabel(frame: CGRect(x:10,y:0,width:self.bounds.size.width/2,height:50))
        explainLabel.text = "切换栏目"
        explainLabel.textAlignment = .left
        explainLabel.adjustsFontSizeToFitWidth = true
        explainLabel.font = UIFont.systemFont(ofSize: 15)
        self.addSubview(explainLabel)
        
        selectBtn = UIButton.init(type: .custom)
        selectBtn.frame = CGRect(x:self.bounds.size.width-120,y:5,width:60,height:40)
        selectBtn.setBackgroundImage(UIImage.init(named: "channel_edit_button_bg"), for: .normal)
        selectBtn.setImage(UIImage.init(named: "channel_edit_button_selected_bg"), for: .normal)
        selectBtn.setTitle("排序/删除", for: .normal)
        selectBtn.setTitle("完成", for: .selected)
        selectBtn.addTarget(self, action: #selector(sortDelete(sender:)), for: .touchUpInside)
        selectBtn.setTitleColor(UIColor.gray, for: .normal)
        selectBtn.setTitleColor(UIColor.blue, for: .selected)
        selectBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.addSubview(selectBtn)
    }
    
    @objc fileprivate func sortDelete(sender:UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            explainLabel.text = "拖动排序"
        }else{
            explainLabel.text = "切换栏目"
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sortDelete"), object: nil, userInfo: ["selectBool":NSNumber.init(value: sender.isSelected)])
    }
    
}
