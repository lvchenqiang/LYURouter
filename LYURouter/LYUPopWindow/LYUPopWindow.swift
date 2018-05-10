//
//  LYUPopWindow.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/5/9.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import Foundation
import UIKit

// MARK:基础弹框类型
class LYUPopWindow: UIView {
    
    ///阴影
  private(set)  var shadowView:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 0.6);
        v.translatesAutoresizingMaskIntoConstraints = false;
        return v;
    }()
    
    /// 内容视图
    private(set) var bgContentV:UIView = {
        let v = UIView();
        v.translatesAutoresizingMaskIntoConstraints = false;
        v.backgroundColor = UIColor.white;
        return v;
    }()
    
    ///点击阴影是否消失 默认true
    var isHideForTapShadow:Bool = true;
    
    /// 点击事件响应区域是否隐藏 默认true
    var isHideForTapEvent = true;
    
    /// 内容区域距上边距 (设置并更新约束)
    var contentMarTop:CGFloat = 0;
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.frame = UIScreen.main.bounds;
        self.setupUI();
    }
    fileprivate func setupUI(){
        self.addSubview(self.shadowView);
        self.addSubview(self.bgContentV);
        self.shadowView.frame = self.bounds;
        
        let centerXConstraint = NSLayoutConstraint.init(item: bgContentV, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0);
        let centerYConstraint = NSLayoutConstraint.init(item: bgContentV, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0);
        let widthConstraint = NSLayoutConstraint.init(item: bgContentV, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .width, multiplier: 0.8, constant: 0);
        let heightConstraint = NSLayoutConstraint.init(item: bgContentV, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .height, multiplier: 0.5, constant: 0);
        self.addConstraint(centerXConstraint)
        self.addConstraint(centerYConstraint)
        self.addConstraint(widthConstraint)
        self.addConstraint(heightConstraint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       if let point = touches.first?.location(in: self){
        if self.bgContentV.frame.contains(point){
            
        }else{
            if(self.isHideForTapShadow){
               self.removeFromSuperview();
            }
         }
        }
    }
}

// MARK:扩展方法类
extension LYUPopWindow{
    func showPop(){
        UIApplication.shared.keyWindow?.addSubview(self);
    }
    
}
