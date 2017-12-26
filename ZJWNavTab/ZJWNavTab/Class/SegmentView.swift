//
//  SegmentView.swift
//  Duo Er Wen Hua
//
//  Created by zhangdan on 2017/11/28.
//  Copyright © 2017年 Sui Zhou Duo Er Wen Hua Chuan Bo. All rights reserved.
//

import UIKit

class SegmentView: UIView {

    var SelectedBlock:((Int)->())?
    
    fileprivate var scrollView:UIScrollView!
    fileprivate var addBtn:UIButton!
    fileprivate var btnSelected = [UIButton]()
    fileprivate var headerView:ScrollviewHeaderView!//新闻类型选择
    fileprivate var btncollectionView:BtnCollectionView!//新闻类型排序 添加 删除
    fileprivate var titleArray = NSMutableArray()
    
    init(frame: CGRect,titles:NSMutableArray) {
        super.init(frame: frame)
        
        self.frame = CGRect(x:frame.origin.x,y:frame.origin.y,width:BOUNDS_WIDTH,height:50)
        
        titleArray = titles
        CreateView(frame, titleArray)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func CreateView(_ frame:CGRect,_ hostlist:NSMutableArray) {
        
        scrollView = UIScrollView(frame:CGRect(x:0,y:0,width:self.bounds.size.width-50,height:50))
        scrollView.backgroundColor = UIColor.white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.scrollsToTop = true
        
        var btnW:CGFloat = 0
        for i in 0..<titleArray.count {
            
            let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)]
            //根据文字大小  计算按钮的宽度
            let length = (titleArray[i] as! NSString).boundingRect(with: CGSize(width:320, height:50), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size.width
            let btn = UIButton(frame:CGRect(x:btnW, y:0, width:length+20, height:50))
            btn.setTitle(titleArray[i] as? String, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.red, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.tag = i + 100
            btn.addTarget(self, action: #selector(itemSelected(sender:)), for: .touchUpInside)
            
            //这里设置一开始默认第一个被点击。
            if i == 0 {
                btn.isSelected = true
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                if SelectedBlock != nil {
                    SelectedBlock!(i)
                }
            }
            
            scrollView.addSubview(btn)
            btnSelected.append(btn)
          btnW = btn.frame.size.width + btn.frame.origin.x
        }
        scrollView.contentSize = CGSize(width:btnW,height:0)
        self.addSubview(scrollView)
        
        addBtn = UIButton.init(type: .custom)
        addBtn.frame = CGRect(x:self.bounds.size.width-45,y: 5, width:40, height:40)
        addBtn.setImage(UIImage.init(named: "channel_nav_plus"), for: .normal)
        addBtn.addTarget(self, action: #selector(changeItem(sender:)), for: .touchUpInside)
        self.addSubview(addBtn)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "collectionSelect"), object: nil)
        //添加监听 点击collectioncell后，需要更新segment的视图
        NotificationCenter.default.addObserver(self, selector: #selector(collectionSelect(info:)), name: NSNotification.Name(rawValue: "collectionSelect"), object: nil)
    }
    //segment上按钮的点击响应方法
    @objc fileprivate func itemSelected(sender:UIButton){
        
        scrollviewItemSelected(sender)
        
        
    }
    //加号按钮点击响应方法
    @objc fileprivate func changeItem(sender:UIButton) {
    
        if headerView == nil {
            headerView = ScrollviewHeaderView(frame:self.bounds)
            headerView.backgroundColor = UIColor.white
            headerView.alpha = 0
            self.insertSubview(headerView, belowSubview: addBtn)
        }
        
        if btncollectionView == nil {
            
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width:(BOUNDS_WIDTH-130)/4,height:35)
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20)
            layout.headerReferenceSize = CGSize(width:BOUNDS_WIDTH,height:30)
            btncollectionView = BtnCollectionView.init(frame: CGRect(x:0, y:-(theResponeController().view.bounds.size.height)+64+50, width:self.bounds.size.width,  height:theResponeController().view.bounds.size.height-64-50), collectionViewLayout: layout)
           
            btncollectionView.titles = titleArray
            btncollectionView.scrollBtnArray = btnSelected
            if theResponeController().isKind(of: ViewController.classForCoder()) {
                let vc = theResponeController() as! ViewController
                vc.view?.insertSubview(btncollectionView, belowSubview: self)
            }
        }
        
        //按钮旋转动画
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            UIView.animate(withDuration: 0.35, animations: {
                self.addBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4))
                //渐变显示headerview
                self.headerView.alpha = 1
                //向下推出tabbar
                self.theResponeController().tabBarController?.tabBar.transform = CGAffineTransform(translationX: 0, y: 50)
                self.btncollectionView.transform = CGAffineTransform(translationX: 0, y: self.theResponeController().view.bounds.size.height)
            })
        }else{
            UIView.animate(withDuration: 0.35, animations: {
                self.addBtn.transform = .identity
                self.headerView.alpha = 0
                //还原tabbar
                self.theResponeController().tabBarController?.tabBar.transform = .identity
                    self.btncollectionView.transform = .identity
                
            }, completion: { (isFinished) in
                self.headerView.removeFromSuperview()
                self.headerView = nil
                
                self.btncollectionView.removeFromSuperview()
                self.btncollectionView = nil
            })
        }
    }
    
    //collectionview操作通知
    @objc fileprivate func collectionSelect(info:Notification) {
        
        /*
         首先 将通知传递过来的参数  array是按钮名称数组   btnarray是按钮对象  index是点击的按钮
         
         只要有对collectionview做出操作，
         1 先将_scrollView清空  然后重新创建btn
         */
        titleArray = info.userInfo!["array"] as! NSMutableArray
        let subViews = scrollView.subviews
        
        for view in subViews {
            view.removeFromSuperview()
        }
        
        btnSelected = info.userInfo!["btnArray"] as! [UIButton]
        scrollView.backgroundColor = UIColor.white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        var selectBtn:UIButton?
        var btnW:CGFloat = 0.0
        for i in 0..<titleArray.count {
            
            let btn = btnSelected[i]
            btn.setTitle(titleArray[i] as? String, for: .normal)
            btn.setTitleColor(UIColor.black, for: .normal)
            btn.setTitleColor(UIColor.red, for: .selected)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            let attributes = [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15)]
            //根据文字大小  计算按钮的宽度
            let length = (titleArray[i] as! NSString).boundingRect(with: CGSize(width:320, height:50), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes, context: nil).size.width
            
            btn.tag = i + 100
            btn.addTarget(self, action: #selector(itemSelected(sender:)), for: .touchUpInside)
            btn.frame = CGRect(x:btnW,y:0,width:length+20,height:50)
            scrollView.addSubview(btn)
            
            btnW = btn.frame.size.width + btn.frame.origin.x
            
            //判断传过来的btn数组中有没有btn是被选中的
            if btn.isSelected {
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
                selectBtn = btn
            }
        }
        
        scrollView.contentSize = CGSize(width:btnW,height
            :50)
        //num ＝ 0表示之前被选中按钮的在collectionview中被删除了  将设置第一个btn为被选中按钮
        if selectBtn == nil {
            scrollviewItemSelected(btnSelected[0])
        }
        
        //当点击collectionview中的cell时才会传递过来被点击的btn  然后改变btn状态
        let selectNumber = info.userInfo!["index"]
        let isslected = selectNumber as! Bool
        if isslected {
            scrollviewItemSelected(selectBtn!)
            changeItem(sender: addBtn)
        }
        
        
    }
    
    fileprivate func theResponeController() -> UIViewController {
        
        var object = self.next
        
        while !(object?.isKind(of: UIViewController.classForCoder()))! && object != nil{
            
            object = object?.next
        }
        
        let uc = object as! UIViewController
        
        return uc
    }
    
    fileprivate func scrollviewItemSelected(_ sender:UIButton) {
        //先全部设置为未点击  然后再单个设置被点击按钮的效果
        
        for btn in btnSelected {
            if btn.tag != sender.tag {
                btn.isSelected = false
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                btn.transform = .identity
            }
        }
        sender.isSelected = true
        UIView.animate(withDuration: 1) {
            sender.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }
        
        if sender.center.x < scrollView.bounds.size.width/2 {
            scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
        }else if scrollView.contentSize.width - sender.center.x < scrollView.bounds.size.width/2 {
            scrollView.setContentOffset(CGPoint(x:scrollView.contentSize.width - scrollView.bounds.size.width ,y: 0), animated: true)
        }else{
            scrollView.setContentOffset(CGPoint(x:sender.center.x-(scrollView.bounds.size.width/2), y:0), animated: true)
        }
        if SelectedBlock != nil {
            SelectedBlock!(sender.tag - 100)
        }
        
        
    }
    
}
