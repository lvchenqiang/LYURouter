//
//  LYUNavigationBar.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/7/12.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import Foundation
import UIKit

class LYUNavigationBar: UIView {
    static var isIphoneX:Bool = {
        var systemInfo = utsname()
        uname(&systemInfo);
        let machine = systemInfo.machine
        let mirror = Mirror(reflecting: machine)
        var identifier = ""
        for child in mirror.children {
            let value = child.value
            
            if let value = value as? Int8, value != 0 {
                identifier.append(String(UnicodeScalar(UInt8(value))))
            }
        }
        if(identifier == "i386" || identifier == "x86_64"){
            return (UIScreen.main.bounds.size.equalTo(CGSize(width: 375, height: 812)) || UIScreen.main.bounds.size.equalTo(CGSize(width: 812, height: 375)))
        }
        return (identifier == "iPhone10,3" || identifier == "iPhone10,6");
    }()
}
