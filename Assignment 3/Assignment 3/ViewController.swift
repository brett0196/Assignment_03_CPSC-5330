//
//  ViewController.swift
//  Assignment 3
//
//  Created by Brett Williams on 1/28/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var time: UIDatePicker!
    
    @IBOutlet weak var liveClock: UILabel!
    
    @IBOutlet weak var timeLeft: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var background: UIImageView!
    
    var timer: Int = 0
    var leftUpdate: Timer? = nil
    var noTimeLeft: Bool = false
    
    
    let player = NSDataAsset(name: "alarmMusic")?.data
    var audioPlayer: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeCheck()
        clockUpdate()
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(clockUpdate), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCheck), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func timerStart(_ sender: UIButton){
        if(leftUpdate != nil){
            leftUpdate?.invalidate()
            leftUpdate = nil
            noTimeLeft = false
            button.setTitle("Start Timer", for: .normal)
        }else if (noTimeLeft){
            button.setTitle("Start Timer", for: .normal)
            audioPlayer!.stop()
            noTimeLeft = false
        }
        else{
            button.setTitle("Stop Timer", for: .normal)
            time.datePickerMode = .countDownTimer
            
            timer = Int(time.countDownDuration)
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let formattedString = formatter.string(from: TimeInterval(timer))!
            
            timeLeft.text = "Time Remaining: " + formattedString
            
            leftUpdate = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(secondsToTime), userInfo: nil, repeats: true)
            
        }
        
    }
    
    @objc func clockUpdate() {
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss";
        
        let dateTimeString = formatter.string(from: currentDateTime)
        
        liveClock.text = dateTimeString
        
    }
    
    @objc func timeCheck(){
        let currentDateTime = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "a";
        let dateTimeString = formatter.string(from: currentDateTime)
        
        if(dateTimeString == "AM"){
            background.image = UIImage(named: "night")
            timeLeft.textColor = UIColor.white
            liveClock.textColor = UIColor.white
            time.setValue(UIColor.white, forKeyPath: "textColor")
        }else{
            background.image = UIImage(named: "day")
            timeLeft.textColor = UIColor.black
            liveClock.textColor = UIColor.black
            time.setValue(UIColor.black, forKeyPath: "textColor")
        }
    }
    
    @objc func secondsToTime(){
        if(timer == 0){
            leftUpdate?.invalidate()
            leftUpdate = nil
            noTimeLeft = true
            timeLeft.text = "Time Remaining: 00:00:00"
            button.setTitle("Stop Music", for: .normal)
            
            do{
            audioPlayer = try AVAudioPlayer(data: player!)
                audioPlayer.numberOfLoops =  -1
                audioPlayer.play()
            }
            catch{
                fatalError(error.localizedDescription)
            }
            
           
        }
        
        else{
            timer = timer - 1
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.hour, .minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
            
            let formattedString = formatter.string(from: TimeInterval(timer))!
            
            timeLeft.text = "Time Remaining: " + formattedString
        }
        
    }
    
}
