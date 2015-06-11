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

 func simpleGraph() {
 
 let lines = [
    GraphLine(f,UIColor.blueColor()),
    GraphLine(g,UIColor.greenColor()),
    GraphLine(sin,UIColor.orangeColor())
 ]

 _ = graph(lines)
 }
 
 simpleGraph()
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 func compose(f:RealFunction,_ g:RealFunction) -> RealFunction {
    return { x in
        f(g(x))
    }
 }
 
 func drawComposed() {
    let composed = compose(sqrt, g)
    let composedLine = GraphLine(composed,UIColor.redColor())
    _ = graph([composedLine])
 }
 
 drawComposed()
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

infix operator • {associativity left}
func •<A,B,C>(f:B->C,g:A->B) -> A->C {
    return { x in
        f(g(x))
    }
}

let lines = [
            GraphLine(f,UIColor.blueColor()),
            GraphLine(g,UIColor.greenColor()),
            GraphLine(f • g,UIColor.orangeColor()),
            GraphLine(sin • {$0*$0},UIColor.redColor()),
            GraphLine(sqrt • g,UIColor.whiteColor())
]

 let image = graph(lines)
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 func a(x:Double) -> Double {
    return x + 4
 }
 
(a•g•g)(2)

 
 
 func stuff() -> Optional<Int> {
    return 42
 }
 
 let n = stuff()
 switch(n) {
 case .None:
    print("nil")
 case .Some(let n):
    print(n)
 }
 
 
 
 
 
 
