//
//  UIImage+Helper.swift
//  LYUMVVMKit
//
//  Created by 吕陈强 on 2018/7/12.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import Foundation
import UIKit

extension UIImage
{
    
    func lyu_updateImage(color:UIColor, alpha:CGFloat = 1.0)-> UIImage {
        return lyu_updateImage(color: color, alpha: alpha, rect: CGRect(origin: CGPoint.zero, size: self.size));
    }
    
    func lyu_updateImage(color:UIColor, alpha:CGFloat = 1, insets:UIEdgeInsets)-> UIImage{
        let originRect = CGRect(origin: CGPoint.zero, size: self.size);
        let tintImageRect = UIEdgeInsetsInsetRect(originRect,insets)
        return lyu_updateImage(color: color, alpha: alpha, rect: tintImageRect);
    }
    /// 全局的初始化方法
  fileprivate  func lyu_updateImage(color:UIColor, alpha:CGFloat = 1.0, rect:CGRect) -> UIImage{
    let imageRect = CGRect(origin: CGPoint.zero, size: self.size);
    
    /// 启动图形上下文
    UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale);
    /// 获取图形的上下文
    let contextRef = UIGraphicsGetCurrentContext();
    // 利用drawInRect方法绘制图片到layer 通常是通过拉伸原有的图片
    self.draw(in: imageRect);
    /// 设置图形上下文的填充颜色
    contextRef?.setFillColor(color.cgColor)
    /// 设置图形上下文的透明度
    contextRef?.setAlpha(alpha)
    /// 设置混合模式
    contextRef?.setBlendMode(.sourceAtop);
    /// 填充当前的rect
    contextRef?.fill(rect);
    
    /// 根据图形的上下文创建一个CGImage图片，并转换成UIImage
    let imageRef = contextRef?.makeImage();
    let tintedImage = UIImage.init(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation);
    // 释放 imageRef，否则内存泄漏
    // 从堆栈的顶部移除图形上下文
    UIGraphicsEndImageContext();
    return tintedImage;
    }
    
    
}
