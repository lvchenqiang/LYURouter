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
    
    var modules:[[String:AnyHashable]] {
        get{
            var results = [[String:AnyHashable]]();
            for file in LYURouter.shareRouter.routerFileNames
            {
                let path = Bundle.main.path(forResource: file, ofType: nil);
                if  let data = try? Data(contentsOf: URL(fileURLWithPath: path!)){
                    if let result = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers){
                        results.append(contentsOf: result as! [[String:AnyHashable]])
                    }
                }
            }
            
            return results;
        }
    }
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
    
    
    /// 处理路由的handle信息
    var routerHandle:LYURouterHandleDelegate = LYURouterHandle();
    
    
    ///  存储加载的配置文件
    fileprivate var routerFileNames:[String] = [String]();
    
    
    ///  加载服务器下发的配置文件
    fileprivate var remoteFilePath:String = "";
    
    
    /// 对象共享一个操作的实例
    static var shareRouter:LYURouter = {
        let router = LYURouter();
        /// 初始化挂钩函数
        hookPushVC();
        hookPopVC()
        return router;
    }()
    
    // MARK:注册一个handle 自定义处理相关机制
    func register(handle:LYURouterHandleDelegate){
        LYURouter.shareRouter.routerHandle = handle;
    }
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
                self.switchTab(vcClassName: vcClassName, options: options);
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
    class func open(uri:String, extra:[String:AnyHashable] = [String:AnyHashable]() , complete:(() -> (Any))? = nil){
        debugPrint(uri);
        if(uri.count == 0){
            debugPrint("uri 不合法");
            return ;
        }
        //NSCharacterSet(charactersInString:"`#%^{}\"[]|\\<> ")
//        let uri = uri.addingPercentEncoding(withAllowedCharacters:CharacterSet.init(charactersIn: "`#%^{}\"[]|\\<> "))!
         let url = URL(string: uri)!;
        guard  let scheme = url.scheme  else {
            return;
        }
       
        if(!LYURouter.shareRouter.routerHandle.lyu_UrlSchemes.contains(scheme)){ /// 不包含此协议  不能跳转
            debugPrint("协议不支持 该类型跳转");
            return ;
        }
        
        /// 校验url
        if(!LYURouter.shareRouter.routerHandle.lyu_SafeValidateURL(url: uri)){ /// 校验uri是否合法
            debugPrint("uri 校验未通过")
            return ;
        }
        
        switch scheme {
        case "http","https":
            self.httpOpen(uri: url, extra: extra);
            return;
        case "file":
            self.localOpen(uri: uri, extra: extra);
            return;
        case "itms-apps":
            self.openExternal(targetURL: url);
            return;
//        case "router":
//            /// 自定义打开本地页面
//            let params = uri.toUrlParams;
//            let target = uri.toUrlHost;
//            self.open(vcClassName: target, options: LYURouterOptions.options(params: params), complete: nil);
//
//            break;
        default:
            break;
        }
        
       
        let params = uri.toUrlParams;
        /// 模块的类型  查询本地是否支持打开此页面 host关联到mundleID
        let mundleID = uri.toUrlHost;
        /// 检查本地的配置信息
        var targetType = "";
        var vcClassName = "";
        LYURouter.shareRouter.modules.forEach { (params) in
            if((params["moduleID"] as! String) == mundleID){
                targetType = params["type"] as! String
                vcClassName = params["targetVC"] as! String
            }
        }
        
        if targetType == LYURouter.shareRouter.routerHandle.lyu_ModuleTypeKey{ /// 打开本地的页面
            self.open(vcClassName: vcClassName, options: LYURouterOptions.options(params: params), complete: nil);
            
        }else if targetType == "H5" {
            var tmpparams = [String:AnyHashable]();
            tmpparams[LYURouter.shareRouter.routerHandle.lyu_WebURLKey] = uri;
            extra.forEach { (key,value) in
                tmpparams[key] = value;
            }
            self.open(vcClassName: LYURouter.shareRouter.routerHandle.lyu_WebVCClassName, options: LYURouterOptions.options(params:tmpparams), complete: nil);
        }else{
            LYURouter.shareRouter.routerHandle.lyu_OtherActions(actionType: targetType, url: url, extra: extra, completeBlock: nil);
        }
        
        
        
        
        
        
        
        
    }

    
    
    
    // MARK:通过浏览器跳转到相关的url或者唤醒相关的app (处理一些自定义协议 或者)
    class func openExternal(targetURL:URL){
        
        if(targetURL.scheme == "http" || targetURL.scheme == "https"  || targetURL.scheme == "itms-apps" ){
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(targetURL, options: ["key":"value"], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(targetURL);
            };
        }
    }
    
    // MARK: 使用targetVC替换navigattionController当前的viewController
    class func replaceCurrentVC(targetVC:UIViewController , step:NSInteger = -1){
             let  vcArray = LYURouter.shareRouter.navigationController?.viewControllers;
     
        if let vcArray = vcArray{
            var step = step;
            if step < 0 || step > vcArray.count{
                step = vcArray.count - 1;
            }
            LYURouter.shareRouter.navigationController?.viewControllers[step] = targetVC;
        }else {
            UIApplication.shared.keyWindow?.rootViewController = targetVC;
        }
        
    }
    
    // MARK:回退到指定的vc 指定vc或者 moduleID 优先使用vc
    class func pop(to vc:UIViewController, animated:Bool = false , options:LYURouterOptions = LYURouterOptions.options()){
        
        /// 配置vc的信息
        self.configVC(vc: vc, options: options,forward: false);
        if(LYURouter.shareRouter.navigationController?.presentedViewController != nil){
  LYURouter.shareRouter.navigationController?.presentedViewController?.dismiss(animated: false, completion: nil);
        }else{
            LYURouter.shareRouter.navigationController?.popToViewController(vc, animated: false);
    }
    }
    
    // MARK:通过moduleID 返回指定的vc
    class func pop(moduleID:String, params:[String:AnyHashable] = [String:AnyHashable](), complete:(() -> (Any))? = nil)
    {
        let  vcArray = LYURouter.shareRouter.navigationController?.viewControllers;
        if  let  vcArray  = vcArray
        {
            for vc in vcArray{
                if(vc.lyu_mundleID == moduleID){
                    self.configVC(vc: vc, options: LYURouterOptions.options(params: params), forward: false);
                    self.pop(to: vc, animated: false, options: LYURouterOptions.options(params: params));
                    break;
                }
            }
        }
      
    }
    
    // MARK:通过step 返回到指定页面
    class func pop(step:NSInteger, params:[String:AnyHashable] = [String:AnyHashable](), animated:Bool = false){
        
        let  vcArray = LYURouter.shareRouter.navigationController?.viewControllers;
        if  let  vcArray  = vcArray, vcArray.count >= step
        {
            let index = (vcArray.count - 1 - step) > 0 ? (vcArray.count - 1 - step) : 0 ;
            let vc = vcArray[index];
            self.configVC(vc: vc, options: LYURouterOptions.options(params: params), forward: false);
            self.pop(to: vc, animated: animated, options: LYURouterOptions.options(params: params));
        }else{
            self.pop(to: LYURouter.shareRouter.navigationController!.viewControllers[0], animated: animated, options: LYURouterOptions.options(params: params));
        }
    }
    
    // MARK:pop 或者dismiss 单级回退
    class func pop(animated:Bool = false, params:[String:AnyHashable] = [String:AnyHashable](), complete:(() -> (Any))? = nil)
    {
        let  vcArray = LYURouter.shareRouter.navigationController?.viewControllers;
          if let vcArray = vcArray, vcArray.count > 0 {
            let index = vcArray.count<=1 ? 0 :  vcArray.count-2;
            let vc = vcArray[index];
            self.configVC(vc: vc, options: LYURouterOptions.options(params: params), forward: false);
            self.pop(to: vc, animated: false, options: LYURouterOptions.options(params: params));
        }
    }
    
    
     // MARK:配置路由信息
    class func configRouterFiles(routerFileNames:[String]){
        LYURouter.shareRouter.routerFileNames = routerFileNames;
        
        
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
            configVC(vc: vc, options: options, forward: true);
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
        
        /// 处理路由的回调
        if(LYURouter.shareRouter.routeStartAction != nil){
            options =  LYURouter.shareRouter.routeStartAction!(options,NSStringFromClass(type(of: vc)));
        }

        if(options.transformStyle == .Other){
            options.transformStyle = vc.routerTransformStyle;
        }
        /// 配置vc
        
      
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
    
    // MARK:-打开http页面
    fileprivate class func httpOpen(uri:URL, extra:[String:AnyHashable]){
        var params  : [String:AnyHashable] = uri.absoluteString.toUrlParams;
        extra.forEach { (key,value) in
            params[key] = value;
        }
        params[LYURouter.shareRouter.routerHandle.lyu_WebURLKey] = uri.absoluteString;
        self.open(vcClassName: LYURouter.shareRouter.routerHandle.lyu_WebVCClassName, options: LYURouterOptions.options(params: params), complete: nil);
        
    }
   
    // MARK:- 打开本地页面
    fileprivate class func localOpen(uri:String, extra:[String:AnyHashable]){
        
        let filepath = "://" +  LYURouter.shareRouter.routerHandle.lyu_SandBoxBasePath + uri.replacingOccurrences(of: "://", with: "");
        var params  : [String:AnyHashable] = uri.toUrlParams;
        extra.forEach { (key,value) in
             params[key] = value;
          }
       params[LYURouter.shareRouter.routerHandle.lyu_WebURLKey] = filepath;
      self.open(vcClassName:LYURouter.shareRouter.routerHandle.lyu_WebVCClassName, options: LYURouterOptions.options(params: params), complete: nil);
 
    }
    
    
    class func switchTab(vcClassName:String, options:LYURouterOptions){
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController ;
        if(vcClassName.currentClass == nil){
            return;
        }
        
        let targetType = vcClassName.currentClass! as! UIViewController.Type
        
        if let rootVC = rootVC {
            let index = targetType.routerTabIndex();
            if(rootVC is UITabBarController){
                let tabBarVC = rootVC as! UITabBarController;
                /// 路由开始加载
                var options = options;
                /// 处理路由的回调
                if(LYURouter.shareRouter.routeStartAction != nil){
                    options =  LYURouter.shareRouter.routeStartAction!(options,NSStringFromClass(type(of: tabBarVC.viewControllers![index])));
                }
               
                self.configVC(vc: tabBarVC.selectedViewController!, options: options, forward: true);
                
                if(tabBarVC.selectedViewController is UINavigationController){
                    let nvc = tabBarVC.viewControllers![index] as! UINavigationController;
                    nvc.popToRootViewController(animated: false);
                    tabBarVC.selectedIndex = index;
                }else{
                    tabBarVC.selectedIndex = index;
                }
            }
            
        }
    }
    
}

