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
        static var kLYURouter_MundleID = "kLYURouter_MundleID"
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

    var lyu_mundleID:String {
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.kLYURouter_MundleID) as? String ?? "";
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.kLYURouter_MundleID, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC);
        }
    }

    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
       
        if(key == LYURouter.shareRouter.routerHandle.lyu_ModuleIDKey){
            self.lyu_mundleID = value as? String ?? "";
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



extension String{
    
    var currentClass:AnyClass? {
        get{
            
            if  let appName: String = Bundle.main.infoDictionary!["CFBundleName"] as? String{
                return NSClassFromString("\(appName).\(self)")
            }
            return nil;
        }
    }
    
    
    func convertToClass<T>(_ type:T.Type) -> T.Type?{
        
        if  let appName: String = Bundle.main.infoDictionary!["CFBundleName"] as? String{
            
            if let appClass = NSClassFromString("\(appName).\(self)") {
                return appClass as? T.Type;
            }
            return nil;
            
        }
        return nil;
        
    }
    
    /// 获得参数
    var toUrlParams:[String:String]{
        get{
            var params = [String:String]()
            let url = URL(string: self);
            if let url = url, let paramstring = url.query{
                paramstring.split(separator: "&").forEach { (index) in
                    let tmp =  index.split(separator: "=")
                    if(tmp.count > 1){
                        params[String(tmp[0])] = String(tmp[1])
                    }
                }
            }
            return params;
        }
    }
    /// 获得host
    var toUrlHost:String {
        get{
            let url = URL(string: self);
            var host = "";
            if let url = url, let hoststr = url.host{
                host = hoststr;
            }
            return host;
        }
    }
    
}
