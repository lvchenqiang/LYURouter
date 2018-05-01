//
//  ViewController.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/25.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white;
        self.title = "ViewController";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         LYURouter.open(vcClassName: "RouterViewController");
    }
  

    
}


extension ViewController:LYURouterDelegate
{
    func routerToStart(_ options: LYURouterOptions) {
        debugPrint("开始加载-----\(options) -----参数\(options.defaultParams)")
    }
    
    func routerToFinish(_ options: LYURouterOptions) {
         debugPrint("加载完成-----\(options)----参数\(options.defaultParams)")
    }
    
}

