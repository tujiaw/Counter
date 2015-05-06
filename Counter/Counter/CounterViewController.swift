//
//  CounterViewController.swift
//  Notifications
//
//  Created by tutujiaw on 15/5/5.
//  Copyright (c) 2015年 tutujiaw. All rights reserved.
//

import UIKit

class CounterViewController: UIViewController {
    
    var timeLabel: UILabel?
    var timeButtons: [UIButton] = []
    var startStopButton: UIButton?
    var resetButton: UIButton?
    
    var remainingSeconds: Int = 0 {
        willSet(newSeconds) {
            let mins = newSeconds / 60
            let seconds = newSeconds % 60
            self.timeLabel?.text = NSString(format: "%02d:%02d", mins, seconds) as String
        }
    }
    
    var isStart: Bool = false {
        willSet(newValue) {
            for button in timeButtons {
                enabledButton(button, enabled: !newValue)
            }
            enabledButton(resetButton!, enabled: !newValue)
            
            if newValue {
                timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onTimer:", userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    var timer: NSTimer?
    
    let timeButtonInfos = [("1分", 60), ("3分", 180), ("5分", 300), ("秒", 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        var boundWidth = self.view.bounds.width;
        var boundHeight = self.view.bounds.height;
        
        timeLabel!.frame = CGRectMake(10, 40, boundWidth - 20, 120)
        let gap = (boundWidth - 10*2 - (CGFloat(timeButtons.count)*64)) / CGFloat(timeButtons.count - 1)
        for (index, button) in enumerate(timeButtons) {
            let x = 10 + (64 + gap) * CGFloat(index)
            button.frame = CGRectMake(x, boundHeight - 120, 64, 44)
        }
        startStopButton?.frame = CGRectMake(10, boundHeight - 60, boundWidth - 20 - 100, 44)
        resetButton?.frame = CGRectMake(10 + boundWidth - 20 - 100 + 20, boundHeight - 60, 80, 44)
    }
    
    func initUI() {
        // timeLabel
        timeLabel = UILabel()
        timeLabel?.textColor = UIColor.whiteColor()
        timeLabel?.font = UIFont(name: "Arial", size: 80) // warning
        timeLabel?.backgroundColor = UIColor.blackColor()
        timeLabel?.textAlignment = NSTextAlignment.Center
        self.view.addSubview(timeLabel!)
        
        // timeButtons
        for (index, (title, _)) in enumerate(timeButtonInfos) {
            let button = UIButton()
            button.tag = index
            button.setTitle(title, forState: .Normal)
            button.backgroundColor = UIColor.orangeColor()
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
            button.addTarget(self, action: "timeButtonTapped:", forControlEvents: .TouchUpInside)
            
            timeButtons.append(button)
            self.view.addSubview(button)
        }
        
        println(timeButtons.count)

        // startStopButton
        startStopButton = UIButton()
        startStopButton?.backgroundColor = UIColor.redColor()
        startStopButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startStopButton?.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        startStopButton?.setTitle("启动/停止", forState: .Normal)
        startStopButton?.addTarget(self, action: "startStopButtonTapped:", forControlEvents: .TouchUpInside)
        self.view.addSubview(startStopButton!)
        
        // resetButton
        resetButton = UIButton()
        resetButton?.backgroundColor = UIColor.redColor()
        resetButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        resetButton?.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        resetButton?.setTitle("复位", forState: .Normal)
        resetButton?.addTarget(self, action: "clearButtonTapped:", forControlEvents: .TouchUpInside)
        self.view.addSubview(resetButton!)
        
        remainingSeconds = 0
    }
    
    func timeButtonTapped(sender: UIButton) {
        let (title, seconds) = timeButtonInfos[sender.tag]
        remainingSeconds += seconds
    }
    
    func startStopButtonTapped(sender: UIButton) {
        isStart = !isStart
    }
    
    func clearButtonTapped(sender: UIButton) {
        remainingSeconds = 0
    }
    
    func onTimer(timer: NSTimer) {
        remainingSeconds -= 1
        if remainingSeconds <= 0 {
            remainingSeconds = 0
            isStart = false
            
            let alert = UIAlertView()
            alert.title = "计时完成 !"
            alert.message = ""
            alert.addButtonWithTitle("Ok")
            alert.show()
        }
    }
    
    func enabledButton(button: UIButton, enabled: Bool) {
        button.enabled = enabled
        button.alpha = enabled ? 1.0 : 0.3
    }
}