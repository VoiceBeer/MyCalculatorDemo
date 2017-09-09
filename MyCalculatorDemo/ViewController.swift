//
//  ViewController.swift
//  MyCalculatorDemo
//  
//  MVC中的C层
//  点击数字按钮对应的 touchDigit(UIButton) , 点击运算符按钮对应的performOperation(UIButton)
//
//  Created by VoiceBeer on 2017/8/14.
//  Copyright © 2017年 VoiceBeer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            // Do any additional setup after loading the view, typically from a nib.
//        }
    //
    //    override func didReceiveMemoryWarning() {
    //        super.didReceiveMemoryWarning()
    //        // Dispose of any resources that can be recreated.
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.addUnaryOperation(named: "✅") { [unowned weakSelf = self] in
            weakSelf.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
    @IBOutlet weak var display: UILabel! //V层中的Label outlet
    
    private var brain = CalculatorBrain() //实例化M层模型
    
    //存储属性
    var userIsInTheMiddleOfTyping = false
    //计算属性
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    //数字按钮对应的action
    //首先判断userIsInTheMiddleOfTyping是否为真, 因为一开始显示的数字是0, 如果这时候敲入数字的话应该是0重置掉直接为第一个数字然后才是再敲一个就排队显示.
    //为真则排队显示,为假则将显示的text置为敲入的数字
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
//            let textCurrentlyInDisplay = display.text!
//            display.text = textCurrentlyInDisplay + digit
            display.text = display.text! + digit
//            print(display.text!)
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
    }
    
    //运算符按钮对应的action
    @IBAction func performOperation(_ sender: UIButton) {
        //如果点击了运算符, 并且已经输入了值, 那么首先将值传入M层, 然后将userIsInTheMiddleOfTyping设置为false, 接下来的输入就是刷新显示区的输入了
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        //将运算符的具体title传入M层用作运算
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        //将M层运算后的结果显示
        if let result = brain.result {
            displayValue = result
        }
    }
    
    
}

