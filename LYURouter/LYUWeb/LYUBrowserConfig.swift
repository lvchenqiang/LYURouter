//
//  LYUBrowserConfig.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/5/1.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit
import WebKit

class LYUBrowserConfig: NSObject,WKScriptMessageHandler {
    
    var controller = WKUserContentController();
    var webConfig = WKWebViewConfiguration();
    
    
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


extension LYUBrowserConfig{
 
    
 
}
