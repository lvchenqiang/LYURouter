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
    case Normal /// 默认的风格
    case Push   /// 系统push风格
    case Present /// 系统Present风格
    case Custom  /// 自定义风格
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
    var moduleID:String = ""
    
    ///  跳转时传入的参数，默认为空
    var defaultParams:NSDictionary = NSDictionary();
    
    
    
    
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
            return "LYUModuleID"
        }
    }
    
    
    ///  在url参数后设置 LYURouterHttpOpenStyleKey=1 时通过appweb容器打开网页，其余情况通过safari打开网页
    static var LYURouterHttpOpenStyleKey:String{
        get{
         return "LYURouterAppOpen";
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
    class func LYUWebURLKey() -> String{
        return "";
    }
    
    
    ///  配置webVC的className，使用的时候可以通过category重写方法配置
    ///
    /// - Returns: webVC的className
    class func LYUWebVCClassName() -> String{
        return "";
    }
    
    
    
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
    
    
    class func switchTab(vcClassName:String, options:LYURouterOptions){
        
        let rootVC = UIApplication.shared.keyWindow?.rootViewController ;
        if let rootVC = rootVC{
            
            print(rootVC);
//            let index = [NSClassFromString(vcClassName) ]
            
            
            
        }
    }
    
    
    
}
