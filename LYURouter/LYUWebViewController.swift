//
//  LYUWebViewController.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/5/3.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit

class LYUWebViewController: UIViewController {

    var browser:LYUBrowser = {
        let config = LYUBrowserConfig.config()
        
        let browser = LYUBrowser.browser(frame: UIScreen.main.bounds, config: config);
        browser.insertBottom(height: 100)
        return browser;
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.browser);
        self.browser.frame = self.view.bounds;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}


extension LYUWebViewController:LYURouterDelegate
{
    func routerToFinish(_ options: LYURouterOptions) {
        
    }
    
    func routerToStart(_ options: LYURouterOptions) {
        let url :String = options.defaultParams[LYURouter.shareRouter.routerHandle.lyu_WebURLKey] as? String ?? "";
        self.browser.loadURL(url: url);
    }
}
