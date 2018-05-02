//
//  RouterViewController.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/28.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit

class RouterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red;
        self.title = "RouterViewController"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//         LYURouter.open(vcClassName: "TabbarOneVC");
//        LYURouter.replaceCurrentVC(targetVC: TestViewController());
        LYURouter.open(uri: "LYURouter://ViewController.bundle?index=123&params=3434&\(LYURouter.shareRouter.routerHandle.lyu_ModuleTypeKey)=Viewcontroller")
    }
 

}
extension RouterViewController : LYURouterDelegate
{
    func routerToFinish(_ options: LYURouterOptions)
    {
        debugPrint("ViewController111111-----routerToFinish");
    }
    
}
