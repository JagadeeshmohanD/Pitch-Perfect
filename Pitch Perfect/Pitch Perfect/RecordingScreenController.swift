//
//  RecordingScreenController.swift
//  Test App
//
//  Created by Jagadeesh Mohan Dommasandra on 12/4/17.
//  Copyright © 2017 Jagadeesh Mohan Dommasandra. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingScreenController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.recordingLabel.isHidden = true
        self.btnStop.isEnabled = false
        self.btnRecord.isEnabled = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        self.recordingLabel.isHidden = false
        self.btnRecord.isEnabled = false;
        self.btnStop.isEnabled = true;
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String

        let recordingName = "audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        audioRecorder.delegate = self

        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecordAudio(sender: UIButton) {
        self.recordingLabel.isHidden = true
        self.btnRecord.isEnabled = true
        self.btnStop.isEnabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(filePahtUrl: recorder.url as NSURL, title: recorder.url.lastPathComponent)
            
            self.performSegue(withIdentifier: "stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC:EffectScreenController = segue.destination as! EffectScreenController
            
            let data = sender as! RecordedAudio
            
            playSoundsVC.receivedAudio = data
        }
    }
}




