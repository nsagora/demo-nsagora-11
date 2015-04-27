 // Playground - noun: a place where people can play

import UIKit
import FunctionalSwift
 
typealias RealFunction = Double -> Double
typealias GraphLine = (function:RealFunction,color:UIColor)

func f(x:Double) -> Double {
    return x
}

func g(x:Double) -> Double {
    return x*x
}

infix operator • {associativity left}
func •<A,B,C>(f:B->C,g:A->B) -> A->C {
    return { x in
        f(g(x))
    }
}

let lines = [
            GraphLine(sin,UIColor.blueColor()),
            GraphLine(g,UIColor.greenColor()),
            GraphLine(sin•{$0*$0},UIColor.redColor()),
            GraphLine(sqrt•g,UIColor.whiteColor()),
]

 let image = graph(lines)


