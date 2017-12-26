//
//  BtnCollectionView.swift
//  Duo Er Wen Hua
//
//  Created by zhangdan on 2017/11/28.
//  Copyright © 2017年 Sui Zhou Duo Er Wen Hua Chuan Bo. All rights reserved.
//

import UIKit

class BtnCollectionView: UICollectionView,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {
    
    var titles = NSMutableArray()
    var scrollBtnArray = [UIButton]() //scrollview上的按钮 用来在加载的时候设置被选中按钮为红色
    var isChangeLocAndDelete:Bool = false//是否可调换位置和删除
    
    fileprivate var addlist = NSMutableArray() //可添加的栏目
    fileprivate var pan:UIPanGestureRecognizer?
    fileprivate var longGesture:UILongPressGestureRecognizer?
    
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        self.register(UINib.init(nibName: "CoBtnCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.register(NormalHeader.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
        
        //此处给其增加长按手势，用此手势触发cell移动效果
        longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(handlelongGesture(gr:)))
        self.addGestureRecognizer(longGesture!)
        
         //获取可添加栏目数组
        addlist = FileSave.sharedManager.loadGameData(fileName: "ADDList.txt")
        //点击 排序删除按钮 收到通知  实现方法
        NotificationCenter.default.addObserver(self, selector: #selector(sortDeleted(info:)), name: NSNotification.Name(rawValue: "sortDelete"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc fileprivate func handlelongGesture(gr:UILongPressGestureRecognizer) {
        isChangeLocAndDelete = true
        for segment in (superview?.subviews)! {
            if segment.isKind(of: SegmentView.classForCoder()){
                for scrollview in segment.subviews {
                    if scrollview.isKind(of: NSClassFromString("WangYiNews.ScrollviewHeaderView")!) {
                    
                        let view  = scrollview as! ScrollviewHeaderView
                        view.explainLabel.text =  "拖动排序"
                        view.selectBtn.isSelected = true
                        
                    }
                }
            }
        }
        
        if pan == nil {
            pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlepanGes(panGr:)))
            pan?.delegate = self
            self.addGestureRecognizer(pan!)
        }
        
        
    }

    @objc fileprivate func sortDeleted(info:Notification) {
        let number = info.userInfo!["selectBool"]
        let selectbool = number as! Bool
        if selectbool {
            isChangeLocAndDelete = true
            handlelongGesture(gr: longGesture!)
        }else{
            isChangeLocAndDelete = false
            self.removeGestureRecognizer(pan!)
            pan = nil
        }
        reloadData()
    }
    
    @objc fileprivate func handlepanGes(panGr:UIPanGestureRecognizer) {
        
        let indexPath = self.indexPathForItem(at: panGr.location(in: self))
        let cell = cellForItem(at: IndexPath.init(row: 0, section: 0))
        
        //判断手势状态
        switch panGr.state {
        case .began:
            //判断手势落点位置是否在路径上
            if indexPath == nil {
                break
            }
            //在路径上则开始移动该路径上的cell
            beginInteractiveMovementForItem(at: indexPath!)
        case .changed:
            //移动过程当中随时更新cell位置
            
            if CGPath.init(rect: (cell?.frame)!, transform: nil).contains(panGr.location(in: self), using: .winding, transform: .identity) {
                
               
            }else{
                updateInteractiveMovementTargetPosition(panGr.location(in: self))
            }
        case .ended:
            //移动结束后关闭cell移动
            endInteractiveMovement()
            
        default:
            
            cancelInteractiveMovement()
            print("")
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        if isChangeLocAndDelete {
            return 1
        }else{
            return 2
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return  titles.count
        }else if section == 1 {
            return addlist.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CoBtnCell
        
        if indexPath.section == 0{
            let btn = scrollBtnArray[indexPath.row]
            cell.itemName = titles[indexPath.row] as? String
            cell.isSelecting = btn.isSelected
            cell.indexPath = indexPath
            cell.deleteBtn.addTarget(self, action: #selector(DeleteAciton(sender:)), for: .touchUpInside)
            cell.deleteBtn.isHidden = true
            cell.imageview.isHidden = false
            if isChangeLocAndDelete {
                cell.label.textColor = UIColor.black
                cell.deleteBtn.isHidden = false
            }
            
            if indexPath.row == 0 {
                cell.deleteBtn.isHidden = true
                cell.imageview.isHidden = true
            }
        }else{
            cell.deleteBtn.isHidden = true
            cell.itemName = addlist[indexPath.row] as? String
            cell.isSelecting = false
            cell.indexPath = indexPath
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let btn = scrollBtnArray[indexPath.row]
            btn.isSelected = true
            scrollBtnArray.remove(at: indexPath.row)
            scrollBtnArray.insert(btn, at: indexPath.row)
            notifation(titleArray: titles, scrollBtnArray: scrollBtnArray, isSelectedOne: true)
        }else if indexPath.section == 1 {
            
            let item = addlist[indexPath.row]
            titles.add(item)
            addlist.remove(item)
//            addlist.remove(at: indexPath.row)
            FileSave.sharedManager.saveGameData(data: titles , saveFileName: "BtnList.txt")
            FileSave.sharedManager.saveGameData(data: addlist , saveFileName: "ADDList.txt")
            
            let btn = UIButton.init(type: .custom)
            btn.isSelected = false
            scrollBtnArray.append(btn)
            reloadData()
            notifation(titleArray: titles, scrollBtnArray: scrollBtnArray, isSelectedOne: false)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! NormalHeader
            header.label?.text = "点击以下按钮添加栏目"
            header.label?.textColor = UIColor.black
            
            return header
        }
        var reuseView : UICollectionReusableView?
        return reuseView!
    }
    //重新定义section页眉的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var size:CGSize?
        if section == 0 {
            size = CGSize(width:0,height:0)
        }else{
            size = CGSize(width:320,height:50)
        }
        
        return size!
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        //取出源item数据
        let objc = titles[sourceIndexPath.item]
        let objc1 = scrollBtnArray[sourceIndexPath.item]
        //从资源数组中移除该数据
        titles.remove(objc)
        let index = scrollBtnArray.index(before: sourceIndexPath.item+1)
        scrollBtnArray.remove(at: index)

        //将数据插入到资源数组中的目标位置上
        titles.insert(objc, at: destinationIndexPath.item)
        scrollBtnArray.insert(objc1, at: destinationIndexPath.item)
        notifation(titleArray: titles, scrollBtnArray: scrollBtnArray, isSelectedOne: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        //返回YES允许其item移动
        if indexPath.row == 0 {
            return false
        }else{
            return true
        }
    }
    
    //对collectionveiw操作后 需要传递参数给scrollview
    fileprivate func notifation(titleArray:NSMutableArray,scrollBtnArray:[UIButton],isSelectedOne:Bool) {
        
        let number = NSNumber.init(value: isSelectedOne)
        let dic = ["index":number,"array":titleArray,"btnArray":scrollBtnArray] as [String : Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "collectionSelect"), object: nil, userInfo: dic)
        
    }
    
    deinit {
        self.delegate = nil
        self.dataSource = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func DeleteAciton(sender:UIButton) {
        
        if sender.tag == 0 {
            return
        }
        let item = titles[sender.tag]
         addlist.insert(item, at: 0)
        
        titles.remove(item)
        scrollBtnArray.remove(at: sender.tag)
        FileSave.sharedManager.saveGameData(data: titles , saveFileName: "BtnList.txt")
        FileSave.sharedManager.saveGameData(data: addlist , saveFileName: "ADDList.txt")
        reloadData()
        notifation(titleArray: titles, scrollBtnArray: scrollBtnArray, isSelectedOne: false)
        
    }
    

}

class NormalHeader: UICollectionReusableView {
    var label:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label = UILabel(frame: self.bounds)
        label?.font = UIFont.systemFont(ofSize: 13)
        label?.textColor = UIColor.white
        label?.textAlignment = .left
        label?.backgroundColor = UIColor(rgb:0xFCFCFC)
        self.addSubview(label!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
