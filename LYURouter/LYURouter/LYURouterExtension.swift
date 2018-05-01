//
//  LYURouterExtension.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/25.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import Foundation
import UIKit


/// VC的转场等个
///
/// - Normal///默认的风格
/// - Push///系统push风格
/// - Present///系统Present风格
/// - Custom///自定义风格
enum LYURouterTransformStyle {
    case Normal
    case Push   /// 系统push风格
    case Present /// 系统Present风格
    case Other  /// 自定义风格
}


/// RootViewController的风格
///
/// - Norml: 常规（NVC）
/// - Custom: (TabbarVC)
enum LYURouterWindowRootVCStyle {
    case Norml
    case Custom
}

/// ViewController创建的方式
///
/// - New: 默认 直接 new 一个对象
/// - Replace: 替换对象
/// - Refresh: 已存在直接刷新
enum LYURouterCreateStyle {
    case New
    case Replace
    case Refresh
}

class LYURouterOptions: NSObject {
    /// 跳转是否有动画
    var animated:Bool = false;
    
    ///  每个页面所对应的moduleID
    var moduleID:String {
        get {
            return "";
        }
    }
    ///  跳转时传入的参数，默认为空
    var defaultParams:[String:AnyHashable] = [String:AnyHashable]();
    
    var transformStyle = LYURouterTransformStyle.Push;
    var createStyle = LYURouterCreateStyle.New;
    
    /// 跳转模式
    var fromurlscheme:String = "";
    var tourlscheme:String = "";
    /// 创建单独配置的options对象
    ///
    /// - Parameter params: 参数传递
    /// - Returns: options对象
    class func options(params:[String:AnyHashable] = [String:AnyHashable]() ) -> LYURouterOptions{
        let option = self.init()
        option.defaultParams = params;
        return option;
    }
   
}



class LYURouterHandle: NSObject {
    
    
    
    /// app支持的url协议组成的数组
    static var urlSchemes:[String] {
        get{
            return ["http","https","file","itms-apps","router"];
        }
    }
    
    
    /// 模块的类型名字的可以，用来解析模块的类型
    static var LYUModuleTypeKey:String {
        get{
            return "ViewController";
        }
    }
    
    ///  沙盒基础路径，该目录下用于保存后台下发的路由配置信息，以及h5模块文件
    static var sandBoxBasePath:String {
        get{
           return NSHomeDirectory();
        }
    }
    
    
    /// 用来解析moduleID的key
    static var LYURouterModuleIDKey:String
    {
        get{
            return "LYUModuleIDKey"
        }
    }
    
    
    ///  在url参数后设置 LYURouterHttpOpenStyleKey=1 时通过appweb容器打开网页，其余情况通过safari打开网页
    static var LYURouterHttpOpenStyleKey:String{
        get{
         return "LYURouterAppOpenKey";
        }
    }
    
    
    /// 对传入的url进行校验
    ///
    /// - Parameter url: url
    /// - Returns: 是否合法
    class func safeValidateURL(url:String) -> Bool
    {
        return true;
    }
    
    
    ///  配置web容器从外部获取url的property的字段名
    ///
    /// - Returns: property的字段名
    static var LYUWebURLKey:String = {
        return "";
    }()
    
    
    ///  配置webVC的className，使用的时候可以通过category重写方法配置
    ///
    /// - Returns: webVC的className
    static var LYUWebVCClassName:String = {
        return "";
    }()
    
    
    
    /// 除了路由跳转以外的操作
    ///
    /// - Parameters:
    ///   - actionType: 操作的类型 viewcontroller view
    ///   - url: url
    ///   - extra: 额外传入的参数
    ///   - completeBlock: 操作成功后的回调
    class func otherActions(actionType:String, url:URL, extra:NSDictionary, completeBlock:@escaping () -> Void)
    {
        
        
    }
    

    
    ///  解析JSON文件 获取到所有的Modules
    ///
    /// - Parameter file: 文件名
    class func getModulesFromJsonFile(files:[String]) -> [String]{
      
        
        return [""];
    }
    
    
        // MARK:路由开始
     class func routerStartAction(vc:UIViewController,options:LYURouterOptions) -> LYURouterOptions{
        var options = options;
        if(LYURouter.shareRouter.routeStartAction != nil){
            options =  LYURouter.shareRouter.routeStartAction!(options,NSStringFromClass(type(of: vc)));
        }
        
      
        return options;
    }
    
    // MARK:路由结束
     class func routerFinishAction(vc:UIViewController,options:LYURouterOptions){
        /// 触发代理的操作
      
        
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

