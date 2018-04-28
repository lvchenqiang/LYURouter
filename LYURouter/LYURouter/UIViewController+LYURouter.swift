//
//  UIViewController+LYURouter.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/26.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import Foundation
import UIKit

 @objc protocol LYURouterDelegate:NSObjectProtocol {
    
    @objc optional  func routerToStart(_ options: LYURouterOptions);
    @objc optional  func routerToFinish(_ options: LYURouterOptions);
    
}


extension LYURouterDelegate where Self:UIViewController
{
    func routerToFinish(_ options: LYURouterOptions)
    {
        debugPrint("2222222-----routerToFinish");
    }
    
}





extension UIViewController
{
    
    private struct AssociatedKeys{
        static var kRouterTransformStyleKey = "kRouterTransformStyleKey"
    }
    
    // MARK:路由的前进风格
    var routerTransformStyle:LYURouterTransformStyle{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.kRouterTransformStyleKey) as? LYURouterTransformStyle ?? LYURouterTransformStyle.Push;
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kRouterTransformStyleKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    

  
// MARK:Methods
    // MARK:路由初始化方法
   @objc class func routerInstanceViewController() -> UIViewController
    {
        return self.init();
    }
    
    // MARK:校验是否有权限打开此应用
   @objc  class func routerCheckAccessOpen(options:LYURouterOptions) -> Bool
    {
        return true;
    }
    
    @objc class func routerHandleNoAccessToOpen(options:LYURouterOptions){
        debugPrint("没有权限打开此UI");
    }
    // MARK:是否属于tabbar
   @objc class func routerBelongToTabbar() -> Bool {
        
        return false;
    }
    
    // MARK:tabbar对应的索引
   @objc  class func routerTabIndex() -> NSInteger {
        return -1;
    }
    
    // MARK:取出对应的导航栏 处理转场动画
   @objc func routerTransformNavigation(nvc:UINavigationController){
        
    }
    
    // MARK:路由刷新
  @objc func routerReferesh(options:LYURouterOptions){
        
    }
    
}

