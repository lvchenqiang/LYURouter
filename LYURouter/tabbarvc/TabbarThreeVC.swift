//
//  TabbarThreeVC.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/28.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit

class TabbarThreeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title  = self.lyu_mundleID;
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:tabbar对应的索引
    override class func routerTabIndex() -> NSInteger {
        return 2;
    }
    
    // MARK:是否属于tabbar
    override class func routerBelongToTabbar() -> Bool {
        
        return true;
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
