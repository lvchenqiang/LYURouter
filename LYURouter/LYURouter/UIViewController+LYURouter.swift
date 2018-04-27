//
//  UIViewController+LYURouter.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/26.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import Foundation
import UIKit

 protocol LYURouterDelegate:NSObjectProtocol {
    
    /// 每个VC 所属的moduleID
    var moduleID:String {get}
  
 
}







extension UIViewController
{
    
    private struct AssociatedKeys{
        static var kRouterTransformStyleKey = "kRouterTransformStyleKey"
        static var KRouterViewControllerKey = "KRouterViewControllerKey"
        static var KCheckAccessOpenKey = "KCheckAccessOpenKey"
        static var KRouterSpecialTransformKey = "KRouterSpecialTransformKey"
        static var KBelongToTabbarKey = "KBelongToTabbarKey"
        static var kTabIndexKey = "kTabIndexKey"
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
    
    // MARK:取出对应的导航栏 处理转场动画
    var routerSpecialTransformNavigation:UINavigationController?
    {
        get{
            return self.navigationController;
        }
    }
    // MARK:路由初始化方法
    var routerInstanceViewController:UIViewController {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.KRouterViewControllerKey) as? UIViewController ?? self;
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.KRouterViewControllerKey, newValue, .OBJC_ASSOCIATION_RETAIN);
        }
    }

    
   // MARK:校验是否有权限打开
    var checkAccessOpen:Bool {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.KCheckAccessOpenKey) as? Bool ?? true;
        }
        set{
          objc_setAssociatedObject(self, &AssociatedKeys.KCheckAccessOpenKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // MARK:是否属于tabbar
    var belongToTabbar:Bool{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.KBelongToTabbarKey) as? Bool ?? false;
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.KBelongToTabbarKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    // MARK:tabbar对应的索引
    var tabIndex:NSInteger {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.kTabIndexKey) as? NSInteger ?? -1;
        }
        set{
          objc_setAssociatedObject(self, &AssociatedKeys.KCheckAccessOpenKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    
   
}

