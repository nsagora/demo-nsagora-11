//
//  graph.swift
//  FunctionalSwift
//
//  Created by Ionel Lescai on 27/04/15.
//  Copyright (c) 2015 iosnsagora. All rights reserved.
//

import UIKit

let backgroundColor = UIColor.blackColor()
let lineColor = UIColor.lightGrayColor()
let squareSize:CGFloat = 50

public func graph(lines:[(function:Double->Double,color:UIColor)]) -> UIImage {
    
    let size = CGSize(width: 1000, height: 1000)
    let rect = CGRect(origin: CGPointZero, size: size)
    
    UIGraphicsBeginImageContext(size)
    let context = UIGraphicsGetCurrentContext()
    
    backgroundColor.setFill()
    CGContextFillRect(context, rect)
    
    lineColor.setStroke()
    CGContextSetLineWidth(context, 1.0)
    
    for var i:CGFloat = 0.0; i <= size.width; i += squareSize {
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, i, 0)
        CGContextAddLineToPoint(context, i, size.width)
        CGContextStrokePath(context)
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, 0, i)
        CGContextAddLineToPoint(context, size.width, i)
        CGContextStrokePath(context)
    }
    
    CGContextSetLineWidth(context, 3.0)
    CGContextBeginPath(context)
    CGContextMoveToPoint(context, 500, 0)
    CGContextAddLineToPoint(context, 500, size.width)
    CGContextStrokePath(context)
    
    CGContextBeginPath(context)
    CGContextMoveToPoint(context, 0, 500)
    CGContextAddLineToPoint(context, size.width, 500)
    CGContextStrokePath(context)
    
    var paths = [UIBezierPath]()
    
    for var i = 1; i <= lines.count; i++ {
        let path = UIBezierPath()
        paths.append(path)
    }
    
    CGContextTranslateCTM(context, size.width/2, size.height/2)
    let transform = CGAffineTransformMakeScale(1.0, -1.0)
    CGContextConcatCTM(context, transform);
    
    var first = true
    
    for var i:Double = -10; i <= 10; i += 0.1 {
        for var index = 0; index<lines.count; index++ {
            
            let path = paths[index]
            let f = lines[index].function
            let x = CGFloat(i*50)
            let y = CGFloat(f(i)*50)
            
            let point = CGPoint(x: x,y: y)
            if first {
                path.moveToPoint(point)
            } else {
                path.addLineToPoint(point)
            }
        }
        
        first = false
    }
    
    
    for var index = 0; index<lines.count; index++ {
        let path = paths[index]
        let color = lines[index].color
        color.setStroke()
        path.lineWidth = 2.0
        path.stroke()
    }
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    return image
}

