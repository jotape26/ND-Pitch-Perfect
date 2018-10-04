//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by João Leite on 03/10/18.
//  Copyright © 2018 João Leite. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {

    @IBOutlet weak var lblRecord: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called")
    }

    @IBAction func btnRecordPressed(_ sender: Any) {
        lblRecord.text = "Recording..."
        recordButton.isEnabled = false
        stopButton.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                                 mode: AVAudioSession.Mode.videoRecording,
                                 options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func btnRecordStopPressed(_ sender: Any) {
        lblRecord.text = "Tap to Record"
        recordButton.isEnabled = true
        stopButton.isEnabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
}

