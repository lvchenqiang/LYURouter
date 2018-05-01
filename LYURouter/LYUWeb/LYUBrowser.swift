//
//  LYUBrowser.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/5/1.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit
import WebKit
class LYUBrowser: NSObject {
  /// 初始化webview
    var webView:WKWebView {
        get{
            
            return WKWebView(frame: CGRect.zero);
        }
    }
}
