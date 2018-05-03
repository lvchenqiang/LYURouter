//
//  LYUBrowser.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/5/1.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit
import WebKit



// MARK:LYUBrowserDelegate 代理事件
 @objc protocol LYUBrowserDelegate:NSObjectProtocol {
    
    ///在请求发送前决定是否加载
    @objc optional func browsershouldLoadWithRequest(_ browser:LYUBrowser, request:URLRequest) -> Bool;
    
    ///开始加载
    @objc optional  func browserDidStartLoading(_ browser:LYUBrowser)
    
    ///内容开始返回
    @objc optional func browserDidCommitLoading(_ browser:LYUBrowser)
    
    ///完成加载
    @objc optional func browserDidFinishLoading(_ browser:LYUBrowser)
    
    ///加载失败
    @objc optional func browserDidFailLoading(_ browser:LYUBrowser)
    
    
    ///在收到响应时决定是否加载
    @objc optional func browsershouldLoadWithResponse(_ browser:LYUBrowser, response:URLResponse) -> Bool;
    
    /// 标题改变
    @objc optional func browserDidChangePageTitle(_ browser:LYUBrowser)
    
    
}

class LYUBrowser: UIView {
  
    /// 初始化webview
    private(set)   var webView:WKWebView = {
        let webView = WKWebView();
        return webView;
    }()
    
    /// 初始化配置
    private(set)  var config:LYUBrowserConfig =  {
        let config = LYUBrowserConfig.config();
        return config;
    }()
    /// 页面的标题
    private(set)   var pageTitle:String = ""
    
    private(set)   var currentURL:String = ""
    
    /// 代理
    weak var delegate:LYUBrowserDelegate?
    
    fileprivate var ob_estimatedProgress:NSKeyValueObservation?
    fileprivate var ob_title : NSKeyValueObservation?
    // MARK:构造方法
    class func browser(frame:CGRect, config:WKWebViewConfiguration? = nil) -> LYUBrowser{
    return LYUBrowser(frame: frame, webConfig: config, browserConfig: nil);
    }
    
    // MARK:构造方法
    class func browser(frame:CGRect, config:LYUBrowserConfig? = nil) -> LYUBrowser{
        return LYUBrowser(frame: frame, webConfig: nil, browserConfig: config);
    }
    
     init(frame: CGRect, webConfig:WKWebViewConfiguration? = nil, browserConfig:LYUBrowserConfig? = nil) {
        super.init(frame: frame);
        /// 初始化数据
        
        if(webConfig != nil){
            self.webView = WKWebView(frame: frame, configuration: webConfig!);
            self.config.setConfig(config: webConfig!)
        }else{
            self.webView = WKWebView(frame: frame);
        }
        self.backgroundColor = UIColor.white;
        
        
        if(browserConfig != nil){
            self.webView = WKWebView(frame: frame, configuration: browserConfig!.webConfig);
            self.config = browserConfig!
        }else{
            self.webView = WKWebView(frame: frame);
        }
        
        self.webView.backgroundColor = .clear;
        self.webView.allowsBackForwardNavigationGestures = true;
        self.webView.uiDelegate = self;
        self.webView.navigationDelegate = self;
        self.addSubview(self.webView);
        /// 注册KVO
       
        self.ob_estimatedProgress =   self.webView.observe(\.estimatedProgress) { (webview, value) in
            
             debugPrint(self.webView.estimatedProgress);
        }
        
        self.ob_title =   self.webView.observe(\.title) { (webview, value) in
            
            debugPrint(value);
        }
        
        
    }
    
    override func sizeToFit() {
        super.sizeToFit();
        self.webView.sizeToFit();
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.ob_estimatedProgress = nil;
        self.ob_title = nil;
    }
 
    
}

// MARK:对外暴露的方法
extension LYUBrowser{
    /// 加载url
    func loadURL(url:String){
        self.currentURL = url;
        let request = URLRequest(url: URL(string: url)!, cachePolicy: self.config.cachePolicy, timeoutInterval: self.config.requestTimeout);
        debugPrint(request)
        self.webView.load(request);
    }
    
    /// 刷新页面
    func reload(){
        if(self.webView.isLoading){
            self.webView.stopLoading();
        }
        self.webView.reload()
    }
    
    //重新加载(优先加载缓存)
    func reloadFromOrigin(){
        if(self.webView.isLoading){
            self.webView.stopLoading();
        }
        
        self.webView.reloadFromOrigin();
    }
    
    /// 更新url
    func updateURL(){
        if(self.webView.isLoading){
            self.webView.stopLoading();
        }
        self.loadURL(url: self.currentURL)
    }
    
    /// 加载空白页
    func loadBlank(){
        self.loadURL(url: "about:blank")
    }
    
