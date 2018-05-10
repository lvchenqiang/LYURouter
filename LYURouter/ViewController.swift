//
//  ViewController.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/4/25.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
    
  
    let linearProgressBar = LYULinearProgressBar(frame: CGRect(x: 10, y: 100, width: 100, height: 30));
    let slider = UISlider(frame: CGRect(x: 10, y: 300, width: 100, height: 10));
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = .white;
        self.title = "ViewController";
        linearProgressBar.progressValue = 10;
        linearProgressBar.barColor = UIColor.red
        linearProgressBar.foregroundColor = UIColor.green
        linearProgressBar.lineCapStyle = .square
        self.view.addSubview(linearProgressBar);
        self.view.addSubview(self.slider);
        self.slider.addTarget(self, action: #selector(slidervalue), for: .valueChanged);
        slider.maximumValue = 100;
        slider.minimumValue = 0;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func slidervalue(_ sender: UISlider) {
        
//        self.linearProgressBar.barColorForValue = { value in
//            switch value {
//            case 0..<20:
//                return UIColor.red
//            case 20..<60:
//                return UIColor.orange
//            case 60..<80:
//                return UIColor.yellow
//            default:
//                return UIColor.green
//            }
//        }
        debugPrint(sender.value)
        // refresh
        linearProgressBar.progressValue = CGFloat(sender.value)
  
        
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         LYURouter.open(vcClassName: "RouterViewController");
        
    }
  
    // MARK:初始化方法
//     override class func routerInstanceViewController() -> UIViewController
//    {
//        let vc = ViewController(nibName: "ViewController", bundle: nil)
//
//        return vc;
//    }
    
    
    
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

