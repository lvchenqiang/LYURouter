//
//  LYURouter.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/25.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import Foundation
import UIKit






class LYURouter: NSObject {
    
     var modules:NSSet = NSSet();
    /// keywindow的rootVC的初始化方式
    var windowRootVCStyle = LYURouterWindowRootVCStyle.Custom;
    var navigationController:UINavigationController? {
        get{
            let rootVC = UIApplication.shared.keyWindow?.rootViewController;
            if let rootVC = rootVC{
                if rootVC is UITabBarController ,let vc = (rootVC as! UITabBarController).selectedViewController
                {
                    return vc as? UINavigationController;
                }else{
                    return rootVC as? UINavigationController;
                }
            }
            return nil;
        }
    }
    
    
    /// 路由准备跳转动作
     var routeStartAction:((LYURouterOptions,String) -> (LYURouterOptions))?
    
    
    /// 对象共享一个操作的实例
    static var shareRouter:LYURouter = {
        let router = LYURouter();
        
        return router;
    }()
    
    
    // MARK:本地原生打开方式
    
    /// 通过类名 打开页面
    ///
    /// - Parameters:
    ///   - vcClassName: 类名
    ///   - options: 配置信息
    ///   - handle:  处理回调
    class func open(vcClassName:String, options:LYURouterOptions = LYURouterOptions.options() ,complete:(() -> ())? = nil)
    {
        if(vcClassName.count == 0){
            debugPrint("vcClassName is illegal");
            return;
        }
        
        /// 转换to UIViewController
        if let type = vcClassName.convertToClass( UIViewController.self){
            
            if(type.routerBelongToTabbar()){ /// 属于tabbarvc
                LYURouterHandle.switchTab(vcClassName: vcClassName, options: options);
            }else{ /// 不是tabbar数组元素
                let vc =  self.config(vcClassName: vcClassName, options: options);
                if !self.routerViewController(vc: vc, options: options){
                    debugPrint("应用调转失败")
                    return ;
                }
            }
        }
        
        
        /// 触发回调的工作
        if(complete != nil){
            complete!();
        }

       
        
    }
    
    
    /// 通过该类 打开页面
    ///
    /// - Parameters:
    ///   - vc: 类对象
    ///   - options: 配置信息
    class func open(vc:UIViewController, options:LYURouterOptions = LYURouterOptions.options()){
        
       let _ = self.routerViewController(vc: vc, options: options);
    }
    
    

    // MARK:通过　uri 打开页面
    class func open(uri:String, extra:NSDictionary = NSDictionary(), complete:(() -> (Any))? = nil){
        if(uri.count == 0){
            debugPrint("uri 不合法");
            return ;
        }
//        var uri = uri.addingPercentEncoding(withAllowedCharacters: <#T##CharacterSet#>)
        
        let url = URL(string: uri)!;
        let scheme = url.scheme!;
        if(!LYURouterHandle.urlSchemes.contains(scheme)){ /// 不包含此协议  不能跳转
            debugPrint("协议不支持 该类型跳转");
            return ;
        }
        
        /// 校验url
        if(!LYURouterHandle.safeValidateURL(url: uri)){ /// 校验uri是否合法
            debugPrint("uri 校验未通过")
            return ;
        }
        
        switch scheme {
        case "http","https":
            break;
            
        case "file":
            break;
        case "itms-apps":
            break;
        case "router":
            break;
        default:
            break;
        }
        
        
    }

    
    
    
    // MARK:通过浏览器跳转到相关的url或者唤醒相关的app (处理一些自定义协议 或者)
    class func openExternal(targetURL:NSURL){
        
    }
    
    // MARK: 使用targetVC替换navigattionController当前的viewController
    class func replaceCurrentVC(targetVC:UIViewController , step:NSInteger = 0){
        
        
    }
    
    // MARK:回退到指定的vc 指定vc或者 moduleID 优先使用vc
    class func pop(to vc:UIViewController, animated:Bool = false){
        
    }
    