    /// 加载本地资源
    func loadFile(path:String){
        if #available(iOS 9.0, *) {
            self.webView.loadFileURL(URL(fileURLWithPath: path), allowingReadAccessTo: URL(fileURLWithPath: path))
        } else {
            // Fallback on earlier versions
            
        };
    }
    
    /// 加载html的文本内容
    func loadHTML(html:String, baseURL:URL? = nil){
        self.webView.loadHTMLString(html, baseURL: baseURL);
    }
    
  
    /// 回到初始页
    func goBackToFirstPage(){
        self.loadBlank();
        if  let item = self.webView.backForwardList.forwardList.first{
            self.webView.go(to: item);
        }
    }
    
    
    /// 本地调用js方法
    func evalJavaScript(javaScriptString:String, completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
        self.webView.evaluateJavaScript(javaScriptString, completionHandler: completionHandler);
    }
    
    /// 获取Document下的elementId标签下的attr
    func getAtrribute(attr:String, elementId:String, completionHandler:((Any?, Error?) -> Swift.Void)? = nil){
        self.evalJavaScript(javaScriptString: "document.getElementById(\"\(elementId)\").\(attr)", completionHandler: completionHandler);
    }
    
    /// 底部插入空白区
    func insertBottom(height:Double){
        self.evalJavaScript(javaScriptString: "var div=document.createElement(\"div\");div.style.width=document.body.clientWidth;div.style.height=\"\(height)px\";document.body.appendChild(div);")
    }
    
    
    /// 头部插入空白区
    func insertTop(height:Double){
        self.evalJavaScript(javaScriptString: "var div=document.createElement(\"div\");div.style.width=document.body.clientWidth;div.style.height=\"\(height)px\";document.body.insertBefore(div,first);")
    }
    
}

// MARK:WKWebView的代理事件  以及KVO事件
extension LYUBrowser : WKNavigationDelegate {
    
    /// (1)  在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        var decide = true;
        /// 决定是否跳转 https://itunes.apple.com/cn/app/id1176775033?mt=8
        if let targetUrl =  navigationAction.request.url, let host = targetUrl.host{
            if(host.hasPrefix("itunes.apple.com")){
                UIApplication.shared.openURL(targetUrl);
                decide = false;
            }
        }
        self.currentURL = navigationAction.request.url?.absoluteString ?? "";
        if(self.delegate != nil && self.delegate!.responds(to: #selector(LYUBrowserDelegate.browsershouldLoadWithRequest(_:request:)))){
           decide = self.delegate!.browsershouldLoadWithRequest!(self,request: navigationAction.request)
        }
        if decide{
          decisionHandler(.allow);
        }else{
          decisionHandler(.cancel);
            LYURouter.pop()
        }
     
    }
    
    
    
    /// (2) 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true;
       
        
        if(self.delegate != nil && self.delegate!.responds(to:#selector(LYUBrowserDelegate.browserDidStartLoading(_:)))){
            self.delegate!.browserDidStartLoading!(self);
        }
        
        
        
    }
    
    /// (3) 在收到服务器的响应头，根据response相关信息，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
         var decide = true;
        if(self.delegate != nil && self.delegate!.responds(to: #selector(LYUBrowserDelegate.browsershouldLoadWithResponse(_:response:)))){
            decide = self.delegate!.browsershouldLoadWithResponse!(self, response: navigationResponse.response);
        }
        
        if decide{
            decisionHandler(.allow);
        }else{
            decisionHandler(.cancel);
        }

    }

    /// (4) 当内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        if(self.delegate != nil && self.delegate!.responds(to: #selector(LYUBrowserDelegate.browserDidCommitLoading(_:)))){
            self.delegate?.browserDidCommitLoading!(self);
        }
        
        
    }
    
    /// (5) 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if(self.delegate != nil && self.delegate!.responds(to: #selector(LYUBrowserDelegate.browserDidFinishLoading(_:)))){
            self.delegate?.browserDidFinishLoading!(self);
        }
    }
    
    /// //页面加载失败时调用
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if(self.delegate != nil && self.delegate!.responds(to: #selector(LYUBrowserDelegate.browserDidFailLoading(_:)))){
            self.delegate?.browserDidFailLoading!(self);
        }
    }
    
    // MARK:身份验证
//    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
//
//    }
    
    // MARK:导航错误
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//
//    }
    
}

extension LYUBrowser:WKUIDelegate{
    
    // MARK:警告框 alert()方法
    //    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
    //
    //    }
    
    // MARK:输入框 TextInput
    //     func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
    //
    //    }
    
    // MARK: 确认框 confirm()方法
    //    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
    //
    //    }\
    

}
