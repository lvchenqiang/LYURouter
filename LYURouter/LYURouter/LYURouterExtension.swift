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




@objc protocol LYURouterHandleDelegate {
    /// app支持的url协议组成的数组
     var lyu_UrlSchemes:[String]{get}
    
    
    /// 模块的类型名字的可以，用来解析模块的类型
     var lyu_ModuleTypeKey:String {get}
    
    
    ///  沙盒基础路径，该目录下用于保存后台下发的路由配置信息，以及h5模块文件
     var lyu_SandBoxBasePath:String {get}
    
    
    /// 用来解析moduleID的key
     var lyu_ModuleIDKey:String {get}
    
    
    /// 用来区分appweb容器打开网页，其余情况通过safari打开网页  （LYURouterHttpOpenStyleKey=1）
     var lyu_HttpOpenStyleKey:String {get}
    
    
    ///  配置web容器从外部获取url的property的字段名
    ///
    /// - Returns: property的字段名
     var lyu_WebURLKey:String {get}
    
    
    
    ///  配置webVC的className，使用的时候可以通过category重写方法配置
    ///
    /// - Returns: webVC的className
     var lyu_WebVCClassName:String {get}
    
    
    /// 对传入的url进行校验
    ///
    /// - Parameter url: url
    /// - Returns: 是否合法
     func  lyu_SafeValidateURL(url:String) -> Bool;
    

    
    
    /// 处理路由不能处理的一些事件
    ///
    /// - Parameters:
    ///   - actionType: actionType
    ///   - url: url
    ///   - extra: extra
    ///   - completeBlock: completeBlock
    func lyu_OtherActions(actionType:String, url:URL, extra:[String:AnyHashable], completeBlock:(() -> Void)?);
    
   
    /// 添加前进的转场动画
    ///
    /// - Returns: CABasicAnimation
    @objc optional func lyu_transitionToForward(_ className:String) -> CAAnimation;

    /// 添加后退的转场动画
    ///
    /// - Returns: CABasicAnimation
    @objc optional func lyu_transitionToBackward(_ className:String) -> CAAnimation;
    
}

class LYURouterHandle:NSObject,LYURouterHandleDelegate {
  
    
  
    
     var lyu_UrlSchemes: [String]{
        get{
            return ["http","https","file","itms-apps","LYURouter"];
        }
    }
    
     var lyu_ModuleTypeKey: String {
        get{
         return "ViewController";
        }
    }
    
     var lyu_SandBoxBasePath: String{
        get{
            return NSHomeDirectory();
        }
    }
    
     var lyu_ModuleIDKey: String{
        get{
            return "LYUModuleIDKey"
        }
    }
    
     var lyu_HttpOpenStyleKey: String{
        get{
            return "LYURouterAppOpenKey";
        }
    }
    
     var lyu_WebURLKey: String{
        get{
            return "LYURouterWebURLKey";
        }
    }
    
     var lyu_WebVCClassName: String{
        get{
            return "LYUWebViewController"
        }
    }
    
    
    ///  沙盒基础路径，该目录下用于保存后台下发的路由配置信息，以及h5模块文件
     var sandBoxBasePath:String {
        get{
            return NSHomeDirectory();
        }
    }
    
    
    /// 用来解析moduleID的key
     var LYURouterModuleIDKey:String
    {
        get{
            return "LYUModuleIDKey"
        }
    }
    
    
    ///  在url参数后设置 LYURouterHttpOpenStyleKey=1 时通过appweb容器打开网页，其余情况通过safari打开网页
     var LYURouterHttpOpenStyleKey:String{
        get{
            return "LYURouterAppOpenKey";
        }
    }
    
    
    
     func lyu_SafeValidateURL(url: String) -> Bool {
       
        return true;
    }
    
    func lyu_OtherActions(actionType: String, url: URL, extra: [String:AnyHashable], completeBlock: (() -> Void)?) {
        debugPrint("处理路由不能处理的路由事件 在这里自定义解决");
    }
    
    func lyu_transitionToForward(_ className: String) -> CAAnimation {
        /// 创建转场动画
        let transition = CATransition();
        transition.type = "rippleEffect";
        transition.subtype = "90cww";
        transition.duration = 1.0;
        transition.beginTime = CACurrentMediaTime();//延迟时间
        /// 携带值
        return transition;
    }
    
   
    
}