// MARK:- 路由的代理事件
extension LYURouter
{
    
    // MARK:- configVC 触发代理事件
    fileprivate class func configVC(vc:UIViewController, options:LYURouterOptions, forward:Bool){

        vc.setValue(options.moduleID, forUndefinedKey: LYURouter.shareRouter.routerHandle.lyu_ModuleIDKey);
        if(forward){ /// 路由前进
            if(vc is LYURouterDelegate && vc.responds(to: #selector(LYURouterDelegate.routerToStart(_:)))){
                vc.perform(#selector(LYURouterDelegate.routerToStart(_:)), with: options);
            }
        }else{ /// 路由后退
            if(vc is LYURouterDelegate && vc.responds(to: #selector(LYURouterDelegate.routerToFinish(_:)))){
                vc.perform(#selector(LYURouterDelegate.routerToFinish(_:)), with: options);
            }
            
        }
    }

}

// MARK:-重载系统方法
extension LYURouter
{
  private   typealias PushVCType = @convention(c) (UIViewController, Selector, UIViewController, Bool) -> Void
   private typealias PopVCType = @convention(c) (UIViewController, Selector, Bool)->(Void)

    fileprivate class func hookPushVC(){
        let originSelector =  #selector(UINavigationController.pushViewController(_:animated:))
        let originMethod = class_getInstanceMethod(UINavigationController.self, originSelector)
        let originalIMP = unsafeBitCast(method_getImplementation(originMethod!), to: PushVCType.self);
        
        let newFunc:@convention(block) (UIViewController,UIViewController,Bool)->(Void) = {
            (fromvc,tovc,flag) in
            
            debugPrint("开始调用--PUSH----- fromvc: \(fromvc) \n tovc: \(tovc)")
            originalIMP(fromvc, originSelector, tovc, flag);
              debugPrint("开始调用--PUSH----- fromvc: \(fromvc) \n tovc: \(tovc)")
        };
        
        let imp = imp_implementationWithBlock(unsafeBitCast(newFunc, to: AnyObject.self))
        
        method_setImplementation(originMethod!, imp)
        
    }
    
    fileprivate class func  hookPopVC(){
        
        
        let originSelector =  #selector(UINavigationController.popViewController(animated:))
        let originMethod   =  class_getInstanceMethod(UINavigationController.self, originSelector)
        //
        let originalIMP = unsafeBitCast(method_getImplementation(originMethod!), to: PopVCType.self);
        
        let newFunc:@convention(block) (UIViewController, Bool)->(Void) = {
            (tovc,flag) in
            
            debugPrint("开始调用--dismiss---%@----%d----%@-",tovc,flag);
            
            originalIMP(tovc,originSelector,flag);
            
            debugPrint("开始调用--dismiss---%@----%d----%@-",tovc,flag);
            
        };
        
        let imp = imp_implementationWithBlock(unsafeBitCast(newFunc, to: AnyObject.self))
        method_setImplementation(originMethod!, imp)
        
        
    }
    
}


