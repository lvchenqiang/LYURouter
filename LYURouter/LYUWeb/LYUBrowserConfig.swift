//
//  LYUBrowserConfig.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/5/1.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit
import WebKit

class LYUBrowserConfig: NSObject, WKScriptMessageHandler {
    
    /// 请求的超时时间
    var requestTimeout:Double = 3.0;
    
 
    /// 默认的缓存策略
    var cachePolicy:NSURLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData;
    
    
    
    private(set) var contentController = WKUserContentController();
    private(set) var webConfig = WKWebViewConfiguration();
    /// 存储方法表
    private(set) var selectorMap = [String:Selector]();
    /// 存储调用对象的方法表
    private(set) var handlerMap = [String:NSObject]();
    
    

    
    // MARK:便利构造方法
    class func config() -> LYUBrowserConfig{
        let config = LYUBrowserConfig();
        return config;
    }
    
    override init() {
        super.init();
        /// 初始化数据
        self.requestTimeout = 10.0;
        
        /// 初始化对象
         /// 允许视频嵌入播放  不进入默认的全频播放模式
        self.webConfig.allowsInlineMediaPlayback = true;
        
        if #available(iOS 9.0, *) {
            self.webConfig.allowsAirPlayForMediaPlayback = true
        } else {
            // Fallback on earlier versions
        };
        
        self.webConfig.userContentController = self.contentController;

    }
    

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        let methodName = message.name;
        if(self.selectorMap.keys.contains(methodName) && self.handlerMap.keys.contains(methodName)){
            self.handlerMap[methodName]!.perform(self.selectorMap[methodName]!, with: message.body);
        }
        
        
    }
    
    // MARK:修改config
    func setConfig(config:WKWebViewConfiguration){
        self.webConfig = config;
    }
    
    
}


// MARK: 对象方法
extension LYUBrowserConfig
{
    // MARK:添加脚本
    func addScript(script:WKUserScript){
        self.contentController.addUserScript(script);
    }
    
    
    // MARK:添加js string
    func addJS(js:String){
        if(js.count != 0){
            let script = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true);
            self.addScript(script: script);
        }
        
    }
    
    // MARK:清除全部的脚本
    func clearScripts(){
        self.contentController.removeAllUserScripts();
    }
    
    // MARK:添加本地的方法
    func addJSMethod(method:String, sel:Selector, handler:NSObject){
        
        if(method.count != 0 && !self.selectorMap.keys.contains(method)){
           /// 添加脚本
            self.selectorMap[method] = sel;
            self.handlerMap[method] = handler;
            /// 解除强引用
            self.contentController.add(LYUScriptMessageHandler(scriptDelegate: self), name: method);
        }
 
    }
    
    
    // MARK:删除本地的方法
    func removeJSMethod(method:String){
        self.selectorMap.removeValue(forKey: method)
        self.handlerMap.removeValue(forKey: method)
        self.contentController.removeScriptMessageHandler(forName: method);
    }
    
    // MARK:清除注入的所有的本地js方法
    func clearJSMethods(){
        
        for method in self.selectorMap.keys
        {
             self.contentController.removeScriptMessageHandler(forName: method);
        }
        self.selectorMap.removeAll();
        self.handlerMap.removeAll();
    }
    
    func disableUserSelectEvent(){
        self.addJS(js: "document.documentElement.style.webkitUserSelect='none';")
    }
    
    func disableUserPressEvent(){
        self.addJS(js: "document.documentElement.style.webkitTouchCallout='none';")
    }
    
    
    
}


// MARK:缓存相关设置
extension LYUBrowserConfig{
 
    // MARK:清除缓存
    
    ///  清除缓存
    class func clearCache(){
        URLCache.shared.removeAllCachedResponses()
    }
 
    // MARK:清除cookie
    /// 清除cookie
    class func clearCookies(){
        if let cookies = HTTPCookieStorage.shared.cookies{
              for cookie in cookies
              {
                HTTPCookieStorage.shared.deleteCookie(cookie);
            }
        }
    }
    
    
}


class LYUScriptMessageHandler:NSObject,WKScriptMessageHandler{
    
       // MARK:- 弱引用 解决循环引用问题
        weak  var scriptDelegate:WKScriptMessageHandler?
    
       /// 初始化操作
        init(scriptDelegate:WKScriptMessageHandler) {
            self.scriptDelegate = scriptDelegate;
        }
    
      func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        self.scriptDelegate?.userContentController(userContentController, didReceive: message);
    }
    
}

