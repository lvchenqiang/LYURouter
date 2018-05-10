//
//  LYULinearProgressBar.swift
//  LYURouter
//
//  Created by 吕陈强 on 2018/5/1.
//  Copyright © 2018年 吕陈强. All rights reserved.
//

import UIKit

class LYULinearProgressBar: UIView {

    /// The color of progress bar
    @IBInspectable public var foregroundColor: UIColor = UIColor.green
    
    /// The color of the  base layer of bar
    @IBInspectable public var barColor : UIColor = .white
    
    /// The thickness of bar
    @IBInspectable public var barLineHeight: CGFloat = 3
    
    /// Padding on the left, right, top and bottom of the bar, in relation to the track of the progress bar
    @IBInspectable public var barPadding: CGFloat = 0
    
    
    @IBInspectable public var lineCapStyle: CGLineCap = .round {
        didSet{
            self.setNeedsDisplay();
        }
    }
    /// Padding on the track on the progress bar
    @IBInspectable public var trackPadding: CGFloat = 0 {
        didSet {
            if trackPadding < 0 {
                trackPadding = 0
            }else if trackPadding > barLineHeight {
                trackPadding = 0
            }
        }
    }
    /// the value of the progress
    @IBInspectable public var progressValue: CGFloat = 0 {
        didSet {
            progressValue = progressValue.clamped(lowerBound: 0, upperBound: 100)
            setNeedsDisplay()
        }
    }
    
    
    open var barColorForValue: ((Float)->UIColor)?
    
    fileprivate var trackOffset: CGFloat = 0;
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawProgressView()
    }
    
    
}

extension LYULinearProgressBar{
    
    /// Draws a line representing the progress bar
    ///
    /// - Parameters:
    ///   - context: context to be mutated
    ///   - lineWidth: width of track or bar
    ///   - begin: point to begin drawing
    ///   - end: point to end drawing
    ///   - lineCap: lineCap style
    ///   - strokeColor: color of bar
   fileprivate func drawOn(context: CGContext, lineWidth: CGFloat, begin: CGPoint, end: CGPoint, lineCap: CGLineCap, strokeColor: UIColor) {
        context.setStrokeColor(strokeColor.cgColor)
        context.beginPath()
        context.setLineWidth(lineWidth)
        context.move(to: begin)
        context.addLine(to: end)
        context.setLineCap(.round)
        context.strokePath()
    }
    
   fileprivate func drawProgressView() {
    
        guard let context = UIGraphicsGetCurrentContext() else {return}
        let beginPoint = CGPoint(x: barPadding + trackOffset, y: frame.size.height / 2)
        // Progress Bar Track
        drawOn(
            context: context,
            lineWidth: barLineHeight + trackPadding,
            begin: beginPoint,
            end: CGPoint(x: frame.size.width - barPadding - trackOffset, y: frame.size.height / 2),
            lineCap: self.lineCapStyle,
            strokeColor: barColor
        )
        
        // Progress bar
        let colorForBar = barColorForValue?(Float(progressValue)) ?? foregroundColor
        let barforegwidth = barPadding + trackOffset + calculatePercentage()
        debugPrint(barPadding)
        let lineH = barforegwidth == 0 ? 0 : barLineHeight;
        drawOn(
            context: context,
            lineWidth: lineH,
            begin: beginPoint,
            end: CGPoint(x: barforegwidth, y: frame.size.height / 2),
            lineCap: self.lineCapStyle,
            strokeColor: colorForBar
        )
    }
    
    /// Clear graphics context and redraw on bounds change
    func setup() {
        clearsContextBeforeDrawing = true
        self.contentMode = .redraw
        clipsToBounds = false
        backgroundColor = .white
    }
    /// Calculates the percent value of the progress bar
    ///
    /// - Returns: The percentage of progress
    func calculatePercentage() -> CGFloat {
        let screenWidth = frame.size.width - (barPadding * 2) - (trackOffset * 2)
        let progress = ((progressValue / 100) * screenWidth)
        return progress < 0 ? barPadding : progress
    }
    
    
}

extension Comparable {
    func clamped(lowerBound: Self, upperBound: Self) -> Self {
        return min(max(self, lowerBound), upperBound)
    }
}
