//
//  ViewController.swift
//  Jumping Kangaroo
//
//  Created by Sun Chung on 12/25/15.
//  Copyright © 2015 anseha. All rights reserved.
//

import UIKit
import AVFoundation

var blueImageCounter = 1

class ViewController: UIViewController  {
    
    // Variables
    var player = AVAudioPlayer()
    var isRunning = true
    var timer = NSTimer()
    var soundTimer = NSTimer()
    var quitTimer = NSTimer()
    var timerBlue = NSTimer()
    var levelTimer = 0.20
    var gameScores = 0
    
    // Outlets
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var scoreDisplay: UILabel!
    @IBOutlet weak var startStopButtonImage: UIButton!
    @IBOutlet weak var progressBar: UISlider!
    
    @IBOutlet weak var quitButton: UIBarButtonItem!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var scoreButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    
    @IBAction func startButtom(sender: AnyObject) {
        
        let audioPath = NSBundle.mainBundle().pathForResource("GameSound1", ofType: "mp3")!
        
        do {
            
            try player = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
            
            player.play()
            
            progressBar.maximumValue = Float(player.duration)
            
            soundTimer = NSTimer.scheduledTimerWithTimeInterval(0.05, target: self, selector: "progress", userInfo: nil, repeats: true)
            
        } catch {
            
            print("Could not find the audio file")
            
        }
        
        buttonStatusPlaying()
        gameStates()
        gameOverTimer()
        message.text = "Kangaroo..."
        scoreDisplay.text = "Your Score"
        blueImageCounter = 11
        gameScores = 0
    
    }
    
    // Reset the High Score to 0
    @IBAction func resetHighScore(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "trackScore")
        yourScoreDisplay()
        
    }
    
    // Display the High Score on the Second line text
    @IBAction func highScoreDisplay(sender: AnyObject) {
        
        let maxScore = NSUserDefaults.standardUserDefaults().objectForKey("trackScore")
        
        if maxScore == nil {
            
        scoreDisplay.text = "No High Score"
            
        } else {
            
            scoreDisplay.text = "High Score \(maxScore!)"
        
        }
    
    }
    
    // Quit the game and reset the dynamic values
    @IBAction func quitGame(sender: AnyObject) {
        
        message.text = "Kangaroo..."
        imageOne.image = UIImage(named: "blueroo10.jpg")
        levelTimer = 0.20
        buttonStatusStoped()
        player.stop()
        timer.invalidate()
        timerBlue.invalidate()
        quitTimer.invalidate()
        
    }
    
    // Start the game and control the game
    @IBAction func startStop(sender: AnyObject) {
        
        gameStates()
    
    }
    
    func gameStates() {
        
        if isRunning == true {                          // Start the game
            
            startStopButtonImage.enabled = true
            
            timerBlue.invalidate()
            
            isRunning = false
            
            if levelTimer >= 0 {
                
                timer = NSTimer.scheduledTimerWithTimeInterval(levelTimer, target: self, selector: Selector("doAnimationOne"), userInfo: nil, repeats: true)
            
            } else {
                
                levelTimer = 0.0001
                timer = NSTimer.scheduledTimerWithTimeInterval(levelTimer, target: self, selector: Selector("doAnimationOne"), userInfo: nil, repeats: true)
            
            }
            
        } else {                                        // Stop the game
            
            timer.invalidate()
            
            isRunning = true
            
            if blueImageCounter == 11 {
                
                gameScores += 10
                levelTimer -= 0.013
                gameStateActions()
                
            } else if blueImageCounter < 11 {
                
                gameScores -= 10
                levelTimer += 0.0011
                gameStateActions()
                
            } else if blueImageCounter > 11 {
                
                gameScores -= 10
                levelTimer += 0.0011
                gameStateActions()
                
            }
            
            // Check the maxScore, if true save the new high value
            let maxScore = NSUserDefaults.standardUserDefaults().objectForKey("trackScore") as? NSInteger
            
            if gameScores > maxScore {
                
                NSUserDefaults.standardUserDefaults().setObject(gameScores, forKey: "trackScore")
                
            }
            
        }
        
    }
    
    // Image mover function
    func doAnimationOne() {
        
        if blueImageCounter >= 20 {
            
            blueImageCounter = 1
            
        } else {
            
            imageOne.image = UIImage(named: "blueroo\(blueImageCounter).jpg")
            
            blueImageCounter++

        }
        
    }
    
    // Display messages according the location of the Kangaroo
    func displayMessages(points: Int) {
        
        if points >= 1 && points < 11 {
            
            message.text = "WAKE UP"
        
        } else if points == 11 {
            
            message.text = "BOINGGG"
        
        } else if points > 11 && points <= 20 {
            
            message.text = "TRY AGAIN"
        
        }
        
    }
    
    // Display current score
    func displayScore(points: Int) {
        
        scoreDisplay.text = "Score \(points)"
        
    }
    
    // Display default score message - used for quit and resart game
    func yourScoreDisplay() {
        
        scoreDisplay.text = "Your Score"
        
    }
    
    // Timer to restart the animation - defalut time = 1 sec
    func timerBlueKangaroo() {
        
        timerBlue = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("gameStates"), userInfo: nil, repeats: true)
        
    }
    
    // Timer for quit game - when music stop, call the quitGame method
    func gameOverTimer() {
        
        quitTimer = NSTimer.scheduledTimerWithTimeInterval(player.duration, target: self, selector: Selector("quitGame:"), userInfo: nil, repeats: false)
        
    }
    
    // Animate the slider - used as progress indicator
    func progress() {
        
        progressBar.value = Float(player.currentTime)
        
    }
    
    func buttonStatusPlaying() {
        
        scoreButton.enabled = false
        resetButton.enabled = false
        startButton.enabled = false
        startStopButtonImage.enabled = true
        quitButton.enabled = true
        
    }
    
    func buttonStatusStoped() {
        
        scoreButton.enabled = true
        resetButton.enabled = true
        startButton.enabled = true
        startStopButtonImage.enabled = false
        quitButton.enabled = false
    
        
    }
    
    func gameStateActions() {
        
        timerBlueKangaroo()
        startStopButtonImage.enabled = false
        displayMessages(blueImageCounter)
        displayScore(gameScores)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        quitButton.enabled = false
        startStopButtonImage.enabled = false
        startStopButtonImage.layer.cornerRadius = 5.0
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}