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
//        LYURouter.open(uri: "LYURouter://ViewController.bundle?index=123&params=3434&\(LYURouter.shareRouter.routerHandle.lyu_ModuleTypeKey)=Viewcontroller")
//        LYURouter.open(uri: "https://itunes.apple.com/cn/app/id1176775033?mt=8");
 
        LYURouter.open(vcClassName: "ViewController");
//        LYURouter.open(uri: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1525348171356&di=48d92da12cc4263635fafe57e3c9e529&imgtype=0&src=http%3A%2F%2Fimg1.3lian.com%2F2015%2Fa1%2F95%2Fd%2F148.jpg")
    }
 

}
extension RouterViewController : LYURouterDelegate
{
    func routerToFinish(_ options: LYURouterOptions)
    {
        debugPrint("ViewController111111-----routerToFinish");
    }
    
}
