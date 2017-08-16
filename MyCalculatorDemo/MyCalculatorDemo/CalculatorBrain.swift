//
//  CalculatorBrain.swift
//  MyCalculatorDemo
//
//  Created by VoiceBeer on 2017/8/15.
//  Copyright © 2017年 VoiceBeer. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    private var accumulator: Double? //储存操作值, 储存属性
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? { //计算属性
        get {
            return accumulator
        }
    }
    
    //定义一个结构体
    private var pbo: PendingBinaryOperation?
    
    //用于二元运算中, 对应的操作function以及firstOperand还有操作过程perform(with secondOperand: Double)
    //例如一个 2 * 3, function就是 *, firstOperand: 2, secondOperand: 3
    private struct PendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    //枚举数据类型, 这里用于判断是常数、一元、二元运算还是等号
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double) //二元运算, 传入两个Double, 返回一个Double
        case equals
    }
    
    //字典, 用于查操作符对应的操作
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.constant(Double.pi),
        "e" : Operation.constant(M_E),
        "√" : Operation.unaryOperation(sqrt),
        "cos" : Operation.unaryOperation(cos),
        "±" : Operation.unaryOperation({ -$0 }),
        "×" : Operation.binaryOperation({ $0 * $1 }),
        "÷" : Operation.binaryOperation({ $0 / $1 }),
        "+" : Operation.binaryOperation({ $0 + $1 }),
        "−" : Operation.binaryOperation({ $0 - $1 }),
        "=" : Operation.equals
    ]
    
    //此时已经有firstOperand和secondOperand还有对应需要的操作, 然后执行后赋值给accumulator然后把pbo置为nil
    private mutating func performPendingBinaryOperation() {
        if pbo != nil && accumulator != nil {
            accumulator = pbo!.perform(with: accumulator!)
            pbo = nil
        }
    }
    
    //传入操作符后执行对应的操作
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol]{  //首先根据字典operations查出对应的方法(Operation.xxx(xx))
            switch operation { //根据operation后面的跟的xxx是什么来switch对应的操作
            case .constant(let value):
                accumulator = value //常数运算直接显示值
            case .unaryOperation(let function):
                if accumulator != nil {
                    accumulator = function(accumulator!) //一元运算的话将当前的accumulator值作为参数执行对应的例如sqrt(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil { //这里第一次传入的accmulator是PendingBinaryOperation里对应的firstOperand, 然后把accumulator置为nil用于接收secondOperand
                    pbo = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
            }
        }
    }
    
}
