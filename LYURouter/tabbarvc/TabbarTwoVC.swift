//
//  TabbarTwoVC.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/28.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit

class TabbarTwoVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = self.lyu_mundleID;
        self.view.backgroundColor = .yellow
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:tabbar对应的索引
    override class func routerTabIndex() -> NSInteger {
        return 1;
    }
    
    // MARK:是否属于tabbar
    override class func routerBelongToTabbar() -> Bool {
        
        return true;
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        LYURouter.open(vcClassName: "ViewController", options:LYURouterOptions.options(params: ["id":123,"name":"张三"]));
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