    // MARK:通过moduleID 返回指定的vc
    class func pop(moduleID:String, params:NSDictionary = NSDictionary(), complete:(() -> (Any))? = nil)
    {
        
    }
    
    // MARK:通过step 返回到指定页面
    class func pop(step:NSInteger, params:NSDictionary = NSDictionary(), animated:Bool = false){
        
    }
    
    // MARK:pop 或者dismiss 单级回退
    class func pop(animated:Bool = false, params:NSDictionary = NSDictionary(), complete:(() -> (Any))? = nil)
    {
        
    }
    
    
     // MARK:配置路由信息
    class func configRouterFiles(routerFileNames:[String]){
        
    }
    
    // MARK:更新路由配置信息
    class func updateRouterInfo(filePath:String){
        
    }
    
    
    
}


// MARK: LYURouter 的工具方法
extension LYURouter
{
    // MARK:配置vc
  fileprivate  class func config(vcClassName:String, options:LYURouterOptions) -> UIViewController
    {
        if let type = vcClassName.convertToClass( UIViewController.self){
            let vc =  type.routerInstanceViewController();
//            vc.setValue(options.moduleID, forKey: LYURouterHandle.LYURouterModuleIDKey);
            return vc;
        }
        return ViewController();
    }
    // MARK:根据相关的options配置，进行跳转
    
    /// 根据相关的options配置，进行跳转
    ///
    /// - Parameters:
    ///   - vc: 对象
    ///   - options: 参数
    /// - Returns: 是否可以跳转
    fileprivate class func routerViewController(vc:UIViewController, options:LYURouterOptions) -> Bool
    {
      
        /// 是否有权限打开此页面
        if(!type(of: vc).routerCheckAccessOpen(options: options)){
            type(of: vc).routerHandleNoAccessToOpen(options: options);
            return false;
        }
        /// 校验控制器类型
        if(LYURouter.shareRouter.navigationController == nil){
            return false;
        }
        /// 路由消失
        if(LYURouter.shareRouter.navigationController!.presentationController != nil){
            LYURouter.shareRouter.navigationController!.dismiss(animated: false, completion: nil);
        }
        
        /// 路由开始加载
        var options = options;
        options = LYURouterHandle.routerStartAction(vc: vc, options: options);

        if(options.transformStyle == .Other){
            options.transformStyle = vc.routerTransformStyle;
        }
      
        switch options.transformStyle {
        case .Push:
           return self._openWithPushStyle(vc: vc, options: options);
        case .Present:
           return self._openWithPresentStyle(vc: vc, options: options);
        case .Other:
           return self._openWithOtherStyle(vc: vc, options: options);
        default :
            break;
        }
        return false;
        
    }
    
    
    // MARK:通过push打开UI
    fileprivate class func _openWithPushStyle(vc:UIViewController, options:LYURouterOptions) -> Bool{
        
        if(options.createStyle == .New){ /// 默认方式
           
            LYURouter.shareRouter.navigationController?.pushViewController(vc, animated: options.animated);
        }else if(options.createStyle == .Replace){ ///替换
            let index : Int = LYURouter.shareRouter.navigationController!.viewControllers.count;
            LYURouter.shareRouter.navigationController!.viewControllers[index-1] = vc;
        }else if(options.createStyle == .Refresh){ ///刷新
            let currentVC = LYURouter.shareRouter.navigationController!.topViewController;
            
            if let currentVC = currentVC, currentVC.isKind(of: type(of: vc)){
                currentVC.routerReferesh(options: options);
            }
        }
        
        return true;
    }
    
    // MARK:通过present打开UI
    fileprivate  class func _openWithPresentStyle(vc:UIViewController, options:LYURouterOptions) -> Bool{
        LYURouter.shareRouter.navigationController?.present(vc, animated: false, completion: nil);
        return true;
    }
    // MARK:通过自定义方式打开
    fileprivate class func _openWithOtherStyle(vc:UIViewController, options:LYURouterOptions) -> Bool{
    
        vc.routerTransformNavigation(nvc: LYURouter.shareRouter.navigationController!);
        return true;
    }
    
   
}


extension LYURouter
{
    
 
    
    
}



