//
//  EffectScreenController.swift
//  Test App
//
//  Created by Jagadeesh Mohan Dommasandra on 12/4/17.
//  Copyright © 2017 Jagadeesh Mohan Dommasandra. All rights reserved.
//

import UIKit
import AVFoundation

class EffectScreenController: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer:AVAudioPlayer!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var receivedAudio:RecordedAudio!
    
    @IBOutlet weak var playingLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        
        audioFile = try!
            AVAudioFile(forReading: receivedAudio.filePathUrl as URL)
        
        audioPlayer = try!
            AVAudioPlayer(contentsOf: self.receivedAudio.filePathUrl as URL)
        audioPlayer.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnSlowPressed(_ sender: UIButton) {
        playRecordedSound(rate: 0.5)
    }
    
    @IBAction func btnFastPressed(_ sender: UIButton) {
        playRecordedSound(rate: 2.5)
    }
    
    @IBAction func btnHighPressed(_ sender: UIButton) {
        playAudioWithVariablePitch(pitch: 1500.0)
    }
    
    @IBAction func btnLowPressed(_ sender: UIButton) {
        playAudioWithVariablePitch(pitch: -1500.0)
    }
    
    @IBAction func btnStopPressed(_ sender: UIButton) {
        resetPlayerAndEngine()
        self.playingLabel.isHidden = true
    }
    
    func updateFileNotFoundLabel() {
        self.playingLabel.text = "Audio File Not Found"
    }
    
    func updateAudioPlayingLabel(){
        self.playingLabel.isHidden = false
        self.playingLabel.text = "Playing..."
    }
    
    func playRecordedSound(rate: Float){
        resetPlayerAndEngine()
        
        updateAudioPlayingLabel()
        
        audioPlayer.enableRate = true
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        resetPlayerAndEngine()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attach(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)
        
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func resetPlayerAndEngine() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playingLabel.isHidden = true
    }
}
